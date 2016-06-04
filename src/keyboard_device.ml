(* This module provides functions for keyboard device file and manage
   uinput device.
*)
open Ctypes
open Foreign

(* Paths of uinput device. *)
let uinput_paths = ["/dev/uinput"; "/dev/input/uinput"]

type fd = int

module T = 

module Inner = struct
  let dev_open = foreign "open" (string @-> int @-> returning int)
  let dev_read = foreign "open" (string @-> int @-> returning int)
  let dev_close = foreign "close" (int @-> returning int)
  let ioctl = foreign "ioctl" (int @-> int64_t @-> ptr void @-> returning int)
end

let open_with ~dev ~f =
  
