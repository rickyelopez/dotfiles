return {
  "williamboman/mason-lspconfig.nvim",
  dependencies = {
    { "williamboman/mason.nvim", config = true },
    "neovim/nvim-lspconfig",
    "WhoIsSethDaniel/mason-tool-installer.nvim",
    "folke/neodev.nvim",
  },
  config = function()
    -- require("mason").setup()
    require("mason-lspconfig").setup({
      automatic_installation = { exclude = { "clangd" } },
      ensure_installed = {
        "bashls",
        "clangd",
        "jsonls",
        "lua_ls",
        "pyright",
        "rust_analyzer",
        "taplo",
        "vimls",
        "yamlls",
      },
    })

    require("mason-tool-installer").setup({
      ensure_installed = {
        "black",
        "shellcheck",
        "stylua",
        "yamlfmt",
      },
      auto_update = false,
      run_on_start = true,
      start_delay = 3000, -- 3 second delay at startup
      debounce_hours = 5, -- at least 5 hours between attempts to install/update
    })

    local util = require("lspconfig.util")

    -- Mappings.
    -- See `:help vim.diagnostic.*` for documentation on any of the below functions
    local opts = { noremap = true, silent = true }
    vim.keymap.set("n", "<space>e", vim.diagnostic.open_float, opts)
    vim.keymap.set("n", "[c", vim.diagnostic.goto_prev, opts)
    vim.keymap.set("n", "]c", vim.diagnostic.goto_next, opts)
    -- vim.keymap.set("n", "<leader>cr", "<cmd>LspRestart clangd<CR>", opts)
    -- vim.keymap.set('n', '<space>q', vim.diagnostic.setloclist, opts)

    -- Use an on_attach function to only map the following keys
    -- after the language server attaches to the current buffer
    local on_attach = function(client, bufnr)
      -- Enable completion triggered by <c-x><c-o>
      vim.api.nvim_buf_set_option(bufnr, "omnifunc", "v:lua.vim.lsp.omnifunc")

      local bufopts = { noremap = true, silent = true, buffer = bufnr }
      vim.keymap.set("n", "gD", vim.lsp.buf.declaration, bufopts)
      vim.keymap.set("n", "gd", vim.lsp.buf.definition, bufopts)
      vim.keymap.set("n", "gi", vim.lsp.buf.implementation, bufopts)
      vim.keymap.set("n", "gr", vim.lsp.buf.references, bufopts)
      vim.keymap.set("n", "K", vim.lsp.buf.hover, bufopts)
      vim.keymap.set("n", "<C-k>", vim.lsp.buf.signature_help, bufopts)
      vim.keymap.set("n", "<space>wa", vim.lsp.buf.add_workspace_folder, bufopts)
      vim.keymap.set("n", "<space>wr", vim.lsp.buf.remove_workspace_folder, bufopts)
      vim.keymap.set("n", "<space>wl", function()
        print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
      end, bufopts)
      vim.keymap.set("n", "<space>D", vim.lsp.buf.type_definition, bufopts)
      vim.keymap.set("n", "<space>rn", vim.lsp.buf.rename, bufopts)
      vim.keymap.set("n", "<space>ca", vim.lsp.buf.code_action, bufopts)

      if client.name == "clangd" then
        vim.keymap.set("n", "<leader>o", "<cmd>ClangdSwitchSourceHeader<CR>", bufopts)
        vim.keymap.set({ "n", "v" }, "<leader>f", require("uncrustify").format, bufopts)
      else
        vim.keymap.set({ "n", "v" }, "<leader>f", function()
          -- vim.lsp.buf.format({ async = true })
          require("conform").format({ async = true, lsp_fallback = "always" })
        end, bufopts)
      end

      local caps = client.server_capabilities
      if caps.semanticTokensProvider and caps.semanticTokensProvider.full then
        local augroup = vim.api.nvim_create_augroup("SemanticTokens", {})
        vim.api.nvim_create_autocmd({ "BufEnter", "CursorHold", "InsertLeave" }, {
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

    local lsp_flags = {
      -- This is the default in Nvim 0.7+
      debounce_text_changes = 150,
    }
    local capabilities = require("cmp_nvim_lsp").default_capabilities()

    local ok, priv_lsp = pcall(require, "lua-priv.lspconfig")
    if ok and priv_lsp then
      priv_lsp.setup(on_attach, lsp_flags, capabilities)
    end

    require("mason-lspconfig").setup_handlers({
      -- The first entry (without a key) will be the default handler
      -- and will be called for each installed server that doesn't have
      -- a dedicated handler.
      function(server_name) -- default handler (optional)
        require("lspconfig")[server_name].setup({
          on_attach = on_attach,
          flags = lsp_flags,
          capabilities = capabilities,
        })
      end,
      ["lua_ls"] = function()
        require("lspconfig")["lua_ls"].setup({
          on_attach = on_attach,
          flags = lsp_flags,
          capabilities = capabilities,
          settings = {
            Lua = {
              diagnostics = {
                -- Get the language server to recognize the `vim` global
                globals = { "vim" },
              },
              telemetry = {
                enable = false,
              },
              format = {
                enable = false,
                defaultConfig = {
                  indent_style = "space",
                  indent_size = "2",
                },
              },
            },
          },
        })
      end,
      ["pyright"] = function()
        require("lspconfig")["pyright"].setup({
          on_attach = on_attach,
          flags = lsp_flags,
          capabilities = capabilities,
          root_dir = util.root_pattern(unpack({ "pyproject.toml" })),
        })
      end,
      ["yamlls"] = function()
        require("lspconfig")["yamlls"].setup({
          on_attach = on_attach,
          flags = lsp_flags,
          capabilities = capabilities,
          settings = {
            yaml = {
              keyOrdering = false,
            },
          },
        })
      end,
    })

    require("clangd_extensions").setup({
      server = {
        on_attach = on_attach,
        flags = lsp_flags,
        capabilities = capabilities,
      },
      extensions = {
        -- defaults:
        -- Automatically set inlay hints (type hints)
        autoSetHints = true,
        -- These apply to the default ClangdSetInlayHints command
        inlay_hints = {
          -- Only show inlay hints for the current line
          only_current_line = false,
          -- Event which triggers a refersh of the inlay hints.
          -- You can make this "CursorMoved" or "CursorMoved,CursorMovedI" but
          -- note that this may cause  higher CPU usage.
          -- This option is only respected when only_current_line and
          -- autoSetHints both are true.
          only_current_line_autocmd = "CursorHold",
          -- whether to show parameter hints with the inlay hints or not
          show_parameter_hints = true,
          -- prefix for parameter hints
          parameter_hints_prefix = "<- ",
          -- prefix for all the other hints (type, chaining)
          other_hints_prefix = "=> ",
          -- whether to align to the length of the longest line in the file
          max_len_align = false,
          -- padding from the left if max_len_align is true
          -- max_len_align_padding = 1,
          -- whether to align to the extreme right or not
          right_align = false,
          -- padding from the right if right_align is true
          -- right_align_padding = 7,
          -- The color of the hints
          highlight = "Comment",
          -- The highlight group priority for extmark
          priority = 100,
        },
        ast = {
          -- These are unicode, should be available in any font
          role_icons = {
            type = "🄣",
            declaration = "🄓",
            expression = "🄔",
            statement = ";",
            specifier = "🄢",
            ["template argument"] = "🆃",
          },
          kind_icons = {
            Compound = "🄲",
            Recovery = "🅁",
            TranslationUnit = "🅄",
            PackExpansion = "🄿",
            TemplateTypeParm = "🅃",
            TemplateTemplateParm = "🅃",
            TemplateParamObject = "🅃",
          },
          --[[ These require codicons (https://github.com/microsoft/vscode-codicons)
            role_icons = {
                type = "",
                declaration = "",
                expression = "",
                specifier = "",
                statement = "",
                ["template argument"] = "",
            },

            kind_icons = {
                Compound = "",
                Recovery = "",
                TranslationUnit = "",
                PackExpansion = "",
                TemplateTypeParm = "",
                TemplateTemplateParm = "",
                TemplateParamObject = "",
            }, ]]

          highlights = {
            detail = "Comment",
          },
        },
        memory_usage = {
          border = "none",
        },
        symbol_info = {
          border = "none",
        },
      },
    })
  end,
}
