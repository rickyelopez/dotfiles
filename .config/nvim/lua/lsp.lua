local map = require("utils").map

local function opts(desc, bufnr)
  local opt = { desc = "lsp: " .. desc, noremap = true, silent = true, nowait = true }
  if bufnr then
    opt.buffer = bufnr
  end
  return opt
end

map("<space>e", function()
  vim.diagnostic.open_float({ border = "single" })
end, { "n" }, opts("Show diagnostics"))

map("<space>dq", vim.diagnostic.setloclist, opts("Show diagnostics in loclist"))

local capabilities = require("blink.cmp").get_lsp_capabilities({
  -- add capability overrides here
})

-- base config for all language servers, overridden per-server in the after/lsp/xxx.lua files
vim.lsp.config("*", {
  capabilities = capabilities,
})

-- nixd doesn't exist in lspconfig, set it up manually here
vim.lsp.enable("nixd")

vim.api.nvim_create_autocmd("LspAttach", {
  group = vim.api.nvim_create_augroup("lsp-attach", { clear = true }),
  callback = function(event)
    -- Enable completion triggered by <c-x><c-o>
    vim.api.nvim_set_option_value("omnifunc", "v:lua.vim.lsp.omnifunc", { buf = event.buf })

    map("gD", vim.lsp.buf.declaration, { "n" }, opts("Goto declaration", event.buf))
    map("gd", vim.lsp.buf.definition, { "n" }, opts("Goto definition", event.buf))
    map("grr", function()
      require("trouble").open({ mode = "lsp_references", focus = true })
    end, { "n" }, opts("Show references", event.buf))
    map("<C-k>", vim.lsp.buf.signature_help, { "n" }, opts("Show signature", event.buf))
    map("<space>wa", vim.lsp.buf.add_workspace_folder, { "n" }, opts("Add folder to workspace", event.buf))
    map("<space>D", vim.lsp.buf.type_definition, { "n" }, opts("Goto type definition", event.buf))

    local function client_supports_method(client, method, bufnr)
      return client:supports_method(method, bufnr)
    end

    local client = vim.lsp.get_client_by_id(event.data.client_id)
    if client then
      -- -- unclear if this semantic token stuff is still required or if it's been fixed
      -- -- commenting out for now
      -- local caps = client.server_capabilities
      -- if caps and caps.semanticTokensProvider and caps.semanticTokensProvider.full then
      --   local augroup = vim.api.nvim_create_augroup("SemanticTokens", {})
      --   vim.api.nvim_create_autocmd({ "BufEnter", "InsertLeave" }, {
      --     group = augroup,
      --     buffer = event.buf,
      --     callback = function()
      --       vim.lsp.semantic_tokens.force_refresh(event.buf)
      --     end,
      --   })
      --   -- fire it first time on load as well
      --   vim.lsp.semantic_tokens.force_refresh(event.buf)
      -- end

      if client_supports_method(client, vim.lsp.protocol.Methods.textDocument_inlayHint, event.buf) then
        map("<leader>th", function()
          vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({ bufnr = event.buf }))
        end, { "n" }, opts("[T]oggle Inlay [H]ints", event.buf))
      end
    end
  end,
})
