
type level = DEBUG | INFO | ERROR

let level_to_string = function
  | DEBUG -> "debug"
  | INFO -> "info"
  | ERROR -> "error"

let level_to_int = function
  | DEBUG -> 0
  | INFO -> 1
  | ERROR -> 2

let lower_log_level = ref INFO

let set_log_level level = lower_log_level := level
let get_log_level () = !lower_log_level

let output_log ~log ~level =
  let current = level_to_int !lower_log_level
  and level_order = level_to_int level in

  if level_order >= current then
    Printf.printf "[%-05s] %s\n" (level_to_string level) log
  else ()

let debug log = output_log ~level:DEBUG ~log
let info log = output_log ~level:INFO ~log
let error log = output_log ~level:ERROR ~log
