;extends
(
  (comment) @injection.language
  (binary_expression
    (indented_string_expression
      (string_fragment) @injection.content
      (#offset! @injection.content 0 0 0 0)
      (#offset! @injection.language 0 2 0 -2)
      (#set! injection.include-children)
    )
  )
)

(
  (comment) @injection.language
  (indented_string_expression) @injection.content
  (#offset! @injection.content 0 0 0 0)
  (#offset! @injection.language 0 2 0 -2)
  (#set! injection.include-children)
)
