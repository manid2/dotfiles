if executable('clang-format')
	setlocal formatprg=clang-format
endif

function! s:MakeCheck() abort
	let l:file = expand('%:r').'-check'
	if exists(':Make')
		exe 'Make SHOW_TEST_OUTPUT=1 '.l:file
	else
		exe ':!make SHOW_TEST_OUTPUT=1 '.l:file
	endif
endfunction

command! -buffer TestFile              call s:MakeCheck()
nnoremap <buffer> <Leader>t            :TestFile<cr>
