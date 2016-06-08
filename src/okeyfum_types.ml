open Ctypes

module T = Okeyfum_ffi_bindings.Types(Okeyfum_ffi_generated_types)

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

  let empty = {tv_sec = PosixTypes.Time.zero; tv_usec = 0L}

  let () = seal t
end

module Timezone = struct
  type _t
  let _t : _t structure typ = structure "timezone"
  type t = _t structure ptr
  let t = ptr _t
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

  let empty = {
    time = Timeval.empty;
    typ = 0;
    code = 0;
    value = 0L;
  }

  let () = seal t
end

module Input_id = struct
  type t = {
    bustype: int;
    vendor: int;
    product: int;
    version: int;
  }

  let t : t structure typ = structure "input_id"

  let bustype = field t "bustype" uint16_t
  let vendor = field t "vendor" uint16_t
  let product = field t "product" uint16_t
  let version = field t "version" uint16_t

  let to_ocaml t = {
    bustype = Unsigned.UInt16.(getf t bustype |> to_int);
    vendor = Unsigned.UInt16.(getf t vendor |> to_int);
    product = Unsigned.UInt16.(getf t product |> to_int);
    version = Unsigned.UInt16.(getf t version |> to_int);
  }

  let of_ocaml o =
    let t = make t in
    setf t bustype Unsigned.UInt16.(of_int o.bustype);
    setf t vendor Unsigned.UInt16.(of_int o.vendor);
    setf t product Unsigned.UInt16.(of_int o.product);
    setf t version Unsigned.UInt16.(of_int o.version);
    t

  let () = seal t
end

module Uinput_user_dev = struct
  type t = {
    name: string;
    id: Input_id.t;
    ff_effects_max: int;
    absmax: int32 list;
    absmin: int32 list;
    absfuzz: int32 list;
    absflat: int32 list;
  }

  let t : t structure typ = structure "uinput_user_dev"

  let name = field t "name" (array T.Uinput.max_name_size char)
  let id = field t "id" Input_id.t
  let ff_effects_max = field t "ff_effects_max" int32_t
  let absmax = field t "absmax" (array T.Input_abs.abs_cnt int32_t)
  let absmin = field t "absmin" (array T.Input_abs.abs_cnt int32_t)
  let absfuzz = field t "absfuzz" (array T.Input_abs.abs_cnt int32_t)
  let absflat = field t "absflat" (array T.Input_abs.abs_cnt int32_t)

  let to_ocaml t = {
    name = getf t name |> CArray.start |> string_from_ptr ~length:T.Uinput.max_name_size;
    id = getf t id |> Input_id.to_ocaml;
    ff_effects_max = getf t ff_effects_max |> Signed.Int32.to_int;
    absmax = getf t absmax |> CArray.to_list;
    absmin = getf t absmin |> CArray.to_list;
    absfuzz = getf t absfuzz |> CArray.to_list;
    absflat = getf t absflat |> CArray.to_list;
  }

  let of_ocaml o =
    let t = make t in
    let name' = CArray.make char ~initial:(Char.chr 0) T.Uinput.max_name_size in
    String.iteri (fun ind c -> CArray.set name' ind c) o.name;
    setf t name name';
    setf t id (Input_id.of_ocaml o.id);
    setf t ff_effects_max Signed.Int32.(of_int o.ff_effects_max);
    setf t absmax CArray.(of_list int32_t o.absmax);
    setf t absmin CArray.(of_list int32_t o.absmin);
    setf t absfuzz CArray.(of_list int32_t o.absfuzz);
    setf t absflat CArray.(of_list int32_t o.absflat);
    t

  let () = seal t
end

type state = [`UP | `DOWN]
type expanded_key =
    Key of Input_event.t
  | Func of string * string list
