lua << EOF
  require("trouble").setup { }
EOF

nnoremap <leader>xx <cmd>LspTroubleToggle<cr>
