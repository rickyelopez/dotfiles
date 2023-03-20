local semantic_tokens = require'nvim-semantic-tokens.table-highlighter'

semantic_tokens.token_map["inactiveCode"] = "LspInactiveCode"

semantic_tokens.modifiers_map["readonly"] = {
  variable = "LspReadonlyVariable",
  method = "LspReadonlyMethod",
  class = "LspReadonlyClass",
  static = "LspReadonlyStatic",
}

semantic_tokens.modifiers_map["globalScope"] = {
  variable = "LspGlobalVariable"
}

semantic_tokens.modifiers_map["fileScope"] = {
  variable = "LspFileVariable"
}

-- semantic_tokens.modifiers_map["functionScope"] = {
--     variable = "LspFileVariable"
-- }
