function! s:Message(msg)
	echohl WarningMsg
	echomsg 'grep-replace: ' . a:msg
	echohl None
endfunction

" vim grep wrapper
function! s:VimGrep(pattern, files = '%', ...)
	if empty(a:pattern)
		call s:Message('Vim grep need an input pattern!')
	endif

	let l:options = 'g'
	let l:files = a:files.' '.join(a:000)
	silent! exe 'vimgrep! /'.a:pattern.'/'.l:options.' '.l:files
	cwindow
endfunction

" Replace results in vim grep
function! s:VimReplace(pattern, replace = '', files = '%', ...)
	if empty(a:pattern)
		call s:Message('Vim grep need an input pattern!')
	endif

	let l:grep_opts1 = 'g'
	let l:subs_flags = 'ge'
	let l:files = a:files.' '.join(a:000)
	silent! exe 'vimgrep! /'.a:pattern.'/'.l:grep_opts1.' '.l:files
	silent! exe 'cfdo %s/'.a:pattern.'/'.a:replace.'/'.l:subs_flags
	update
endfunction

" Commands
command! -nargs=+ VimGrep      call s:VimGrep(<f-args>)
command! -nargs=+ VimReplace   call s:VimReplace(<f-args>)

" Keymaps
nnoremap <Leader>vw            :VimGrep<space>
nnoremap <Leader>vc            :VimGrep <C-r>=expand("<cword>")<cr><cr>
nnoremap <Leader>vd            :VimReplace <C-r>=expand("<cword>")<cr><cr>
nnoremap <Leader>vr            :VimReplace <C-r>=expand("<cword>")<cr><space>
