open Ctypes

(* utility function to convert int to void ptr *)
let int_to_voidp n = Nativeint.of_int n |> ptr_of_raw_address

let protect ~f ~finally =
  try
    f ();
    finally ()
  with e ->
    finally ();
    raise e

let is_some = function Some _ -> true | None -> false

let option_get = function Some s -> s | None -> failwith "None to get something"

module T = Okeyfum_types
module IE = Okeyfum_types.Input_event
module K = Okeyfum_key
module GT = Okeyfum_c_type_description.Types (Okeyfum_c.Okeyfum_c_generated_types)

let event_to_state { IE.value; _ } = match value with 0L -> `UP | _ -> `DOWN

let event_to_key_of_map event =
  let state = event_to_state event in
  match K.key_code_to_name event.IE.code with
  | None   ->
      let module L = Okeyfum_log in
      L.debug (Printf.sprintf "Not defined key code: %d" event.IE.code);
      None
  | Some k -> Some (k, state)
