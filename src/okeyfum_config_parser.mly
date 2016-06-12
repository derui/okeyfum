%{
 exception SyntaxError of string
 module Config_type = Okeyfum_config_type
%}

(* punctuators *)
%token LCBRACE RCBRACE EQ COMMA LPAREN RPAREN AND

(* keyword *)
%token KEYWORD_DEFLOCK
%token KEYWORD_LOCK KEYWORD_DEFVAR KEYWORD_KEY KEYWORD_UP KEYWORD_DOWN

(* %token <string> WHITE_SPACE *)
(* %token <string> LINE_TERMINATOR *)

%token <string> VARIABLE
%token <string> IDENT
%token <string> FUNCTION
%token EOF
%start parser_main
%type <Okeyfum_config_type.main option> parser_main
%%

parser_main:
EOF {None}
   |config EOF {Some $1}
  ;

  config:
    statements { Config_type.Cprog_main ($1)}
  ;

  statements:
    statement { [$1]}
   |statements statement { $1 @ [$2] }
  ;

  statement:
    key_statement { $1 }
   |deflock_statement { $1 }
   |lock_statement { $1 }
   |defvar_statement { $1 }
  ;

  key_statement:
    KEYWORD_KEY key_state identifier EQ key_sequences {Config_type.Cstm_key ($3, $2, $5)}
  ;

  key_state:
    KEYWORD_UP {`UP}
   |KEYWORD_DOWN {`DOWN}
  ;

  deflock_statement:
    KEYWORD_DEFLOCK ident=identifier {
      match ident with
      | Config_type.Cexp_ident _ -> Config_type.Cstm_deflock(ident)
      | _ -> failwith "deflock only apply identifier"
    }
  ;

  lock_statement:
    KEYWORD_LOCK identifier LCBRACE list(key_statement) RCBRACE { Config_type.Cstm_lock ($2, $4)}
  ;

  defvar_statement:
    KEYWORD_DEFVAR variable EQ key_sequences { Config_type.Cstm_defvar ($2, $4)}
  ;

  (* Key sequence grammer*)
  key_sequences:
    separated_nonempty_list(COMMA, key_sequence) { $1 }
  ;

  key_sequence:
    variable {$1}
                          |identifier {$1}
                          |FUNCTION LPAREN separated_list(COMMA, IDENT) RPAREN {
                            Config_type.Cexp_funcall ($1, $3)
                          }
  ;

  identifier:
    IDENT {Config_type.Cexp_ident ($1)}
  ;

  variable:
    VARIABLE {Config_type.Cexp_var ($1)}
  ;
