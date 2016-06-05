
type main =
    Cprog_main of statement list
and statement =
    Cstm_key of expression * expression list
  | Cstm_deflock of expression * expression
  | Cstm_lock of expression * statement list
  | Cstm_defvar of expression * expression list
and expression =
    Cexp_var of string
  | Cexp_ident of string
