" --- nvim options -----------------------------------------------------------
set scrolloff=5      " Show 5 lines of context around the cursor.
set statusline=%{%statusline#statusline#expr()%}

" Set characters to see invisible characters
set listchars=tab:>\ ,lead:.,trail:-,extends:>,precedes:<,nbsp:+

" Find include files in file relative directory and vim current directory.
set path+=include,./include
set path+=/usr/include/x86_64-linux-gnu " Add system include paths

" Use 1 shiftwidth for line continuation in vim scripts
let g:vim_indent_cont=shiftwidth()

" Enable optional C syntax
let c_gnu=1
let c_comment_strings=1
let c_space_errors=1
let c_ansi_typedefs=1
let c_ansi_constants=1
