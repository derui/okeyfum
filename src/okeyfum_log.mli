(* This module provides very simple loggind tool *)

type level = DEBUG | INFO | ERROR
(* The levels of logging *)

val set_log_level : level -> unit
(* [set_log_level level] set new log level for lower limit. *)

val get_log_level : unit -> level
(* [get_log_level ()] get current log level for lower limit. *)

val debug : string -> unit
(* [debug log] output given log as [DEBUG] level. Do not output log if log level is
   upper than [DEBUG]
*)

val info : string -> unit
(* [info log] output given log as [INFO] level. Do not output log if log level is
   upper than [INFO]
*)

val error : string -> unit
(* [error log] output given log as [ERROR] level. Do not output log if log level is
   upper than [ERROR]
*)
