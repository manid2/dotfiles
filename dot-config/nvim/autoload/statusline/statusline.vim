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
	return '%{statusline#git#branch_with_status()}'
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
