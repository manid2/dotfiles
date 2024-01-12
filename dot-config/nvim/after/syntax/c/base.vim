" Update some distributed syntax 
if !exists("c_no_c99") " ISO C99
	syn keyword cConstant TRUE FALSE
endif

" Match typedefs ending with '_[te]'
syn match cType "\v<(\h\w+)_[te]>"
" Match functions and function like macros.
syn match cFunction "\v(\h\w+)\s*\("me=e-1

" Highlight syntax groups
hi def link cFunction Function
