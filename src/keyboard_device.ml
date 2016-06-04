open Ctypes
open Foreign

(* Paths of uinput device. *)
let uinput_paths = ["/dev/uinput"; "/dev/input/uinput"]

type 'a fd = int
  
type user
type keyboard

module T = Ffi_bindings.Types(Ffi_generated_types)

module Inner = struct
  let dev_open = foreign "open" ~check_errno:true (string @-> int @-> returning int)
  let dev_read = foreign "read" ~check_errno:true (int @-> ptr void @-> size_t @-> returning size_t)
  let dev_write = foreign "write" ~check_errno:true (int @-> ptr void @-> size_t @-> returning size_t)
  let dev_close = foreign "close" ~check_errno:true (int @-> returning int)
  let ioctl = foreign "ioctl" ~check_errno:true (int @-> int64_t @-> ptr void @-> returning int)
end

(* Inner utility function to initialize all key state as released. *)
let release_all_keys fd = 
  let module U = Types.Input_event in
  let module UI = T.Uinput in
  let input = {
    U.time = Time.now ();
    typ = T.Event_type.ev_key;
    value = 0L;
    code = 0;
  } in

  let keys = Array.make 256 0 in
  Array.iteri (fun ind _ ->
    let data = U.(of_ocaml {input with U.code = ind} |> addr |> to_voidp) in
    Inner.dev_write fd data (sizeof U.t |> Unsigned.Size_t.of_int) |> ignore
  ) keys

(* Open uinput device *)
let open_user_dev () =
  let fd = List.fold_left (fun fd path ->
    if fd >= 0 then fd
    else Inner.dev_open path T.Open_flag.wronly
  ) (-1) uinput_paths in
  if fd < 0 then failwith "Not found any uinput device"
  else begin
    release_all_keys fd;
    fd
  end

(* Close and destroy user device *)
let close_user_dev fd =
  release_all_keys fd;
  Inner.ioctl fd Signed.Int64.(of_int T.Uinput.ui_dev_destroy) null |> ignore;
  Inner.dev_close fd |> ignore

(* Create new user input device *)
let create_user_dev fd =
  let module U = Types.Uinput_user_dev in
  let module UI = T.Uinput in 
  let udev = {
    U.name = "okeyfum";
    id = {
      Types.Input_id.bustype = T.Input_bus.bus_virtual;
      vendor = 1;
      product = 1;
      version = 1;
    };
    ff_effects_max = 0;
    absmax = [];
    absmin = [];
    absfuzz = [];
    absflat = [];
  } in
  let udev = U.of_ocaml udev in
  Inner.dev_write fd (to_voidp (addr udev)) (sizeof U.t |> Unsigned.Size_t.of_int) |> ignore;
  List.iter (fun ev ->
    Inner.ioctl fd Signed.Int64.(of_int UI.ui_set_evbit) (Util.int_to_voidp T.Event_type.ev_key)
                |> ignore
  ) [T.Event_type.ev_key; T.Event_type.ev_rep];

  let keys = Array.make 256 0 in
  Array.iteri (fun ind _ ->
    Inner.ioctl fd Signed.Int64.(of_int UI.ui_set_keybit) (Util.int_to_voidp ind) |> ignore
  ) keys;
  Inner.ioctl fd Signed.Int64.(of_int UI.ui_dev_create) null |> ignore

(* Open keyboard device *)
let open_key_dev dev = 
  let fd = Inner.dev_open dev T.Open_flag.wronly in
  if fd < 0 then failwith "Not found specified keyboard device"
  else begin
    Inner.ioctl fd Signed.Int64.(of_int T.Input_ioctl.grab) (Util.int_to_voidp 1) |> ignore;
    release_all_keys fd;
    fd
  end

(* Close keyboard device *)
let close_key_dev fd =
  release_all_keys fd;
  Inner.ioctl fd Signed.Int64.(of_int T.Input_ioctl.grab) (Util.int_to_voidp 0) |> ignore;
  Inner.dev_close fd |> ignore

let open_with ~dev ~f =
  let fd : keyboard fd ref = ref (-1)
  and ufd : user fd ref = ref (-1) in

  try
    Util.protect ~f:(fun () ->
      Log.debug ("Grabbing device : " ^ dev);
      fd := open_key_dev dev;
      Log.debug ("Grabbing device is success!: " ^ dev);

      Util.protect ~f:(fun () ->
        Log.debug ("Creating user device : " ^ dev);
        ufd := open_user_dev ();
        create_user_dev !ufd;
        Log.debug ("Creating user device is success!: " ^ dev);

        f ~user:!ufd ~keyboard:!fd
      ) ~finally:(fun () -> close_user_dev !ufd)
        
    ) ~finally:(fun () -> close_key_dev !fd)
  with 
  | Unix.Unix_error (e, fname, param) -> begin
    let e = Unix.error_message e in
    Log.error (Printf.sprintf "Unix error occured! => %s [%s(%s)]" e fname param)
  end


let read_key fd =
  let module U = Types.Input_event in
  let module UI = T.Uinput in
  let output = U.empty in
  
  let data = U.(of_ocaml output) in
  let refs = addr data |> to_voidp in
  Inner.dev_read fd refs (sizeof U.t |> Unsigned.Size_t.of_int) |> ignore;
  U.to_ocaml data

let write_key fd data =
  let module U = Types.Input_event in
  let module UI = T.Uinput in

  let data = U.(of_ocaml data) |> addr |> to_voidp in
  Inner.dev_write fd data (sizeof U.t |> Unsigned.Size_t.of_int) |> ignore;
