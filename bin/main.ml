open Okeyfum
module Keyboard_device = Okeyfum_keyboard_device
module Log = Okeyfum_log

let default_config_file = ".okeyfum"

let usage = "usage: okeyfum [options] <device>"

(* loading config *)
let load_config file =
  let module C = Okeyfum_config in
  let default_config = Filename.concat (Sys.getenv "HOME") default_config_file in
  let file = match String.trim file with "" -> default_config | _ -> file in

  if not (Sys.file_exists file) then (
    Log.info (Printf.sprintf "Don't load configuration %s, so use empty configuratino " file);
    Some C.Config.empty )
  else C.load file

let () =
  let debug_mode = ref false in
  let device = ref "" in
  let config = ref "" in
  let grab = ref true in
  let spec_list =
    [
      ("-d", Arg.Unit (fun () -> debug_mode := true), "Print debug informations");
      ("-f", Arg.String (fun s -> config := s), "The path of OKeyfum config file");
      ("-no-grab", Arg.Unit (fun () -> grab := false), "Disable grabbing keyboard device");
    ]
  in

  Arg.parse_argv Sys.argv spec_list (fun x -> device := x) usage;

  if !debug_mode then Log.set_log_level Log.DEBUG else ();

  Log.info "Launch Okeyfum";
  Log.debug (Printf.sprintf "Given device name : %s" !device);

  ( match load_config !config with
  | None        -> Log.error (Printf.sprintf "Not found specified config file: %s" !config)
  | Some config ->
      if !device = "" then (
        Log.error "Not specitied keyboard device";
        exit 2 )
      else
        let module H = Okeyfum_handler in
        Keyboard_device.open_with ~grab:!grab ~dev:!device ~f:(H.handle_key_event config) () );
  Log.info "Finish termination Okeyfum"
