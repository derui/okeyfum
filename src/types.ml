open Ctypes

module T = Ffi_bindings.Types(Ffi_generated_types)

(* Posix timeval integration *)
module Timeval = struct
  type t = {
    tv_sec: PosixTypes.time_t;
    tv_usec: int64;
  }

  let t : t structure typ = structure "timeval"

  let tv_sec = field t "tv_sec" PosixTypes.time_t
  let tv_usec = field t "tv_usec" int64_t

  let to_ocaml t = {
    tv_sec = getf t tv_sec;
    tv_usec = getf t tv_usec |> Signed.Int64.to_int64
  }

  let of_ocaml o =
    let ret = make t in
    setf ret tv_sec (o.tv_sec);
    setf ret tv_usec Signed.Int64.(of_int64 o.tv_usec);
    ret

  let () = seal t
end

(* The module for linux's input_event struct *)
module Input_event = struct

  type t = {
    time: Timeval.t;
    typ: int;
    code: int;
    value: int64;
  }

  let t : t structure typ = structure "input_event"

  let time = field t "time" Timeval.t
  let typ = field t "type" uint16_t
  let code = field t "code" uint16_t
  let value = field t "value" int32_t

  let to_ocaml t = {
    time = getf t time |> Timeval.to_ocaml;
    typ = getf t typ |> Unsigned.UInt16.to_int;
    code = getf t code |> Unsigned.UInt16.to_int;
    value = getf t value |> Signed.Int32.to_int64;
  }

  let of_ocaml o =
    let ret = make t in
    let (|<) r v = setf ret r v in
    time |< (Timeval.of_ocaml o.time);
    typ |< Unsigned.UInt16.(of_int o.typ);
    code |< Unsigned.UInt16.(of_int o.code);
    value |< Signed.Int32.(of_int64 o.value);
    ret

  let () = seal t
end
