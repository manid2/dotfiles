" --- nvim autocmds ----------------------------------------------------------
" Auto commands common to all files
augroup mk_cmn
	autocmd!
	" jump to the last position when reopening a file
	autocmd BufReadPost *
		\   if line("'\"") >= 1 && line("'\"") <= line("$")
		\     && &ft !~# 'commit'
		\ |     exe "normal! g`\""
		\ | endif

	" Default options for any file type
	autocmd FileType *
		\   let g:statusline_wordcount_disabled=1
		\ | let g:vim_markdown_folding_disabled=1
		\ | setlocal nospell foldlevel=99
		\ | nnoremap <Leader>f <Nop>
augroup end

augroup mk_c
	autocmd!
	autocmd FileType c,cpp
		\ setlocal spell textwidth=78
augroup end

augroup mk_sh
	autocmd!
	autocmd FileType sh,zsh,bash,vim,lua
		\ setlocal spell textwidth=78
augroup end

augroup mk_py
	autocmd!
	autocmd FileType python
		\ setlocal spell textwidth=78 tabstop=4 softtabstop=4
		\ shiftwidth=4 expandtab
augroup end

augroup mk_git
	autocmd!
	autocmd FileType gitcommit,gitrebase
		\ setlocal spell
augroup end

augroup mk_md
	autocmd!
	autocmd FileType markdown
		\   let g:statusline_wordcount_disabled=0
		\ | setlocal spell textwidth=78 foldlevel=99 keywordprg=dictls
		\ | nnoremap <Leader>f :ToggleMarkdownFolding<cr>
augroup end

augroup mk_html
	autocmd!
	autocmd FileType html,jinja.html,css,scss,toml,yml
		\ setlocal spell textwidth=0 tabstop=2 softtabstop=2
		\ shiftwidth=2 expandtab
augroup end
