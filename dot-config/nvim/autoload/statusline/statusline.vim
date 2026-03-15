" --- nvim statusline --------------------------------------------------------
" Disable word count on status line on start as it slows down vim.
let g:statusline_wordcount_disabled=1

" --- Performance caches -----------------------------------------------------
" Cache buffer count to avoid expensive getbufinfo() calls
let s:buf_count_cache = -1

function! statusline#statusline#update_buf_count() abort
	let s:buf_count_cache = len(getbufinfo({'buflisted': 1}))
endfunction

" --- Statusline sections ----------------------------------------------------
function! statusline#statusline#mode_flags() abort
	let l:md=mode(0)
	let l:ro=&readonly ? 'R' : ''
	let l:mo=!&modifiable ? 'M' : ''
	let l:mf=&modified ? '+' : ''
	let l:bfn=s:buf_count_cache > 1 ? '/'.string(s:buf_count_cache) : ''
	return '%0.10('.l:md.l:ro.l:mo.l:mf.' %n'.l:bfn.'%)'
endfunction

function! statusline#statusline#file_type() abort
	return '%0.10{&filetype}'
endfunction

function! statusline#statusline#git_str() abort
	return '%{statusline#statusline#git_branch_with_status()}'
endfunction

function! statusline#statusline#current_tag() abort
	if exists(':TagbarCurrentTag')
		return '%0.24{tagbar#currenttag(''%s'', '''')}'
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
	" Cache wordcount() result to avoid multiple expensive calls
	let l:wc_dict = wordcount()
	let l:wc = ''
	if has_key(l:wc_dict, 'visual_words')
		let l:wc = l:wc_dict.visual_words . '/' . l:wc_dict.words
	else
		let l:wc = l:wc_dict.cursor_words . '/' . l:wc_dict.words
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

" Cache git status to minimize system() calls
let s:git_cache = {'branch': '', 'flags': '', 'time': 0, 'bufnr': -1}
let s:git_cache_timeout = 5  " seconds (increased from 2 for better performance)

" Cache git directory lookups to avoid repeated finddir() traversals
let s:gitdir_cache = {}

" Cache git operation state to reduce file I/O
let s:git_op_cache = {'label': '', 'time': 0, 'gitdir': ''}

function! statusline#statusline#git_branch_with_status() abort
	" Check cache validity
	let l:now = localtime()
	let l:bufnr = bufnr('%')
	if s:git_cache.bufnr == l:bufnr && (l:now - s:git_cache.time) < s:git_cache_timeout
		if !empty(s:git_cache.branch)
			return '  ' . s:git_cache.branch . s:git_cache.flags
		endif
		return ''
	endif

	" Fallback chain: vim-airline → vim-fugitive → raw git → empty
	let l:branch = ''
	let l:flags = ''

	" 1. Try vim-airline branch extension (preferred when available)
	if exists('*airline#extensions#branch#get_head')
		let l:branch = airline#extensions#branch#get_head()
		if !empty(l:branch)
			let l:flags = s:git_status_flags()
			let s:git_cache = {'branch': l:branch, 'flags': l:flags, 'time': l:now, 'bufnr': l:bufnr}
			return '  ' . l:branch . l:flags
		endif
	endif

	" 2. Try vim-fugitive for branch name
	if exists('*FugitiveHead')
		let l:branch = FugitiveHead()
		if !empty(l:branch)
			let l:flags = s:git_status_flags()
			let s:git_cache = {'branch': l:branch, 'flags': l:flags, 'time': l:now, 'bufnr': l:bufnr}
			return '  ' . l:branch . l:flags
		endif
	endif

	" 3. Fallback to raw git command (also handles branch detection)
	if executable('git')
		let l:result = s:git_status_exe()
		let s:git_cache.time = l:now
		let s:git_cache.bufnr = l:bufnr
		return l:result
	endif

	return ''
endfunction

function! s:git_status_flags() abort
	" Used when fugitive already resolved the branch name — status flags only
	" Optimized: use head -c1 instead of head -1, use --count flag
	let l:raw = system(
		\ '{ git status --porcelain 2>/dev/null | head -c1; echo "---"; } &&'
		\ . ' git rev-list --count @{u}.. 2>/dev/null &&'
		\ . ' git rev-list --count ..@{u} 2>/dev/null'
		\ )
	let l:lines = split(l:raw, '\n', 1)
	let l:flags = ''
	if get(l:lines, 0, '') !=# '---' | let l:flags .= '*' | endif
	if str2nr(get(l:lines, 1, '0'))  | let l:flags .= '↑' | endif
	if str2nr(get(l:lines, 2, '0'))  | let l:flags .= '↓' | endif
	return l:flags . s:git_operation_label()
endfunction

function! s:git_status_exe() abort
	" Single shell call: branch, dirty flag, unpushed, unpulled, detached HEAD
	" Optimized: use head -c1 instead of head -1, use --count flag
	let l:raw = system(
		\ '{ git symbolic-ref --short HEAD 2>/dev/null'
		\ . '  || echo ":"$(git rev-parse --short HEAD 2>/dev/null); } &&'
		\ . ' { git status --porcelain 2>/dev/null | head -c1; echo "---"; } &&'
		\ . ' git rev-list --count @{u}.. 2>/dev/null &&'
		\ . ' git rev-list --count ..@{u} 2>/dev/null'
		\ )

	if v:shell_error && empty(l:raw)
		let s:git_cache.branch = ''
		let s:git_cache.flags = ''
		return ''
	endif

	let l:lines = split(l:raw, '\n', 1)
	let l:branch = get(l:lines, 0, '')

	if empty(l:branch) || l:branch ==# ':'
		let s:git_cache.branch = ''
		let s:git_cache.flags = ''
		return ''
	endif

	let l:flags = ''
	if get(l:lines, 1, '') !=# '---' | let l:flags .= '*' | endif
	if str2nr(get(l:lines, 2, '0'))  | let l:flags .= '↑' | endif
	if str2nr(get(l:lines, 3, '0'))  | let l:flags .= '↓' | endif
	let l:flags .= s:git_operation_label()

	let s:git_cache.branch = l:branch
	let s:git_cache.flags = l:flags
	return '  ' . l:branch . l:flags
endfunction

function! s:get_cached_gitdir() abort
	" Cache git directory lookups to avoid repeated finddir() traversals
	let l:bufnr = bufnr('%')
	if has_key(s:gitdir_cache, l:bufnr)
		return s:gitdir_cache[l:bufnr]
	endif

	let l:gitdir = ''

	" Try vim-fugitive first
	if exists('*FugitiveGitDir')
		let l:gitdir = FugitiveGitDir()
	endif

	" Fallback: walk up from current buffer's directory
	if empty(l:gitdir)
		let l:bufdir = expand('%:p:h')
		if !empty(l:bufdir)
			let l:found = finddir('.git', l:bufdir . ';')
			let l:gitdir = !empty(l:found) ? fnamemodify(l:found, ':p:h') : ''
		endif
	endif

	" Last resort: use cwd
	if empty(l:gitdir)
		let l:found = finddir('.git', getcwd() . ';')
		let l:gitdir = !empty(l:found) ? fnamemodify(l:found, ':p:h') : ''
	endif

	let s:gitdir_cache[l:bufnr] = l:gitdir
	return l:gitdir
endfunction

function! s:git_operation_label() abort
	" Detect ongoing git operations via .git state dirs/files (no shell needed)
	" Optimized: cache operation state to reduce file I/O
	let l:gitdir = s:get_cached_gitdir()

	if empty(l:gitdir)
		return ''
	endif

	" Check cache validity (1 second timeout for operation state)
	let l:now = localtime()
	if s:git_op_cache.gitdir ==# l:gitdir && (l:now - s:git_op_cache.time) < 1
		return s:git_op_cache.label
	endif

	let l:label = ''

	if filereadable(l:gitdir . '/MERGE_HEAD')
		let l:label = '|MERGING'
	elseif isdirectory(l:gitdir . '/rebase-merge')
		let l:msgnum_file = l:gitdir . '/rebase-merge/msgnum'
		let l:end_file = l:gitdir . '/rebase-merge/end'
		let l:step  = filereadable(l:msgnum_file) ? get(readfile(l:msgnum_file), 0, '?') : '?'
		let l:total = filereadable(l:end_file) ? get(readfile(l:end_file), 0, '?') : '?'
		let l:label = '|REBASING ' . l:step . '/' . l:total
	elseif isdirectory(l:gitdir . '/rebase-apply')
		let l:label = '|APPLYING'
	elseif filereadable(l:gitdir . '/CHERRY_PICK_HEAD')
		let l:label = '|CHERRY-PICKING'
	elseif filereadable(l:gitdir . '/REVERT_HEAD')
		let l:label = '|REVERTING'
	elseif filereadable(l:gitdir . '/BISECT_LOG')
		let l:label = '|BISECTING'
	endif

	" Update cache
	let s:git_op_cache = {'label': l:label, 'time': l:now, 'gitdir': l:gitdir}

	return l:label
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
