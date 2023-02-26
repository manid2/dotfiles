" --- nvim statusline --------------------------------------------------------
" statusline commands.
command! -nargs=0 ToggleStatuslineWordcount
	\ call statusline#statusline#toggle_word_count()

" statusline keymaps.
nnoremap <silent> <Leader>wc :ToggleStatuslineWordcount<cr>
