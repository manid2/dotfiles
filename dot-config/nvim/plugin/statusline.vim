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

" --- Performance cache management -------------------------------------------
" Initialize and update buffer count cache
augroup statusline_cache
	autocmd!
	" Initialize buffer count on startup
	autocmd VimEnter * call statusline#statusline#update_buf_count()
	" Update buffer count when buffers are added or deleted
	autocmd BufAdd,BufDelete * call statusline#statusline#update_buf_count()
	" Clear git directory cache when buffer changes or is written
	autocmd BufEnter,BufWritePost * if exists('s:gitdir_cache') | unlet! s:gitdir_cache[bufnr('%')] | endif
augroup END
