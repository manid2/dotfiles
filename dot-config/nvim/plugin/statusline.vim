" --- nvim statusline --------------------------------------------------------
" statusline commands.
command! -nargs=0 ToggleStatuslineWordcount
	\ call statusline#statusline#toggle_word_count()

" statusline keymaps.
nnoremap <silent> <Leader>wc :ToggleStatuslineWordcount<cr>

" --- vim-airline setup ------------------------------------------------------
let g:airline#extensions#default#layout = [
  \ ['a', 'b', 'c', 'd'],
  \ ['x', 'y', 'warning', 'error']
  \ ]

" Setup statusline after plugins are loaded
augroup statusline_airline_init
	autocmd!
	autocmd User AirlineAfterInit call statusline#statusline#define_airline_parts()
augroup END
