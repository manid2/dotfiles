" --- nvim custom functions --------------------------------------------------
function! custom#functions#trim_trail_ws() range abort
	let l:cmd='keepjumps keeppatterns '
	let l:pat="s/\\s\\+$//e"
	if exists('a:firstline')
		exe l:cmd.a:firstline.','.a:lastline.l:pat
	else
		exe l:cmd.l:pat
	endif
	call winrestview(b:winview)
endfunction

function! custom#functions#trim_lead_ws() range abort
	let l:cmd='keepjumps keeppatterns '
	let l:pat="s/^\\s\\+//e"
	if exists('a:firstline')
		exe l:cmd.a:firstline.','.a:lastline.l:pat
	else
		exe l:cmd.l:pat
	endif
	call winrestview(b:winview)
endfunction

function! custom#functions#toggle_syn() abort
	if exists('g:syntax_on')
		syntax off
	else
		syntax enable
	endif
endfunction

function! custom#functions#toggle_md_fold() abort
	if g:vim_markdown_folding_disabled
		let g:vim_markdown_folding_disabled=0
		setlocal foldlevel=0
	else
		let g:vim_markdown_folding_disabled=1
		setlocal foldlevel=99
	endif
endfunction

function! custom#functions#toggle_hi_long_lines() abort
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

function! custom#functions#diff_orig() abort
	exe 'vert new '.expand('%').'.orig~'
	r #
	1d_
	exe 'setlocal buftype=nofile bufhidden=wipe nobuflisted noswapfile '.
		\ 'readonly filetype='.&filetype
	diffthis
	wincmd p
	diffthis
endfunction

function! custom#functions#diff_git() abort
	let l:fp=expand('%')
	exe 'vert new '.l:fp.'.git~'
	exe 'read !git diff '.fnameescape(l:fp).' | patch -p1 -Rs -o -'
	1d_
	exe 'setlocal buftype=nofile bufhidden=wipe nobuflisted noswapfile '.
		\ 'readonly filetype='.&filetype
	diffthis
	wincmd p
	diffthis
endfunction

function! custom#functions#hi_grp() abort
	let l:syn_id=synID(line('.'), col('.'), 1)
	echo synIDattr(l:syn_id, 'name').' -> '.
		\ synIDattr(synIDtrans(l:syn_id), 'name')
endfunction

function! custom#functions#fzf_git_grep(pattern)
	return fzf#vim#grep(
		\ 'git grep --line-number -- '.shellescape(a:pattern),
		\ 0,
		\ fzf#vim#with_preview({
		\   'dir': systemlist('git rev-parse --show-toplevel')[0]
		\   })
		\ )
endfunction

function! FzfSpellSink(word)
	exe 'normal! "_ciw'.a:word
endfunction

function! custom#functions#fzf_spell_suggest(word)
	return fzf#run(fzf#wrap({
		\ 'source': spellsuggest(a:word),
		\ 'sink': function("FzfSpellSink"),
		\ 'options': '--prompt="Spelling> " '.
		\   '--preview="dictls {}" '.
		\   '--preview-window "70%"',
		\ }))
endfunction

function! custom#functions#date()
	return strftime('%Y-%m-%dT%H:%M:%S%z')
endfunction

function! custom#functions#date_append()
	let date=custom#functions#date()
	exe "normal! a".date." "
endfunction

" TODO: Add function, command and keymap to format text into table.
" TODO: Add function, command and keymap to search only in visual selections.
" TODO: Add custom function to format code using 'formatexpr=mylang#Format()'
" TODO: Add abbreviations to reduce typing.
