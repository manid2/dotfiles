" Update some distributed syntax 
if !exists("c_no_c99") " ISO C99
	syn keyword cConstant TRUE FALSE
endif

" Match typedefs ending with '_[te]'
syn match cType "\v<(\h\w+)_[te]>"
