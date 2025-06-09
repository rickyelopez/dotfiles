local map = require("utils").map

local function opts(desc, bufnr)
  local opt = { desc = "lspconfig: " .. desc, noremap = true, silent = true, nowait = true }
  if bufnr then
    opt.buffer = bufnr
  end
  return opt
end

return {
  on_attach = function(client, bufnr)
    -- use uncrustify for c files only
    if vim.api.nvim_buf_call(bufnr, function()
      return vim.bo.filetype == "c"
    end) then
      local fmt = require("uncrustify").format
      map("<leader>f", fmt, { "n", "v" }, opts("Format file/selection", bufnr))
    end

    map(
      "<leader>o",
      require("clangd_extensions.switch_source_header").switch_source_header,
      { "n" },
      opts("Switch source-header", bufnr)
    )
  end,
  settings = {
    clangd = {
      InlayHints = {
        Designators = true,
        Enabled = true,
        ParameterNames = true,
        DeducedTypes = true,
      },
    },
  },
}
