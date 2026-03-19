; extends

(template_string) @string.outer

(template_string
  .
  "`"
  _+ @string.inner
  "`" .)

(string) @string.outer

(string
  .
  _
  _+ @string.inner
  _ .)
