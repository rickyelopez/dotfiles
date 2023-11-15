-- based on https://github.com/tjdevries/config_manager/blob/master/xdg_config/nvim/after/plugin/sql_rust_automagic.lua

local run_formatter = function(text)
  local split = vim.split(text, "\n")
  local result = table.concat(vim.list_slice(split, 2, #split - 1), "\n")

  -- Finds sql-format-via-python somewhere in your nvim config path
  -- local bin = vim.api.nvim_get_runtime_file("bin/sql-format-via-python.py", false)[1]

  local j = require("plenary.job"):new({
    -- command = "python",
    -- args = { bin },
    command = "sql-formatter",
    writer = { result },
  })
  return j:sync()
end

local embedded_sql = vim.treesitter.query.parse(
  "rust",
  [[
(call_expression
  function: [
             (generic_function
               (identifier) @_name)
             (scoped_identifier
               path: (identifier) @_name)
             ] (#any-of? @_name "query" "query_as" "QueryBuilder")
  arguments: (arguments
               [
                (string_literal)
                (raw_string_literal)
                ] @sql
               )
  )
(macro_invocation
  macro: (identifier) @_name (#any-of? @_name "query" "query_as")
  (token_tree
    [
     (string_literal)
     (raw_string_literal)
     ] @sql
    )
  )
]]
)

local get_root = function(bufnr)
  local parser = vim.treesitter.get_parser(bufnr, "rust", {})
  local tree = parser:parse()[1]
  return tree:root()
end

local format_sql = function(bufnr)
  bufnr = bufnr or vim.api.nvim_get_current_buf()

  if vim.bo[bufnr].filetype ~= "rust" then
    vim.notify("can only be used in rust")
    return
  end

  local root = get_root(bufnr)

  local changes = {}
  for id, node in embedded_sql:iter_captures(root, bufnr, 0, -1) do
    local name = embedded_sql.captures[id]
    if name == "sql" then
      -- { start row, start col, end row, end col }
      local range = { node:range() }
      local indentation = string.rep(" ", range[2])

      if range[1] == range[3] then
        goto continue
      end

      -- Run the formatter, based on the node text
      local formatted = run_formatter(vim.treesitter.get_node_text(node, bufnr))

      -- Add some indentation (can be anything you like!)
      for idx, line in ipairs(formatted) do
        if line ~= "" then
          formatted[idx] = indentation .. line
        end
      end

      -- Keep track of changes
      --    But insert them in reverse order of the file,
      --    so that when we make modifications, we don't have
      --    any out of date line numbers
      table.insert(changes, 1, {
        start = range[1] + 1,
        final = range[3],
        formatted = formatted,
      })
      ::continue::
    end
  end

  for _, change in ipairs(changes) do
    vim.api.nvim_buf_set_lines(bufnr, change.start, change.final, false, change.formatted)
  end
end

vim.api.nvim_create_user_command("SqlMagic", function()
  format_sql()
end, {})

-- local group = vim.api.nvim_create_augroup("rust-sql-fmt", { clear = true })
-- vim.api.nvim_create_autocmd({"BufWritePre"}, {
--   group = group,
--   pattern = "*.rs",
--   callback = function()
--     format_sql()
--   end,
-- })
