" nvim init.vim, author: Mani Kumar

runtime options.vim
runtime colors.vim
runtime autocmds.vim
runtime plugins.vim
runtime keymaps.vim

" NOTE: This must be called after vim-plug's 'call plug#end()'
lua require 'init'
