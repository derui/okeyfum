open Ctypes

(* utility function to convert int to void ptr *)
let int_to_voidp n = Nativeint.of_int n |> ptr_of_raw_address

let protect ~f ~finally =
  try
    f ();
    finally ()
  with e -> begin
    finally ();
    raise e;
  end

let option_get = function
  | Some s -> s
  | None -> failwith "None to get something"
