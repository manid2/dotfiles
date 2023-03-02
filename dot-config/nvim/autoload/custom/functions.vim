" --- nvim custom functions --------------------------------------------------
"  TODO: Trim trailing whitespaces and format text:
"  o) on edited lines only.
"  o) on list of lines only.
"  o) on `git diff -U0` lines.
"  o) with option to highlight and confirmation.
"  o) automatically before buffer write.
function! custom#functions#trim_trail_ws() range
	let l:cmd="keepjumps keeppatterns "
	let l:pat="s/\\s\\+$//e"
	if exists('a:firstline')
		exe l:cmd.a:firstline.",".a:lastline.l:pat
	else
		exe l:cmd.l:pat
	endif
	call winrestview(b:winview)
endfunction

function! custom#functions#trim_lead_ws() range
	let l:cmd="keepjumps keeppatterns "
	let l:pat="s/^\\s\\+//e"
	if exists('a:firstline')
		exe l:cmd.a:firstline.",".a:lastline.l:pat
	else
		exe l:cmd.l:pat
	endif
	call winrestview(b:winview)
endfunction

function! custom#functions#toggle_syn()
	if exists("g:syntax_on")
		syntax off
	else
		syntax enable
	endif
endfunction

function! custom#functions#toggle_md_fold()
	if g:vim_markdown_folding_disabled
		let g:vim_markdown_folding_disabled=0
		setlocal foldlevel=0
	else
		let g:vim_markdown_folding_disabled=1
		setlocal foldlevel=99
	endif
endfunction

function! custom#functions#toggle_hi_long_lines()
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

function! custom#functions#diff_orig()
	exe "vert new ".expand('%').".orig~"
	r #
	1d_
	exe "setlocal bt=nofile bh=wipe nobl noswf ro ft=".&ft
	diffthis
	wincmd p
	diffthis
endfunction

function! custom#functions#diff_git()
	let l:fp=expand('%')
	exe "vert new ".l:fp.".git~"
	exe "read !git diff ".fnameescape(l:fp)." | patch -p1 -Rs -o -"
	1d_
	exe "setlocal bt=nofile bh=wipe nobl noswf ro ft=".&ft
	diffthis
	wincmd p
	diffthis
endfunction

function! custom#functions#hi_grp()
	let l:syn_id=synID(line('.'), col('.'), 1)
	echo synIDattr(l:syn_id, 'name').' -> '.
		\ synIDattr(synIDtrans(l:syn_id), 'name')
endfunction

" TODO: Add function, command and keymap to format text into table.
" TODO: Add function, command and keymap to search only in visual selections.
" TODO: Add custom function to format code using 'formatexpr=mylang#Format()'
" TODO: Add abbreviations to reduce typing.