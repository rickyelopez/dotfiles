{ config, pkgs, lib, ... }:
let
  cfg = config.my.vim;
in
{
  options.my.vim = {
    enable = lib.mkEnableOption "host vim module.";
  };

  config = lib.mkIf cfg.enable {
    environment.variables = lib.mkDefault { EDITOR = "vim"; };

    environment.systemPackages = with pkgs; [
      ((vim_configurable.override { }).customize {
        name = "vim";
        # Install plugins for example for syntax highlighting of nix files
        # vimrcConfig.packages.myplugins = with pkgs.vimPlugins; {
        # start = [ vim-nix vim-lastplace ];
        # opt = [];
        # };
        vimrcConfig.customRC = ''
          syntax on
          filetype plugin on
          let mapleader = " "

          set autoindent
          set expandtab
          set hidden
          set history=1000
          set hlsearch
          set incsearch
          set mouse=a
          set nobackup
          set noswapfile
          set relativenumber
          set ignorecase
          set smartcase
          set undodir=$HOME/.vimfiles/undodir

          set ts=4 sw=4

          nnoremap <Leader>h <C-w>h
          nnoremap <Leader>j <C-w>j
          nnoremap <Leader>k <C-w>k
          nnoremap <Leader>l <C-w>l
          nnoremap <Leader><space> <cmd>noh<cr>

          nnoremap Y y$

          vnoremap > >gv
          vnoremap < <gv
        '';
      }
      )
    ];
  };
}
