" NOTE: Can be generated from ctags output

" Update some distributed syntax 
if !exists("c_no_c99") " ISO C99
	syn keyword cConstant TRUE FALSE
endif

" Match typedefs ending with '_[te]'
syn match cType "\v<(\h\w+)_[te]>"
" Match functions and function like macros.
syn match cFunction "\v(\h\w+)\s*\("me=e-1
" Match struct, enum and union names, must clear the original definition.
" Refer: https://stackoverflow.com/a/25666544
" FIXME: struct, enum and union keywords are not highlighted now. 
"syn match cStructName "\v(struct|enum|union)\s+\zs(\h\w+)"
"syn match cStructType "\v(struct|enum|union)"
"syn clear cStructure

" Highlight syntax groups
hi def link cFunction Function
"hi def link cStructName Function
"hi def link cStructType Type
