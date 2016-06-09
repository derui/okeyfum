
module T = Okeyfum_types
type main =
    Cprog_main of statement list
and statement =
    Cstm_key of expression * T.state * expression list
  | Cstm_deflock of expression
  | Cstm_lock of expression * statement list
  | Cstm_defvar of expression * expression list
and expression =
    Cexp_var of string
  | Cexp_ident of string
  | Cexp_funcall of string * string list
