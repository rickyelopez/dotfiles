---@diagnostic disable: undefined-global

local function insert_selected(_, snip)
  local res = {}
  local env = snip.env
  for _, ele in ipairs(env.TM_SELECTED_TEXT) do
    table.insert(res, ele)
  end
  return res
end

return {
  -- include
  s("#inc", {
    t("#include "),
    c(1, {
      sn(nil, { t('"'), r(1, "inc_text"), t('"') }),
      sn(nil, { t("<"), r(1, "inc_text"), t(">") }),
    }),
  }, {
    stored = {
      ["inc_text"] = i(1, ""),
    },
  }),

  -- preprocessor if
  s("#if", {
    t("#if "),
    i(1, "condition"),
    t({ "", "" }),
    f(insert_selected),
    i(0),
    t({ "", "#endif // " }),
    f(function(args)
      return args[1]
    end, 1),
  }),

  -- regular if
  s("if", {
    t("if ("),
    i(1, "condition"),
    t({ ")", "{", "    " }),
    f(insert_selected),
    i(2),
    t({ "", "}" }),
    i(0),
  }),

  -- elif
  s("elif", {
    t("else if ("),
    i(1, "condition"),
    t({ ")", "{", "    " }),
    f(insert_selected),
    i(2),
    t({ "", "}" }),
    i(0),
  }),

  -- else
  s("else", {
    t({ "else", "{", "    " }),
    f(insert_selected),
    i(1),
    t({ "", "}" }),
    i(0),
  }),

  -- ternary, with choice on where to put the selected text (if any)
  s("tern", {
    c(1, {
      -- stylua: ignore start
      sn(nil, { t("("), f(function(_, parent) return insert_selected({}, parent.choice.next) end), i(1), t(") ? ("), i(2), t(") : ("), i(3), t(")") }),
      sn(nil, { t("("), i(1), t(") ? ("), f(function(_, parent) return insert_selected({}, parent.choice.next) end), i(2), t(") : ("), i(3), t(")") }),
      sn(nil, { t("("), i(1), t(") ? ("), i(2), t(") : ("), f(function(_, parent) return insert_selected({}, parent.choice.next) end), i(3), t(")") }),
      -- stylua: ignore end
    }),
    i(0),
  }),

  -- function declaration
  s("fn", {
    i(1, "return type"),
    t(" "),
    i(2, "function name"),
    sn(3, {
      t("("),
      i(1, "params"),
      t({ ")", "{", "    " }),
    }),
    f(insert_selected),
    i(4),
    t({ "", "}" }),
    i(0),
  }),
}
