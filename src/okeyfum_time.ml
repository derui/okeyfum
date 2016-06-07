open Ctypes
open Foreign

module Types = Okeyfum_types

module Inner = struct
  let gettimeofday = foreign "gettimeofday" ~check_errno:true
    (ptr Types.Timeval.t @-> Types.Timezone.t @-> returning int)
end

(* Get time when execute this function *)
let now () =
  let time = {
      Types.Timeval.tv_sec = PosixTypes.Time.of_int 0;
      tv_usec = 0L;
  } in
  let time = Types.Timeval.of_ocaml time in
  (* gettimeofday's timezone should give null *)
  
  Inner.gettimeofday (addr time) (coerce (ptr void) Types.Timezone.t null) |> ignore;
  Types.Timeval.to_ocaml time
  
