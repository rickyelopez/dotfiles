;; extends
(call_expression
  function: [
    (generic_function
      (identifier) @_name)
    (scoped_identifier
      path: (identifier) @_name)
  ] (#any-of? @_name "query" "query_as" "QueryBuilder")
  arguments: (arguments [
      (string_literal)
      (raw_string_literal)
    ] @injection.content
    (#offset! @injection.content 1 0 -1 0)
    (#set! injection.include-children)
    (#set! injection.language "sql")
  )
)
(macro_invocation
  macro: (identifier) @_macro (#any-of? @_macro "query" "query_as")
  (token_tree
    [
     (string_literal)
     (raw_string_literal)
    ] @injection.content
    (#offset! @injection.content 1 0 -1 0)
    (#set! injection.include-children)
    (#set! injection.language "sql")
  )
)
