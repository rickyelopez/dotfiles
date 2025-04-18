{ pkgs, lib, ... }: {
  environment.variables = { EDITOR = lib.mkDefault "vim"; };

  environment.systemPackages = with pkgs; [
    ((vim_configurable.override {  }).customize {
      name = "vim";
      # Install plugins for example for syntax highlighting of nix files
      # vimrcConfig.packages.myplugins = with pkgs.vimPlugins; {
        # start = [ vim-nix vim-lastplace ];
        # opt = [];
      # };
      vimrcConfig.customRC = ''
      syntax on
      let mapleader = " "

      set autoindent
      set expandtab
      set hidden
      set history=1000
      set incsearch
      set mouse=a
      set nobackup
      set noswapfile
      set relativenumber
      set smartcase
      set undodir=$HOME/.vimfiles/undodir

      nnoremap <Leader>h <C-w>h
      nnoremap <Leader>j <C-w>j
      nnoremap <Leader>k <C-w>k
      nnoremap <Leader>l <C-w>l
      nnoremap <Leader><space> noh
      '';
    }
  )];
}
