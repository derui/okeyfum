(*
  This module provides environment type and manipulate functions.
*)

(* The environment of this application *)
type t

val make : Okeyfum_config.Config.t -> t
(* [make config] make new environment created from [config] *)

val lock_state_lock : env:t -> name:string -> unit
(* [lock_state_lock ~env ~name] change state of lock [name] to locked *)

val lock_state_unlock : env:t -> name:string -> unit
(* [lock_state_unlock ~env ~name] change state of lock [name] to unlocked *)

val lock_state_toggle : env:t -> name:string -> unit
(* [lock_state_toggle ~env ~name] change state of lock [name] to invert current state in [env] *)

val enable_converter: t -> t
(* [enable_converter env] enable converter for key input event. *)

val disable_converter: t -> t
(* [disable_converter env] disable converter for key input event. *)

val is_enable: t -> bool
(* [is_enable env] get current state for enabling converter. *)
