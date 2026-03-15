" --- nvim statusline --------------------------------------------------------
" Disable word count on status line on start as it slows down vim.
let g:statusline_wordcount_disabled=1

" --- Statusline sections ----------------------------------------------------
function! statusline#statusline#mode_flags() abort
	let l:md=mode(0)
	let l:ro=&readonly ? 'R' : ''
	let l:mo=!&modifiable ? 'M' : ''
	let l:mf=&modified ? '+' : ''
	let l:bfn=len(getbufinfo({'buflisted':1}))
	let l:bfn=l:bfn > 1 ? '/'.string(l:bfn) : ''
	return '%0.10('.l:md.l:ro.l:mo.l:mf.' %n'.l:bfn.'%)'
endfunction

function! statusline#statusline#file_type() abort
	return '%0.10{&filetype}'
endfunction

function! statusline#statusline#git_str() abort
	" 1. vim-airline branch extension (preferred when available)
	if exists('*airline#extensions#branch#get_head')
		return '%{airline#util#wrap(airline#extensions#branch#get_head(),80)}'
	endif

	" 2. Use custom git branch function with status indicators
	return '%{statusline#statusline#git_branch_with_status()}'
endfunction

function! statusline#statusline#current_tag() abort
	if exists(':TagbarCurrentTag')
		return '%0.24(%{tagbar#currenttag(''%s'', '''')}%)'
	endif
	return ''
endfunction

function! statusline#statusline#word_count() abort
	return '%0.9(%{statusline#statusline#get_word_count()}%)'
endfunction

function! statusline#statusline#get_word_count() abort
	if g:statusline_wordcount_disabled
		return ''
	endif
	let l:wc = ''
	if has_key(wordcount(),'visual_words')
		let l:wc = wordcount().visual_words.'/'.wordcount().words
	else
		let l:wc = wordcount().cursor_words.'/'.wordcount().words
	endif
	return l:wc
endfunction

function! statusline#statusline#file_info() abort
	return '%0.50(%f:%l:%c%V|%L|%p%%%)'
endfunction

" --- Statusline helper functions -------------------------------------------
function! statusline#statusline#toggle_word_count() abort
	if g:statusline_wordcount_disabled
		let g:statusline_wordcount_disabled=0
	else
		let g:statusline_wordcount_disabled=1
	endif
endfunction

function! statusline#statusline#git_branch_with_status() abort
	let l:branch = ''

	" 1. Prefer vim-fugitive for branch name
	if exists('*FugitiveHead')
		let l:branch = FugitiveHead()
	endif

	" 2. Fallback to raw git command
	if empty(l:branch) && executable('git')
		"let l:branch = substitute(system('git branch --show-current 2>/dev/null'), '\n', '', 'g')
		return s:git_status_exe()
	endif

	return l:branch
endfunction

function! s:git_status_exe() abort
	if !executable('git')
		return ''
	endif

	" Single call: line 1 = branch name, line 2 = short status, line 3 = unpushed count
	let l:raw = system('git branch --show-current 2>/dev/null && git status --porcelain 2>/dev/null | head -1 && git rev-list @{u}.. 2>/dev/null | wc -l && git rev-list ..@{u} 2>/dev/null | wc -l')

	if v:shell_error && empty(l:raw)
		return ''
	endif

	let l:lines = split(l:raw, '\n', 1)

	" Branch name (line 1)
	let l:branch = get(l:lines, 0, '')

	" Detached HEAD fallback
	if empty(l:branch)
		let l:branch = ':' . substitute(system('git rev-parse --short HEAD 2>/dev/null'), '\n', '', 'g')
	endif

	if empty(l:branch) || l:branch ==# ':'
		return ''
	endif

	" Status indicators
	let l:status = ''
	if !empty(get(l:lines, 1, ''))  | let l:status .= '*' | endif
	if str2nr(get(l:lines, 2, '0')) | let l:status .= '↑' | endif
	if str2nr(get(l:lines, 3, '0')) | let l:status .= '↓' | endif

	return '  ' . l:branch . l:status
endfunction

" --- vim-airline part definitions -------------------------------------------
function! statusline#statusline#define_airline_parts() abort
	" Left side
	let g:airline_section_a = statusline#statusline#mode_flags()
	let g:airline_section_b = statusline#statusline#file_type()
	let g:airline_section_c = statusline#statusline#git_str()
	let g:airline_section_d = statusline#statusline#current_tag()

	" Right side
	let g:airline_section_x = statusline#statusline#word_count()
	let g:airline_section_y = statusline#statusline#file_info()
endfunction

" --- statusline fallback ----------------------------------------------------
function! statusline#statusline#expr() abort
	let l:sp=' '
	let l:secsp='%='
	let l:slparts = [
		\ statusline#statusline#mode_flags(),
		\ statusline#statusline#file_type(),
		\ statusline#statusline#git_str(),
		\ statusline#statusline#current_tag(),
		\ l:secsp,
		\ statusline#statusline#word_count(),
		\ statusline#statusline#file_info()
		\ ]
	return join(l:slparts, l:sp)
endfunction
