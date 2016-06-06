(* This module provide read and parse config from file *)
open Lexing

type t

let print_position outx lexbuf =
  let pos = lexbuf.lex_curr_p in
  Printf.fprintf outx "%s:%d:%d" pos.pos_fname
    pos.pos_lnum (pos.pos_cnum - pos.pos_bol + 1)

let parse_with_error lexbuf =
  try Config_parser.parser_main Config_lexer.token lexbuf with
  | Config_parser.Error -> Printf.fprintf stderr "%a: syntax error\n" print_position lexbuf;
    exit (-1)

module Config = struct
  module Keydef_map = Map.Make(struct
    type t = string * Config_type.state
    let compare (aa, ab) (ba, bb) =
      let key_compared = Pervasives.compare aa ba in
      if key_compared <> 0 then key_compared
      else
        match ab, bb with
        | `UP, `DOWN -> -1
        | `DOWN, `UP -> 1
        | _ -> 0
  end)

  module Lockdef_map = Map.Make(struct
    type t = string
    let compare = Pervasives.compare
  end)

  type key = [`Var of string | `Id of string]

  type keydef_map = key list Keydef_map.t
  type lock_decl = string * keydef_map
  type lock_def = string

  type t = {
    key_map: (string, int) Hashtbl.t;
    variable_map: (string, key list) Hashtbl.t;
    lock_decls: lock_decl list;
    lockdef_map: string Lockdef_map.t;
    keydef_map: key list Keydef_map.t; (* key-definition map *)
  }

  (* expression to key definition *)
  let exp_to_key = function
    | Config_type.Cexp_ident id -> `Id id
    | Config_type.Cexp_var v -> `Var v

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
  let stmt_to_lockdef m = function
    | Config_type.Cstm_deflock (Config_type.Cexp_ident lock_name, Confid_type.Cexp_ident key) ->
       Lockdef_map.add lock_name key m
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
      | Config_type.Cstm_lock _ -> apply_statement {config with
        lock_decls = (stmt_to_decl stmt) :: config.lock_decls
      } rest
      | Config_type.Cstm_key _ ->
         let keydef_map' = stmt_to_sequence config.keydef_map stmt in
         build_statement {config with keydef_map = keydef_map'} rest
      | Config_type.Cstm_deflock _ ->
         let lockdef_map' = stmt_to_lockdef config.lockdef_map stmt in
         build_statement {config with lockdef_map = lockdef_map'} rest
      | Config_type.Cstm_defvar _ ->
         let variable_map' = stmt_to_variable config.variable_map stmt in
         build_statement {config with variable_map = variable_map'} rest
    end

  let make = function
    | Config_type.Cprog_main stmts -> build_statement {
      key_map = Hashtbl.create 100;
      variable_map = Hashtbl.create 100;
      lock_decls = [];
      lockdef_map = Lockdef_map.empty;
      keydef_map = Keydef_map.empty;
    } stmts

end

let program_to_config prog =
  None

let parse_and_print lexbuf =
  match parse_with_error lexbuf with
  | Some prog ->
     Some (program_to_config prog)
  | None -> None

let load filename =
  let inx = open_in filename in
  let lexbuf = Lexing.from_channel inx in
  lexbuf.lex_curr_p <- {lexbuf.lex_curr_p with pos_fname = filename};
  let config = parse_and_print lexbuf in
  close_in inx;
  config
