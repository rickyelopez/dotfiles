---@diagnostic disable: undefined-global

return {
  s("derive", { t("#[derive("), i(1), t(")]") }),
  s("derivedbg", { t("#[derive(Debug"), i(1), t(")]") }),
  s("allow", { t("#[allow("), i(1), t(")]") }),
}
