(*
  This module provides utility functions for key code and name.
*)

val key_name_to_code: string -> int option
(* [key_name_to_code ~env ~name] convert key name to key code. *)

val key_code_to_name: int -> string option
(* [key_code_to_name ~env ~name] convert key code to key name. *)
