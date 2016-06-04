open Ctypes

(* utility function to convert int to void ptr *)
let int_to_voidp n =
  let ary = Bigarray.Array1.of_array Bigarray.int Bigarray.c_layout [|n|] in
  array_of_bigarray array1 ary |> CArray.start |> to_voidp

let protect ~f ~finally =
  try
    f ();
    finally ()
  with e -> begin
    finally ();
    raise e;
  end
