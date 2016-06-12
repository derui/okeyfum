{
  open Okeyfum_config_parser

  let next_line lexbuf = Lexing.new_line lexbuf

  let has_line_terminator text =
    let regexp = Str.regexp ".*\\(\r\\|\n\\|\r\n\\)" in
    Str.string_partial_match regexp text 0

  let to_keyword = function
    | "deflock"  ->  KEYWORD_DEFLOCK
    | "lock"  ->  KEYWORD_LOCK
    | "defvar"  ->  KEYWORD_DEFVAR
    | "key"  ->  KEYWORD_KEY
    | "up"  ->  KEYWORD_UP
    | "down"  ->  KEYWORD_DOWN
    | s -> failwith ("Unknown keyword: " ^ s)
}
let line_terminator = ['\n' '\r'] | "\r\n"
let white_space = [' ' '\t' '\x0b' '\x0c' '\xa0']
let variable_start = '$'
let identifier_start = ['a'-'z' 'A'-'Z'] | '_'
let reserved_word = "deflock" | "defvar" | "lock" | "key" | "up" | "down"

(* Parsing rule for config *)
rule token = parse
  | eof {EOF}
  | white_space {token lexbuf}
  | line_terminator {next_line lexbuf; token lexbuf}
  | "#" { single_line_comment (Buffer.create 1) lexbuf}
  | '{' { LCBRACE }
  | '}' { RCBRACE }
  | '(' { LPAREN }
  | ')' { RPAREN }
  | '=' { EQ }
  | ',' { COMMA }
  | reserved_word { to_keyword (Lexing.lexeme lexbuf)}
  | identifier_start (identifier_start | ['0'-'9'])* as ident {IDENT(ident)}
  | variable_start (identifier_start | ['0'-'9'])* as ident {VARIABLE(ident)}
  | '&' identifier_start (identifier_start | ['0'-'9'])* as ident {FUNCTION(ident)}

and single_line_comment buf = parse
    | line_terminator {next_line lexbuf;token lexbuf}
    | _ {
      single_line_comment buf lexbuf
    }
