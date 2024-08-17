if executable('clang-format')
	setlocal formatprg=clang-format
endif

function! s:MakeCheck() abort
	let l:file = expand('%:r').'-check'
	if exists(':Make')
		exe 'Make '.l:file
	else
		exe ':!make '.l:file
	endif
endfunction

command! -buffer TestFile              call s:MakeCheck()
nnoremap <buffer> <Leader>t            :TestFile<cr>
