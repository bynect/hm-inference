{
open Parse
}

let white = [' ' '\t' '\r']+
let digit = ['0'-'9']
let letter = ['a'-'z' 'A'-'Z' '_']
let var = letter+

rule token = parse
  | white { token lexbuf }
  | '\n' { Lexing.new_line lexbuf; token lexbuf }
  | "--" [^'\n']* { token lexbuf }
  | "(" { LPAREN }
  | ")" { RPAREN }
  | "->" { ARROW }
  | "," { COMMA }
  | "=" { EQ }
  | "<>" { NE }
  | "&&" { AND }
  | "||" { OR }
  | "+" { PLUS }
  | "-" { MINUS }
  | "*" { STAR }
  | "/" { SLASH }
  | "fun" { FUN }
  | "if" { IF }
  | "let" { LET }
  | "in" { IN }
  | "then" { THEN }
  | "else" { ELSE }
  | "true" { BOOL true }
  | "false" { BOOL false }
  | digit+ { INT (int_of_string (Lexing.lexeme lexbuf)) }
  | "`" var "`"
    {
      let v = Lexing.lexeme lexbuf in
      let len = Lexing.lexeme_end lexbuf - Lexing.lexeme_start lexbuf in
      BVAR (String.sub v 1 (len - 2))
    }
  | var { VAR (Lexing.lexeme lexbuf) }
  | eof { EOF }
  | _ { failwith "Lexing error" }