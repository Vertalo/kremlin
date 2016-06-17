(** Definition of C* *)

module C = Constant

type program =
  decl list

and decl =
  | Function of (typ * ident * binder list * block)
  | TypeAlias of (ident * typ)

and stmt =
  | Return of expr
  | Ignore of expr
  | Decl of (binder * expr)
    (** Scope is: statements that follow. *)
  | IfThenElse of (expr * block * block)
  | Assign of (expr * expr)
    (** First expression has to be a [Bound] or [Open]. *)
  | BufWrite of (expr * expr * expr)
    (** First expression has to be a [Bound] or [Open]. *)

and expr =
  | Call of (expr * expr list)
    (** First expression has to be a [Qualified] or an [Op]. *)
  | Bound of var
  | Open of binder
  | Qualified of lident
  | Constant of C.t
  | BufCreate of (expr * expr)
  | BufRead of (expr * expr)
  | BufSub of (expr * expr * expr)
  | Op of op

and block =
  stmt list

and op = C.op

and var =
  int

and binder = {
  name: ident;
    (** Dirty trick to enable constant-time renamings. *)
  typ: typ;
}

and ident =
  string

and lident =
  ident list * ident

and typ =
  | Int of Constant.width
  | Buf of typ
  | Void
  | Alias of ident
