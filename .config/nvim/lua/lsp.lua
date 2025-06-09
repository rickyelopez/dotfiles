local map = require("utils").map

local function opts(desc, bufnr)
  local opt = { desc = "lspconfig: " .. desc, noremap = true, silent = true, nowait = true }
  if bufnr then
    opt.buffer = bufnr
  end
  return opt
end

map("<space>e", function()
  vim.diagnostic.open_float({ border = "single" })
end, { "n" }, opts("Show diagnostics"))

-- map("<space>q", vim.diagnostic.setloclist, opts("Show diagnostics in loclist"))

-- Use an on_attach function to only map the following keys
-- after the language server attaches to the current buffer
local on_attach = function(client, bufnr)
  local trouble = require("trouble")

  -- Enable completion triggered by <c-x><c-o>
  vim.api.nvim_set_option_value("omnifunc", "v:lua.vim.lsp.omnifunc", { buf = bufnr })

  map("gD", vim.lsp.buf.declaration, { "n" }, opts("Goto declaration", bufnr))
  map("gd", vim.lsp.buf.definition, { "n" }, opts("Goto definition", bufnr))
  map("grr", function()
    trouble.open({ mode = "lsp_references", focus = true })
  end, { "n" }, opts("Show references", bufnr))
  map("<C-k>", vim.lsp.buf.signature_help, { "n" }, opts("Show signature", bufnr))
  map("<space>wa", vim.lsp.buf.add_workspace_folder, { "n" }, opts("Add folder to workspace", bufnr))
  map("<space>D", vim.lsp.buf.type_definition, { "n" }, opts("Goto type definition", bufnr))

  local caps = client.server_capabilities
  if caps.semanticTokensProvider and caps.semanticTokensProvider.full then
    local augroup = vim.api.nvim_create_augroup("SemanticTokens", {})
    vim.api.nvim_create_autocmd({ "BufEnter", "InsertLeave" }, {
      group = augroup,
      buffer = bufnr,
      callback = function()
        vim.lsp.semantic_tokens.force_refresh(bufnr)
      end,
    })
    -- fire it first time on load as well
    vim.lsp.semantic_tokens.force_refresh(bufnr)
  end
end

-- FIXME: There's probably a better way to do this
vim.g.my_on_attach = on_attach

-- local capabilities = require("cmp_nvim_lsp").default_capabilities({ preselectSupport = false })
local capabilities = require("blink.cmp").get_lsp_capabilities({
  -- add capability overrides here
})

-- base config for all language servers, overridden per-server in the after/lsp/xxx.lua files
vim.lsp.config("*", {
  on_attach = on_attach,
  capabilities = capabilities,
})

-- nixd doesn't exist in lspconfig, set it up manually here
require("lspconfig").nixd.setup({
  on_attach = on_attach,
  capabilities = capabilities,
})
