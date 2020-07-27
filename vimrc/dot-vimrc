" All system-wide defaults are set in $VIMRUNTIME/debian.vim and sourced by
" the call to :runtime you can find below.  If you wish to change any of those
" settings, you should do it in this file (/etc/vim/vimrc), since debian.vim
" will be overwritten everytime an upgrade of the vim packages is performed.
" It is recommended to make changes after sourcing debian.vim since it alters
" the value of the 'compatible' option.

" This line should not be removed as it ensures that various options are
" properly set to work with the Vim-related packages available in Debian.
runtime! debian.vim

" Vim will load $VIMRUNTIME/defaults.vim if the user does not have a vimrc.
" This happens after /etc/vim/vimrc(.local) are loaded, so it will override
" any settings in these files.
" If you don't want that to happen, uncomment the below line to prevent
" defaults.vim from being loaded.
" let g:skip_defaults_vim = 1

" Uncomment the next line to make Vim more Vi-compatible
" NOTE: debian.vim sets 'nocompatible'.  Setting 'compatible' changes numerous
" options, so any other options should be set AFTER setting 'compatible'.
"set compatible

" Vim5 and later versions support syntax highlighting. Uncommenting the next
" line enables syntax highlighting by default.
if has("syntax")
  syntax on
endif

" If using a dark background within the editing area and syntax highlighting
" turn on this option as well
"set background=dark

" Uncomment the following to have Vim jump to the last position when
" reopening a file
if has("autocmd")
  au BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif
endif

" Uncomment the following to have Vim load indentation rules and plugins
" according to the detected filetype.
if has("autocmd")
  filetype plugin indent on
endif

" The following are commented out as they cause vim to behave a lot
" differently from regular Vi. They are highly recommended though.
set showcmd		" Show (partial) command in status line.
set showmatch		" Show matching brackets.
"set ignorecase		" Do case insensitive matching
"set smartcase		" Do smart case matching
"set incsearch		" Incremental search
"set autowrite		" Automatically save before commands like :next and :make
"set hidden		" Hide buffers when they are abandoned
"set mouse=a		" Enable mouse usage (all modes)

" Source a global configuration file if available
if filereadable("/etc/vim/vimrc.local")
  source /etc/vim/vimrc.local
endif

" copied from rhel build server -- begin
"if v:lang =~ "utf8$" || v:lang =~ "UTF-8$"
"   set fileencodings=ucs-bom,utf-8,latin1
"endif

"set nocompatible	" Use Vim defaults (much better!)
"set bs=indent,eol,start		" allow backspacing over everything in insert mode
"set ai			" always set autoindenting on
"set backup		" keep a backup file
"set viminfo='20,\"50	" read/write a .viminfo file, don't store more
"			" than 50 lines of registers
"set history=50		" keep 50 lines of command line history
"set ruler		" show the cursor position all the time

" Only do this part when compiled with support for autocommands
"if has("autocmd")
"  augroup redhat
"  autocmd!
"  " In text files, always limit the width of text to 78 characters
"  " autocmd BufRead *.txt set tw=78
"  " When editing a file, always jump to the last cursor position
"  autocmd BufReadPost *
"  \ if line("'\"") > 0 && line ("'\"") <= line("$") |
"  \   exe "normal! g'\"" |
"  \ endif
"  " don't write swapfile on most commonly used directories for NFS mounts or USB sticks
"  autocmd BufNewFile,BufReadPre /media/*,/run/media/*,/mnt/* set directory=~/tmp,/var/tmp,/tmp
"  " start with spec file template
"  autocmd BufNewFile *.spec 0r /usr/share/vim/vimfiles/template.spec
"  augroup END
"endif

"if has("cscope") && filereadable("/usr/bin/cscope")
"   set csprg=/usr/bin/cscope
"   set csto=0
"   set cst
"   set nocsverb
"   " add any database in current directory
"   if filereadable("cscope.out")
"      cs add $PWD/cscope.out
"   " else add database pointed to by environment
"   elseif $CSCOPE_DB != ""
"      cs add $CSCOPE_DB
"   endif
"   set csverb
"endif

" Switch syntax highlighting on, when the terminal has colors
" Also switch on highlighting the last used search pattern.
"if &t_Co > 2 || has("gui_running")
"  syntax on
"  set hlsearch
"endif

"filetype plugin on

"if &term=="xterm"
"     set t_Co=8
"     set t_Sb=[4%dm
"     set t_Sf=[3%dm
"endif

" Don't wake up system with blinking cursor:
" http://www.linuxpowertop.org/known.php
"let &guicursor = &guicursor . ",a:blinkon0"
" copied below from rhel build server -- end

" custom settings
set smartindent
set hlsearch
"set number
"set tabstop=2 shiftwidth=2 expandtab
"colorscheme darkblue " for dark terminals
