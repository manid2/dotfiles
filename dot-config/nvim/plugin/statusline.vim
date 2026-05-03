" --- nvim statusline --------------------------------------------------------
" statusline commands.
command! -nargs=0 ToggleStatuslineWordcount
	\ call statusline#statusline#toggle_word_count()

command! -nargs=0 GitPS1
	\ call statusline#git#ps1(1)

" statusline keymaps.
nnoremap <silent> <Leader>wc :ToggleStatuslineWordcount<cr>
nnoremap <silent> <Leader>gp :GitPS1<cr>

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

" Start async git PS1 updates for statusline
augroup statusline_git_ps1
	autocmd!
	autocmd BufEnter * call statusline#git#start_updates()
	autocmd VimLeavePre * call statusline#git#stop_updates()
augroup END
