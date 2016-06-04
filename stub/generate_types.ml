open Ctypes

let () =
  print_endline "#include <linux/input.h>";
  Cstubs.Types.write_c Format.std_formatter (module Ffi_bindings.Types)
