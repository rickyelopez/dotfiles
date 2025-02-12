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
  -- print
  s("print", {
    t('std.debug.print("'),
    i(1),
    t('", .{'),
    i(2),
    t("});"),
  }),
  s("println", {
    t('std.debug.print("'),
    i(1),
    t('\\n", .{'),
    i(2),
    t("});"),
  }),
}
