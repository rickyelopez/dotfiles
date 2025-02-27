return {
  {
    "williamboman/mason-lspconfig.nvim",
    dependencies = {
      { "williamboman/mason.nvim", config = true, opts = { log_level = vim.log.levels.DEBUG } },
      "neovim/nvim-lspconfig",
      "WhoIsSethDaniel/mason-tool-installer.nvim",
      "folke/neodev.nvim",
      "p00f/clangd_extensions.nvim",
    },
    config = function()
      require("mason-lspconfig").setup({
        -- automatic_installation = { exclude = { "clangd" } },
        ensure_installed = {
          "basedpyright",
          "bashls",
          "clangd",
          "jsonls",
          "lua_ls",
          "nil_ls",
          "rust_analyzer",
          "taplo",
          "vimls",
          "yamlls",
          "zls",
        },
      })

      require("mason-tool-installer").setup({
        ensure_installed = {
          "black",
          "nixpkgs-fmt",
          "shellcheck",
          "shfmt",
          "stylua",
          "yamlfmt",
        },
        auto_update = false,
        run_on_start = true,
        start_delay = 3000, -- 3 second delay at startup
        debounce_hours = 5, -- at least 5 hours between attempts to install/update
      })

      local util = require("lspconfig.util")
      local map = require("utils").map

      -- Mappings.
      -- See `:help vim.diagnostic.*` for documentation on any of the below functions

      local function opts(desc, bufnr)
        local opt = { desc = "lspconfig: " .. desc, noremap = true, silent = true, nowait = true }
        if bufnr then
          opt.buffer = bufnr
        end
        return opt
      end

      map("<space>e", vim.diagnostic.open_float, { "n" }, opts("Show diagnostics"))
      -- map("<space>q", vim.diagnostic.setloclist, opts("Show diagnostics in loclist"))

      -- Use an on_attach function to only map the following keys
      -- after the language server attaches to the current buffer
      local on_attach = function(client, bufnr)
        local trouble = require("trouble")
        -- Enable completion triggered by <c-x><c-o>
        vim.api.nvim_set_option_value("omnifunc", "v:lua.vim.lsp.omnifunc", { buf = bufnr })

        map("gD", vim.lsp.buf.declaration, { "n" }, opts("Goto declaration", bufnr))
        map("gd", vim.lsp.buf.definition, { "n" }, opts("Goto definition", bufnr))
        map("gi", vim.lsp.buf.implementation, { "n" }, opts("Goto implementation", bufnr))
        map("gr", function()
          trouble.open({ mode = "lsp_references", focus = true })
        end, { "n" }, opts("Show references", bufnr))
        map("K", vim.lsp.buf.hover, { "n" }, opts("Show hover", bufnr))
        map("<C-k>", vim.lsp.buf.signature_help, { "n" }, opts("Show signature", bufnr))
        map("<space>wa", vim.lsp.buf.add_workspace_folder, { "n" }, opts("Add folder to workspace", bufnr))
        map("<space>wr", function()
          vim.ui.select(vim.lsp.buf.list_workspace_folders(), {
            prompt = "Select a folder to remove:",
          }, function(choice)
            if choice then
              vim.lsp.buf.remove_workspace_folder(choice)
            end
          end)
        end, { "n" }, opts("Remove folder from workspace", bufnr))
        map("<space>wl", function()
          print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
        end, { "n" }, opts("List workspace folders", bufnr))
        map("<space>D", vim.lsp.buf.type_definition, { "n" }, opts("Goto type definition", bufnr))
        map("<space>rn", vim.lsp.buf.rename, { "n" }, opts("Rename symbol", bufnr))
        map("<space>ca", vim.lsp.buf.code_action, { "n" }, opts("Show code actions", bufnr))

        -- only use uncrustify for c files
        -- this is a hack since work uses clang-format, but work also only uses cpp so this is fine for now
        if vim.api.nvim_buf_call(bufnr, function()
          return vim.bo.filetype == "c"
        end) then
          -- if true then
          local fmt = require("uncrustify").format
          map("<leader>f", fmt, { "n", "v" }, opts("Format file/selection with uncrustify", bufnr))
        else
          local fmt = require("conform").format
          map("<leader>f", function()
            fmt({ async = true, lsp_fallback = "always" })
          end, { "n", "v" }, opts("Format file/selection", bufnr))
        end

        if client.name == "clangd" then
          map("<leader>o", "<cmd>ClangdSwitchSourceHeader<CR>", { "n" }, opts("Switch source-header", bufnr))
        end

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

      local lsp_flags = {}
      local capabilities = require("cmp_nvim_lsp").default_capabilities({ preselectSupport = false })

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
        ["basedpyright"] = function()
          require("lspconfig")["basedpyright"].setup({
            on_attach = on_attach,
            flags = lsp_flags,
            capabilities = capabilities,
            -- root_dir = util.root_pattern("pyproject.toml"),
            settings = {
              basedpyright = {
                analysis = {
                  autoSearchPaths = true,
                  diagnosticMode = "openFilesOnly",
                  useLibraryCodeForTypes = true,
                },
                -- root_dir = util.root_pattern("pyproject.toml"),
              },
            },
          })
        end,
        ["clangd"] = function()
          require("lspconfig")["clangd"].setup({
            on_attach = on_attach,
            flags = lsp_flags,
            capabilities = capabilities,
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
                hint = {
                  enable = true, -- necessary
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
        ["nil_ls"] = function()
          require("lspconfig")["nil_ls"].setup({
            on_attach = on_attach,
            flags = lsp_flags,
            capabilities = capabilities,
            settings = {
              ["nil"] = {
                nix = {
                  flake = {
                    autoArchive = true,
                  },
                },
              },
            },
          })
        end,
        -- ["pyright"] = function()
        --   require("lspconfig")["pyright"].setup({
        --     on_attach = on_attach,
        --     flags = lsp_flags,
        --     capabilities = capabilities,
        --     root_dir = util.root_pattern("pyproject.toml"),
        --   })
        -- end,
        ["rust_analyzer"] = function()
          require("lspconfig")["rust_analyzer"].setup({
            on_attach = on_attach,
            flags = lsp_flags,
            capabilities = capabilities,
            cmd = { "ra-multiplex" },
            settings = {
              ["rust-analyzer"] = {
                files = {
                  watcher = "server",
                },
                check = {
                  workspace = false,
                },
                inlayHints = {
                  bindingModeHints = {
                    enable = false,
                  },
                  chainingHints = {
                    enable = true,
                  },
                  closingBraceHints = {
                    enable = true,
                    minLines = 25,
                  },
                  closureReturnTypeHints = {
                    enable = "never",
                  },
                  lifetimeElisionHints = {
                    enable = "never",
                    useParameterNames = false,
                  },
                  maxLength = 25,
                  parameterHints = {
                    enable = true,
                  },
                  reborrowHints = {
                    enable = "never",
                  },
                  renderColons = true,
                  typeHints = {
                    enable = true,
                    hideClosureInitialization = false,
                    hideNamedConstructor = false,
                  },
                },
              },
            },
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
        ["zls"] = function()
          require("lspconfig")["zls"].setup({
            on_attach = on_attach,
            flags = lsp_flags,
            capabilities = capabilities,
            settings = {
              zls = {
                enable_inlay_hints = true,
                inlay_hints_show_builtin = true,
                inlay_hints_exclude_single_argument = true,
                inlay_hints_hide_redundant_param_names = false,
                inlay_hints_hide_redundant_param_names_last_token = false,
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
          autoSetHints = false,
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
  },
  {
    "MysticalDevil/inlay-hints.nvim",
    event = "LspAttach",
    dependencies = { "neovim/nvim-lspconfig" },
    config = true,
  },
}
