open Ctypes

let () =
  print_endline "#include <linux/input.h>";
  print_endline "#include <fcntl.h>";
  print_endline "#include <linux/uinput.h>";
  Cstubs.Types.write_c Format.std_formatter (module Ffi_bindings.Types)
