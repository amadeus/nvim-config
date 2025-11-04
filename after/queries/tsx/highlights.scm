; extends
;; TypeScript Highlighting Modifiers

;; Regular function declarations
(function_declaration
  parameters: (formal_parameters
    "(" @function.paren.open
    ")" @function.paren.close))

;; Function expressions
(function_expression
  parameters: (formal_parameters
    "(" @function.paren.open
    ")" @function.paren.close))

;; Arrow functions
(arrow_function
  parameters: (formal_parameters
    "(" @function.paren.open
    ")" @function.paren.close))

;; Method definitions in classes
(method_definition
  parameters: (formal_parameters
    "(" @function.paren.open
    ")" @function.paren.close))

;; Function types in type annotations
(function_type
  parameters: (formal_parameters
    "(" @function.paren.open
    ")" @function.paren.close))

;; Method signatures in interfaces
(method_signature
  parameters: (formal_parameters
    "(" @function.paren.open
    ")" @function.paren.close))

;; Call signatures in interfaces
(call_signature
  parameters: (formal_parameters
    "(" @function.paren.open
    ")" @function.paren.close))

;; Boolean literals
(true) @boolean.true
(false) @boolean.false

;; Spread operator
(spread_element
  "..." @operator.spread)

;; Function call parentheses
(call_expression
  arguments: (arguments
    "(" @function.call.paren.open
    ")" @function.call.paren.close))

;; Arrow function arrow
(arrow_function
  "=>" @function.arrow)

;; Function body brackets
(function_declaration
  body: (statement_block
    "{" @function.bracket.open
    "}" @function.bracket.close))

(arrow_function
  body: (statement_block
    "{" @function.bracket.open
    "}" @function.bracket.close))

(function_expression
  body: (statement_block
    "{" @function.bracket.open
    "}" @function.bracket.close))

(method_definition
  body: (statement_block
    "{" @function.bracket.open
    "}" @function.bracket.close))

;; Class definition brackets
(class_declaration
  body: (class_body
    "{" @class.bracket.open
    "}" @class.bracket.close))

;; Class name
(class_declaration
  name: (type_identifier) @class.name)

;; Class instantiation parentheses
(new_expression
  arguments: (arguments
    "(" @class.instantiation.paren.open
    ")" @class.instantiation.paren.close))

;; If you're using React/TSX, add this for function components
;; (jsx_element
;;   open_tag: (jsx_opening_element
;;     name: (identifier) @_name
;;     (#match? @_name "^[A-Z]"))
;;   (#has-parent? function_declaration function_expression arrow_function)
;; )
