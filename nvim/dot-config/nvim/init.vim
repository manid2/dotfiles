" nvim init.vim, author: Mani Kumar

runtime options.vim
runtime colors.vim
runtime autocmds.vim
runtime plugins.vim
runtime keymaps.vim

" --- Custom functions and commands ------------------------------------------
"  TODO: Trim trailing whitespaces and format text:
"  o) on edited lines only.
"  o) on list of lines only.
"  o) on `git diff -U0` lines.
"  o) with option to highlight and confirmation.
"  o) automatically before buffer write.
function! TrimTrailingWhitespace() range
	let l:cmd="keepjumps keeppatterns "
	let l:pat="s/\\s\\+$//e"
	if exists('a:firstline')
		exe l:cmd.a:firstline.",".a:lastline.l:pat
	else
		exe l:cmd.l:pat
	endif
	call winrestview(b:winview)
endfunction

function! TrimLeadingWhitespace() range
	let l:cmd="keepjumps keeppatterns "
	let l:pat="s/^\\s\\+//e"
	if exists('a:firstline')
		exe l:cmd.a:firstline.",".a:lastline.l:pat
	else
		exe l:cmd.l:pat
	endif
	call winrestview(b:winview)
endfunction

function! ToggleSyntax()
	if exists("g:syntax_on")
		syntax off
	else
		syntax enable
	endif
endfunction

function! ToggleMarkdownFolding()
	if g:vim_markdown_folding_disabled
		let g:vim_markdown_folding_disabled=0
		setlocal foldlevel=0
	else
		let g:vim_markdown_folding_disabled=1
		setlocal foldlevel=99
	endif
endfunction

function! ToggleHighlightLongLines()
	if exists('w:long_line_match')
		silent! call matchdelete(w:long_line_match)
		unlet w:long_line_match
	elseif &textwidth > 0
		let w:long_line_match =
			\ matchadd('ColorColumn', '\%>'.&textwidth.'v.\+', -1)
	else
		let w:long_line_match =
			\ matchadd('ColorColumn', '\%>79v.\+', -1)
	endif
endfunction

function! DiffOrig()
	exe "vert new ".expand('%').".orig~"
	r #
	1d_
	exe "setlocal bt=nofile bh=wipe nobl noswf ro ft=".&ft
	diffthis
	wincmd p
	diffthis
endfunction

function! DiffGit()
	let l:fp=expand('%')
	exe "vert new ".l:fp.".git~"
	exe "read !git diff ".fnameescape(l:fp)." | patch -p1 -Rs -o -"
	1d_
	exe "setlocal bt=nofile bh=wipe nobl noswf ro ft=".&ft
	diffthis
	wincmd p
	diffthis
endfunction

function! HighlightGroup()
	let l:syn_id=synID(line('.'), col('.'), 1)
	echo synIDattr(l:syn_id, 'name').' -> '.
		\ synIDattr(synIDtrans(l:syn_id), 'name')
endfunction

" Commands to use custom functions
command! -range=% TrimTrailingWhitespace
	\ let b:winview=winsaveview() |
	\ <line1>,<line2>call TrimTrailingWhitespace()

command! -range=% TrimLeadingWhitespace
	\ let b:winview=winsaveview() |
	\ <line1>,<line2>call TrimLeadingWhitespace()

command! -nargs=0 ToggleSyntax call ToggleSyntax()
command! -nargs=0 ToggleMarkdownFolding call ToggleMarkdownFolding()
command! -nargs=0 ToggleHighlightLongLines call ToggleHighlightLongLines()
command! -nargs=0 DiffOrig call DiffOrig()
command! -nargs=0 DiffGit call DiffGit()
command! -nargs=0 HighlightGroup call HighlightGroup()

" TODO: Add function, command and keymap to format text into table.
" TODO: Add function, command and keymap to search only in visual selections.
" TODO: Add custom function to format code using 'formatexpr=mylang#Format()'
" TODO: Add abbreviations to reduce typing.

" --- statusline section -----------------------------------------------------
" TODO: Move statusline section into a plugin
"   refer: https://stackoverflow.com/a/17184285
" TODO: Use autoload functions instead of function name prefix.

" Define global variables

" NOTE: Execute system commands at the start to avoid errors in vim and slows
" down vim as it evaluates status line expression continuously.
let s:git_str_cmd="$SHELL -c ".shellescape(
	\"source ~/.local/bin/git-sh-prompt; ".
	\"GIT_PS1_SHOWDIRTYSTATE='y' ".
	\"GIT_PS1_SHOWSTASHSTATE='y' ".
	\"GIT_PS1_SHOWUNTRACKEDFILES='y' ".
	\"GIT_PS1_DESCRIBE_STYLE='contains' ".
	\"GIT_PS1_SHOWUPSTREAM='auto' ".
	\"__git_ps1")
let g:vim_git_branch=trim(system(s:git_str_cmd))

" Disable word count on status line on start as it slows down vim.
let g:statusline_wordcount_disabled=1

" statusline helper functions
function! SiSlSecModeFlags()
	let l:md=mode(0)
	let l:ro=&readonly ? 'R' : ''
	let l:mo=!&modifiable ? 'M' : ''
	let l:mf=&modified ? '+' : ''
	let l:bfn=len(getbufinfo({'buflisted':1}))
	let l:bfn=l:bfn > 1 ? '/'.string(l:bfn) : ''
	return "%0.10(".l:md.l:ro.l:mo.l:mf." %n".l:bfn."%)"
endfunction

function! SiSlSecFileType()
	" TODO: truncate right when exceeding max chars.
	return "%0.10(".&filetype."%)"
endfunction

function! SiSlSecGitStr()
	return "%0.24(".g:vim_git_branch."%)"
endfunction

function! SiSlSecCurrentTag()
	let l:ct=''
	if exists(':TagbarCurrentTag')
		let l:ct="%0.24(".tagbar#currenttag('%s', '')."%)"
	endif
	return l:ct
endfunction

function! SiSlSecWordCount()
	let l:wc=''
	if g:statusline_wordcount_disabled
		return l:wc
	endif
	if has_key(wordcount(),'visual_words')
		let l:wc=wordcount().visual_words."/".wordcount().words
	else
		let l:wc=wordcount().cursor_words."/".wordcount().words
	endif
	return "%0.9(".l:wc."%)"
endfunction

function! SiSlSecRelFileInfo()
	return "%0.50(%f:%l:%c%V|%L|%p%%%)"
endfunction

function! StatuslineExpr()
	let l:sp=' '
	let l:secsp="%="
	let l:func_refs = [
		\ SiSlSecModeFlags(),
		\ SiSlSecFileType(),
		\ SiSlSecGitStr(),
		\ SiSlSecCurrentTag(),
		\ l:secsp,
		\ SiSlSecWordCount(),
		\ SiSlSecRelFileInfo()
		\ ]
	return join(l:func_refs, l:sp)
endfunction

set laststatus=2     " Always show statusline
set statusline=%{%StatuslineExpr()%}

" Custom status line functions.
function! ToggleStatuslineWordcount()
	if g:statusline_wordcount_disabled
		let g:statusline_wordcount_disabled=0
	else
		let g:statusline_wordcount_disabled=1
	endif
endfunction

" TODO: Add toggle function for status line sections to view them as needed.

" Custom status line commands.
command! -nargs=0 ToggleStatuslineWordcount call ToggleStatuslineWordcount()

" Custom status line keymaps.
nnoremap <silent> <Leader>wc :ToggleStatuslineWordcount<cr>
