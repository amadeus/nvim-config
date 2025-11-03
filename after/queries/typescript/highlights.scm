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

;; If you're using React/TSX, add this for function components
;; (jsx_element
;;   open_tag: (jsx_opening_element
;;     name: (identifier) @_name
;;     (#match? @_name "^[A-Z]"))
;;   (#has-parent? function_declaration function_expression arrow_function)
;; )
