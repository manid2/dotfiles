" --- nvim statusline --------------------------------------------------------
let s:git_str_cmd='$SHELL -c '.shellescape(
	\'source ~/.local/bin/git-sh-prompt; '.
	\"GIT_PS1_SHOWDIRTYSTATE='y' ".
	\"GIT_PS1_SHOWSTASHSTATE='y' ".
	\"GIT_PS1_SHOWUNTRACKEDFILES='y' ".
	\"GIT_PS1_DESCRIBE_STYLE='contains' ".
	\"GIT_PS1_SHOWUPSTREAM='auto' ".
	\'__git_ps1')

" TODO: Provide defaults for global variables.
" Git PS1 string
let g:vim_git_branch=trim(system(s:git_str_cmd))

" Disable word count on status line on start as it slows down vim.
let g:statusline_wordcount_disabled=1

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
	" TODO: truncate right when exceeding max chars.
	return '%0.10('.&filetype.'%)'
endfunction

function! statusline#statusline#git_str() abort
	return '%0.24('.g:vim_git_branch.'%)'
endfunction

function! statusline#statusline#current_tag() abort
	let l:ct=''
	if exists(':TagbarCurrentTag')
		let l:ct='%0.24('.tagbar#currenttag('%s', '').'%)'
	endif
	return l:ct
endfunction

function! statusline#statusline#word_count() abort
	let l:wc=''
	if g:statusline_wordcount_disabled
		return l:wc
	endif
	if has_key(wordcount(),'visual_words')
		let l:wc=wordcount().visual_words.'/'.wordcount().words
	else
		let l:wc=wordcount().cursor_words.'/'.wordcount().words
	endif
	return '%0.9('.l:wc.'%)'
endfunction

function! statusline#statusline#file_info() abort
	return '%0.50(%f:%l:%c%V|%L|%p%%%)'
endfunction

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

" Custom status line functions.
function! statusline#statusline#toggle_word_count() abort
	if g:statusline_wordcount_disabled
		let g:statusline_wordcount_disabled=0
	else
		let g:statusline_wordcount_disabled=1
	endif
endfunction

" TODO: Add toggle function for status line sections to view them as needed.
