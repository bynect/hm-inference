module Set = Set.Make (String)
module Map = Map.Make (String)

type exp =
  | Var of string
  | App of exp * exp
  | Fun of string * exp
  | Let of string * exp * exp
  | If of exp * exp * exp
  | Lit of lit

and lit = Bool of bool | Int of int

let string_of_exp exp =
  let rec str_simple = function
    | Var v -> Printf.sprintf "Var %s" v
    | App (f, a) -> "App (" ^ str_simple f ^ ") (" ^ str_simple a ^ ")"
    | Fun (x, b) -> "Fun " ^ x ^ " (" ^ str_simple b ^ ")"
    | Let (x, v, b) ->
        "Let " ^ x ^ " (" ^ str_simple v ^ ") (" ^ str_simple b ^ ")"
    | If (c, t, e) ->
        "If (" ^ str_simple c ^ ") (" ^ str_simple t ^ ") (" ^ str_simple e
        ^ ")"
    | Lit (Bool b) -> Printf.sprintf "Bool %b" b
    | Lit (Int i) -> Printf.sprintf "Int %d" i
  in
  str_simple exp

type typ = Var of string | Int | Bool | Fun of typ * typ

and texp = exp * typ

let string_of_typ ty =
  let rec str_simple ty =
    match ty with
    | Var v -> v
    | Int -> "int"
    | Bool -> "bool"
    | Fun (p, r) -> str_paren p ^ " -> " ^ str_simple r
  and str_paren ty =
    match ty with Fun (_, _) -> "(" ^ str_simple ty ^ ")" | _ -> str_simple ty
  in
  str_simple ty
