(const_literal) @number

(type_declaration) @type

(function_declaration
    (identifier) @function)

(struct_declaration
    (identifier) @structure)

(type_constructor_or_function_call_expression
    (type_declaration) @function)

(parameter
    (variable_identifier_declaration (identifier) @parameter))

[
    "struct"
    "bitcast"
    ; "block"
    "discard"
    "enable"
    "fallthrough"
    "fn"
    "let"
    "private"
    "read"
    "read_write"
    "return"
    "storage"
    "type"
    "uniform"
    "var"
    "workgroup"
    "write"
    (texel_format)
] @keyword ; TODO reserved keywords

[
    (true)
    (false)
] @boolean

[ "," "." ":" ";" ] @punctuation.delimiter

;; brackets
[
    "("
    ")"
    "["
    "]"
    "{"
    "}"
] @punctuation.bracket

[
    "loop"
    "for"
    "break"
    "continue"
    "continuing"
] @repeat

[
    "if"
    "else"
    "elseif"
    "switch"
    "case"
    "default"
] @conditional

[
    "&"
    "&&"
    "/"
    "!"
    "="
    "=="
    "!="
    ">"
    ">="
    ">>"
    "<"
    "<="
    "<<"
    "%"
    "-"
    "+"
    "|"
    "||"
    "*"
    "~"
    "^"
] @operator

(attribute
    (identifier) @property)

(comment) @comment

(ERROR) @error