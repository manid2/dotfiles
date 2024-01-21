" --- vim autocmds -----------------------------------------------------------
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
		\ setlocal spell textwidth=78 include&
		\ path+=include,./include
		\ path+=/usr/include/x86_64-linux-gnu
		\ | let c_gnu=1
		\ | let c_comment_strings=1
		\ | let c_space_errors=1
		\ | let c_ansi_typedefs=1
		\ | let c_ansi_constants=1
augroup end

augroup mk_sh
	autocmd!
	autocmd FileType sh,zsh,bash,vim,lua
		\ setlocal spell textwidth=78
	autocmd FileType sh,zsh,bash
		\ setlocal include=^\\s*\\%(\\.\\\|source\\)\\s
	autocmd FileType vim
		\ let g:vim_indent_cont=shiftwidth()
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
	autocmd FileType markdown,rst
		\   let g:statusline_wordcount_disabled=0
		\ | setlocal spell textwidth=78 foldlevel=99 keywordprg=dictls
		\ | nnoremap <Leader>f :ToggleMarkdownFolding<cr>
augroup end

augroup mk_html
	autocmd!
	autocmd FileType html,jinja.html,css,scss,toml,yml,json,javascript
		\ setlocal spell textwidth=0 tabstop=2 softtabstop=2
		\ shiftwidth=2 expandtab
augroup end
