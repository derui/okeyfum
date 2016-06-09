(* This module provide read and parse config from file *)
open Lexing

module T = Okeyfum_types
module Config_type = Okeyfum_config_type
module Config_parser = Okeyfum_config_parser
module Config_lexer = Okeyfum_config_lexer

module Keydef_map = Map.Make(struct
  type t = string * T.state
  let compare (aa, ab) (ba, bb) =
    let key_compared = Pervasives.compare aa ba in
    if key_compared <> 0 then key_compared
    else
      match ab, bb with
      | `UP, `DOWN -> -1
      | `DOWN, `UP -> 1
      | _ -> 0
end)

let print_position outx lexbuf =
  let pos = lexbuf.lex_curr_p in
  Printf.fprintf outx "%s:%d:%d" pos.pos_fname
    pos.pos_lnum (pos.pos_cnum - pos.pos_bol + 1)

let parse_with_error lexbuf =
  try Config_parser.parser_main Config_lexer.token lexbuf with
  | Config_parser.Error -> Printf.fprintf stderr "%a: syntax error\n" print_position lexbuf;
    exit (-1)

module Config : sig
  (* The type of key sequence *)
  type key = [`Var of string | `Id of string | `Func of string * string list]

  (* The type of key-sequences related key name and state *)
  type keydef_map = key list Keydef_map.t

  (* The type of key-sequences when a lock key is locked *)
  type lock_decl = string * keydef_map

  (* The type of configuration *)
  type t

  val variable_map : t -> (string, key list) Hashtbl.t
  (* [variable_map t] get the map of variable of [t] *)

  val lock_decls : t -> lock_decl list
  (* [lock_decls t] get the lock declarations of [t] *)

  val lock_defs : t -> string list
  (* [lock_defs t] get the lock key definitions of [t] *)

  val keydef_map : t -> keydef_map
  (* [keydef_map t] get the key definition that is key sequence of [t] *)

  val empty : t
  val make : Config_type.main -> t
(* [make prog] create the new configuration from tree of configuration DSL *)

end = struct

  type key = [`Var of string | `Id of string | `Func of string * string list]

  type keydef_map = key list Keydef_map.t
  type lock_decl = string * keydef_map

  type t = {
    variable_map: (string, key list) Hashtbl.t;
    lock_decls: lock_decl list;
    lock_defs: string list;
    keydef_map: keydef_map; (* key-definition map *)
  }

  let variable_map {variable_map;_} = variable_map
  let lock_decls {lock_decls;_} = lock_decls
  let lock_defs {lock_defs;_} = lock_defs
  let keydef_map {keydef_map;_} = keydef_map

  (* expression to key definition *)
  let exp_to_key = function
    | Config_type.Cexp_ident id -> `Id id
    | Config_type.Cexp_var v -> `Var v
    | Config_type.Cexp_funcall (fname, params) -> `Func (fname, params)

  (* convert statement to key sequence *)
  let stmt_to_sequence map = function
    | Config_type.Cstm_key (Config_type.Cexp_ident key, state, seqs) ->
       Keydef_map.add (key, state) (List.map exp_to_key seqs) map
    | _ -> failwith "Only key definition to be able to convert sequence"

  (* convert statement to lock declaration *)
  let stmt_to_decl = function
    | Config_type.Cstm_lock (Config_type.Cexp_ident lock_name, seqs) ->
       let m = Keydef_map.empty in
       (lock_name, List.fold_left stmt_to_sequence m  seqs)
    | _ -> failwith "Lock declaration only"

  (* convert statement to lock key definition *)
  let stmt_to_lockdef = function
    | Config_type.Cstm_deflock (Config_type.Cexp_ident lock_name) ->
       lock_name
    | _ -> failwith "Lock key definition only"

  (* convert statement to variable *)
  let stmt_to_variable m = function
    | Config_type.Cstm_defvar (Config_type.Cexp_var name, seqs) ->
       Hashtbl.add m name (List.map exp_to_key seqs);
      m
    | _ -> failwith "Variable definition only"

  (* build config from parsed configurations *)
  let rec build_statement config stmts =
    match stmts with
    | [] -> config
    | stmt :: rest -> begin
      match stmt with
      | Config_type.Cstm_lock _ -> build_statement {config with
        lock_decls = (stmt_to_decl stmt) :: config.lock_decls
      } rest
      | Config_type.Cstm_key _ ->
         let keydef_map' = stmt_to_sequence config.keydef_map stmt in
         build_statement {config with keydef_map = keydef_map'} rest
      | Config_type.Cstm_deflock _ ->
         let lockdef' = stmt_to_lockdef stmt in
         build_statement {config with lock_defs = lockdef' :: config.lock_defs} rest
      | Config_type.Cstm_defvar _ ->
         let variable_map' = stmt_to_variable config.variable_map stmt in
         build_statement {config with variable_map = variable_map'} rest
    end

  let empty = {
    variable_map = Hashtbl.create 100;
    lock_decls = [];
    lock_defs = [];
    keydef_map = Keydef_map.empty;
  }

  let make = function
    | Config_type.Cprog_main stmts -> build_statement empty stmts

end

let parse_and_print lexbuf =
  match parse_with_error lexbuf with
  | Some prog -> Some (Config.make prog)
  | None -> None

let load filename =
  let inx = open_in filename in
  let lexbuf = Lexing.from_channel inx in
  lexbuf.lex_curr_p <- {lexbuf.lex_curr_p with pos_fname = filename};
  let config = parse_and_print lexbuf in
  close_in inx;
  config
