let usage = "usage: okeyfum [options] <device>"

let () =
  let debug_mode = ref false in
  let device = ref "" in
  let spec_list = [
    ("-d", Arg.Unit (fun () -> debug_mode := true), "Print debug informations");
    ("<keyboard device>", Arg.Rest (fun file -> device := file), "Target keyboard device path")
  ] in

  Arg.parse_argv Sys.argv spec_list (fun x -> raise (Arg.Bad ("Bad argument : " ^ x)))
    usage;

  Keyboard_device.open_with ~dev:!device ~f:ignore
