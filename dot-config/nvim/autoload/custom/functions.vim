" --- nvim custom functions --------------------------------------------------
function! custom#functions#trim_trail_ws() range abort
	let l:cmd='keepjumps keeppatterns '
	let l:pat="s/\\s\\+$//e"
	if exists('a:firstline')
		exe l:cmd.a:firstline.','.a:lastline.l:pat
	else
		exe l:cmd.l:pat
	endif
	update
endfunction

function! custom#functions#trim_lead_ws() range abort
	let l:cmd='keepjumps keeppatterns '
	let l:pat="s/^\\s\\+//e"
	if exists('a:firstline')
		exe l:cmd.a:firstline.','.a:lastline.l:pat
	else
		exe l:cmd.l:pat
	endif
	update
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
	if empty(a:pattern)
		echohl WarningMsg
		echom 'Fzf git grep need an input pattern!'
		echohl None
		return
	endif

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
	if empty(a:word)
		echohl WarningMsg
		echom 'Fzf spell suggestion need an input word!'
		echohl None
		return
	endif

	return fzf#run(fzf#wrap({
		\ 'source': spellsuggest(a:word),
		\ 'sink': function("FzfSpellSink"),
		\ 'options': '--prompt="Spelling> " '.
		\   '--preview="dictls {}" '.
		\   '--preview-window "70%"',
		\ }))
endfunction

function! FzfDictSource(word)
	if empty(a:word)
		return readfile('/usr/share/dict/words')
	else
		return [a:word]
	endif
endfunction

function! FzfDictSink(word)
	call setreg('"', a:word)
endfunction

function! custom#functions#fzf_dict(word)
	return fzf#run(fzf#wrap({
		\ 'source': FzfDictSource(a:word),
		\ 'sink': function("FzfDictSink"),
		\ 'options': '--prompt="Dict> " '.
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

function! custom#functions#add_heading_md(level)
	let l:headers = {1: '=', 2: '-', 3: '#', 4: '#', 5: '#'}
	let l:line_num = line('.')
	let l:line_str = getline(l:line_num)
	let l:line_len = strchars(l:line_str)
	if a:level == 1 || a:level == 2
		let l:hline = repeat(l:headers[a:level], l:line_len)
		call append(l:line_num, l:hline)
	else
		let l:hline = repeat(l:headers[a:level], a:level).' '
			\ .l:line_str
		call setline(l:line_num, l:hline)
	endif
endfunction

function! custom#functions#add_heading_rst(level)
	let l:headers = {1: '=', 2: '=', 3: '-', 4: '~', 5: '^'}
	let l:line_num = line('.')
	let l:line_str = getline(l:line_num)
	let l:line_len = strchars(l:line_str)
	let l:hline = repeat(l:headers[a:level], l:line_len)
	if a:level == 1
		call append(l:line_num - 1, l:hline)
		call append(l:line_num + 1, l:hline)
	else
		call append(l:line_num, l:hline)
	endif
endfunction

let s:fmt_cmd_gq_ft=['c', 'cpp']

function! Format()
	if index(s:fmt_cmd_gq_ft, &ft) >= 0
		normal gggqG
	endif
endfunction

function! custom#functions#update()
	let l:winview=winsaveview()
	call Format()
	update
	call winrestview(l:winview)
endfunction
