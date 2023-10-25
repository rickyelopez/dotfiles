require("nvim-treesitter.configs").setup({
    ensure_installed = {
        "bash",
        "c",
        "cpp",
        "css",
        "html",
        "javascript",
        "lua",
        "python",
        "query",
        "rust",
        "sql",
        "toml",
        "typescript",
        "vim",
        "vimdoc",
        "yaml",
    },
    highlight = {
        enable = true,
        -- Setting this to true will run `:h syntax` and tree-sitter at the same time.
        -- Set this to `true` if you depend on 'syntax' being enabled (like for indentation).
        -- Using this option may slow down your editor, and you may see some duplicate highlights.
        -- Instead of true it can also be a list of languages
        additional_vim_regex_highlighting = false,
    },
    playground = {
        enable = true,
        disable = {},
        updatetime = 25, -- Debounced time for highlighting nodes in the playground from source code
        persist_queries = false, -- Whether the query persists across vim sessions
        keybindings = {
            toggle_query_editor = "o",
            toggle_hl_groups = "i",
            toggle_injected_languages = "t",
            toggle_anonymous_nodes = "a",
            toggle_language_display = "I",
            focus_language = "f",
            unfocus_language = "F",
            update = "R",
            goto_node = "<cr>",
            show_help = "?",
        },
    },
    indent = {
        enable = false,
    },
})

vim.opt.foldmethod = "expr"
vim.opt.foldexpr = "nvim_treesitter#foldexpr()"

require("treesitter-context").setup({
    enable = true, -- Enable this plugin (Can be enabled/disabled later via commands)
    max_lines = 0, -- How many lines the window should span. Values <= 0 mean no limit.
    min_window_height = 0, -- Minimum editor window height to enable context. Values <= 0 mean no limit.
    line_numbers = true,
    multiline_threshold = 20, -- Maximum number of lines to collapse for a single context line
    trim_scope = "outer", -- Which context lines to discard if `max_lines` is exceeded. Choices: 'inner', 'outer'
    mode = "cursor", -- Line used to calculate context. Choices: 'cursor', 'topline'
    -- Separator between context and content. Should be a single character string, like '-'.
    -- When separator is set, the context will only show up when there are at least 2 lines above cursorline.
    separator = nil,
    zindex = 20, -- The Z-index of the context window
})

-- local hl = function(group, opts)
--     opts.default = true
--     vim.api.nvim_set_hl(0, group, opts)
-- end

-- -- Misc {{{
-- hl('@comment', {link = 'Comment'})
-- -- hl('@error', {link = 'Error'})
-- hl('@none', {bg = 'NONE', fg = 'NONE'})
-- hl('@preproc', {link = 'PreProc'})
-- hl('@define', {link = 'Define'})
-- hl('@operator', {link = 'Operator'})
-- -- }}}

-- -- Punctuation {{{
-- hl('@punctuation.delimiter', {link = 'Delimiter'})
-- hl('@punctuation.bracket', {link = 'Delimiter'})
-- hl('@punctuation.special', {link = 'Delimiter'})
-- -- }}}

-- -- Literals {{{
-- hl('@string', {link = 'String'})
-- hl('@string.regex', {link = 'String'})
-- hl('@string.escape', {link = 'SpecialChar'})
-- hl('@string.special', {link = 'SpecialChar'})

-- hl('@character', {link = 'Character'})
-- hl('@character.special', {link = 'SpecialChar'})

-- hl('@boolean', {link = 'Boolean'})
-- hl('@number', {link = 'Number'})
-- hl('@float', {link = 'Float'})
-- -- }}}

-- -- Functions {{{
-- hl('@function', {link = 'Function'})
-- hl('@function.call', {link = 'Function'})
-- hl('@function.builtin', {link = 'Special'})
-- hl('@function.macro', {link = 'Macro'})

-- hl('@method', {link = 'Function'})
-- hl('@method.call', {link = 'Function'})

-- hl('@constructor', {link = 'Special'})
-- hl('@parameter', {link = 'Identifier'})
-- -- }}}

-- -- Keywords {{{
-- hl('@keyword', {link = 'Keyword'})
-- hl('@keyword.function', {link = 'Keyword'})
-- hl('@keyword.operator', {link = 'Keyword'})
-- hl('@keyword.return', {link = 'Keyword'})

-- hl('@conditional', {link = 'Conditional'})
-- hl('@repeat', {link = 'Repeat'})
-- hl('@debug', {link = 'Debug'})
-- hl('@label', {link = 'Label'})
-- hl('@include', {link = 'Include'})
-- hl('@exception', {link = 'Exception'})
-- -- }}}

-- -- Types {{{
-- hl('@type', {link = 'Type'})
-- hl('@type.builtin', {link = 'Type'})
-- hl('@type.qualifier', {link = 'Type'})
-- hl('@type.definition', {link = 'Typedef'})

-- hl('@storageclass', {link = 'StorageClass'})
-- hl('@attribute', {link = 'PreProc'})
-- hl('@field', {link = 'Identifier'})
-- hl('@property', {link = 'Identifier'})
-- -- }}}

-- -- Identifiers {{{
-- hl('@variable', {link = 'Normal'})
-- hl('@variable.builtin', {link = 'Special'})

-- hl('@constant', {link = 'Constant'})
-- hl('@constant.builtin', {link = 'Special'})
-- hl('@constant.macro', {link = 'Define'})

-- hl('@namespace', {link = 'Include'})
-- hl('@symbol', {link = 'Identifier'})
-- -- }}}

-- -- Text {{{
-- hl('@text', {link = 'Normal'})
-- hl('@text.strong', {bold = true})
-- hl('@text.emphasis', {italic = true})
-- hl('@text.underline', {underline = true})
-- hl('@text.strike', {strikethrough = true})
-- hl('@text.title', {link = 'Title'})
-- hl('@text.literal', {link = 'String'})
-- hl('@text.uri', {link = 'Underlined'})
-- hl('@text.math', {link = 'Special'})
-- hl('@text.environment', {link = 'Macro'})
-- hl('@text.environment.name', {link = 'Type'})
-- hl('@text.reference', {link = 'Constant'})

-- hl('@text.todo', {link = 'Todo'})
-- hl('@text.note', {link = 'SpecialComment'})
-- hl('@text.warning', {link = 'WarningMsg'})
-- hl('@text.danger', {link = 'ErrorMsg'})
-- -- }}}

-- -- Tags {{{
-- hl('@tag', {link = 'Tag'})
-- hl('@tag.attribute', {link = 'Identifier'})
-- hl('@tag.delimiter', {link = 'Delimiter'})
-- -- }}}
