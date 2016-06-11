(*
  This module provides functions for keyboard device file and manage
  uinput device.
*)
module Types = Okeyfum_types
  
type 'a fd
(* The type of file descriptor. This type do not have compatibility Unix.fd *)

type user
type keyboard
(* For phantom type to detect the type of file descriptor  *)

val open_with : ?grab:bool -> dev:string -> f:(user:user fd -> keyboard:keyboard fd -> unit)
  -> unit -> unit
(* [open_with ?grab ~dev ~f ()] open keyboard device [dev] and create user device via uinput.
   After successful user device creation, execute [f] with two file descriptor that are user device and keyboard device.

   This function do not grab keyboad device if [grab] is false. The default value of [grab] is true.
*)

val read_key : keyboard fd -> Types.Input_event.t
(* [read_key fd] read a key from keyboard device. Notice this function is block execution *)

val write_key : user fd -> Types.Input_event.t -> unit
(* [write_key fd key] write a key to created user device. *)
