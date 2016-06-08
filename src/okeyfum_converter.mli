(*
  This module provides the converter key sequence to new key sequence.
  Conversion of key sequence is controlled by the configuration user defined.
*)

module T = Okeyfum_types

val convert_event_to_seq: config:Okeyfum_config.Config.t ->
  env:Okeyfum_environment.t -> event:T.Input_event.t -> T.expanded_key list
(* [handle_key_event ~config ~env ~event] handle key event [event] with envitonment [env].
   Result from this function depends on configuration and current state of environment,
   such as return empty list if event is as locking key.
*)

