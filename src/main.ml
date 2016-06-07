module Keyboard_device = Okeyfum_keyboard_device
module Log = Okeyfum_log

let usage = "usage: okeyfum [options] <device>"

let loop ~user ~keyboard =
  let rec loop' () =
    let key = Keyboard_device.read_key keyboard in
    Keyboard_device.write_key user key;

    loop' ()
  in

  loop' ()

let () =
  let debug_mode = ref false in
  let device = ref "" in
  let spec_list = [
    ("-d", Arg.Unit (fun () -> debug_mode := true), "Print debug informations");
  ] in

  Arg.parse_argv Sys.argv spec_list (fun x -> device := x) usage;

  if !debug_mode then Log.set_log_level Log.DEBUG else ();

  Log.debug (Printf.sprintf "Given device name : %s" !device);

  if !device = "" then begin
    Log.error "Not specitied keyboard device";
    exit 2
  end else
    Keyboard_device.open_with ~dev:!device ~f:loop

