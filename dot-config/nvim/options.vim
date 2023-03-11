" --- vim options ------------------------------------------------------------
if !has('nvim')
	set nocompatible " Use Vim defaults instead of 100% vi compatibility.
	set showcmd      " Show (partial) command in status line.
	set showmatch    " Show matching brackets.
	set autoindent   " Auto indent new lines based on previous line.
	set smartindent  " Like 'autoindent' but uses C syntax and indents.
	set hlsearch     " Highlight searches.
	set wildmenu     " Display completion matches in a status line.
	set nomodeline   " Disable modelines for security reasons.
	set backspace=indent,eol,start  " More powerful backspacing.

	" View man pages inside vim
	runtime ftplugin/man.vim
	set keywordprg=:Man

	" Enable syntax highlight
	syntax enable

	" Load indentation rules and plugins according to the detected
	" filetype.
	filetype plugin indent on

	set laststatus=2     " Always show statusline
endif

set scrolloff=5      " Show 5 lines of context around the cursor.
set mouse=           " Disable mouse on startup.
set history=100      " Command line history.
set statusline=%{%statusline#statusline#expr()%}

" Set characters to see invisible characters
set listchars=tab:>\ ,lead:.,trail:-,extends:>,precedes:<,nbsp:+

setglobal include=
setglobal tags=./tags;,tags
setglobal path=.,,
