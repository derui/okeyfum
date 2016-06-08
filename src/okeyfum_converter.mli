(*
  This module provides the converter key sequence to new key sequence.
  Conversion of key sequence is controlled by the configuration user defined.
*)

module T = Okeyfum_types

val handle_key_event: env:Okeyfum_environment.t -> event:T.Input_event.t -> T.Input_event.t list
(* [handle_key_event ~env ~event] handle key event [event] with envitonment [env].
   Result from this function depends on configuration and current state of environment,
   such as return empty list if event is as locking key.
*)

