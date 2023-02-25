" NeoVim init.vim, author: Mani Kumar

" --- NeoVim options ---------------------------------------------------------
set scrolloff=5      " Show 5 lines of context around the cursor.

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

" --- Highlight colors -------------------------------------------------------
" Override colors for some highlight groups
"
" NOTE: These colors are correct for dark backgrounds.
" TODO: handle dark and light colors, 256 and 16 colors
"
" For xterm256 colors refer:
" https://vimhelp.org/syntax.txt.html#cterm-colors

hi clear CursorLine
hi clear SpellBad
hi clear SpellCap
hi clear StatusLine
hi clear StatusLineNC

hi CursorColumn ctermfg=White       ctermbg=Blue
hi CursorLine   ctermfg=White       ctermbg=Blue
hi DiffAdd      ctermfg=White       ctermbg=Black
hi DiffChange   ctermfg=White       ctermbg=DarkGrey
hi DiffDelete   ctermfg=White       ctermbg=DarkRed
hi DiffText     ctermfg=White       ctermbg=DarkGreen
hi MatchParen   ctermfg=Cyan        ctermbg=Black
hi Normal       ctermfg=Grey
hi StatusLine   ctermfg=Green       ctermbg=None
hi StatusLineNC ctermfg=Grey        ctermbg=None
hi Search       ctermfg=Yellow      ctermbg=DarkBlue
hi Visual       ctermfg=White       ctermbg=DarkBlue

hi ColorColumn  cterm=bold      ctermfg=White     ctermbg=Magenta
hi CursorLineNr cterm=bold      ctermfg=DarkGreen ctermbg=DarkGrey
hi SpellBad     cterm=underline ctermfg=DarkGrey
hi SpellCap     cterm=underline ctermfg=Red

" --- Custom functions and commands ------------------------------------------
"  TODO: Trim trailing whitespaces and format text:
"  o) on edited lines only.
"  o) on list of lines only.
"  o) on `git diff -U0` lines.
"  o) with option to highlight and confirmation.
"  o) automatically before buffer write.
function! TrimTrailingWhitespace() range
	let l:cmd="keepjumps keeppatterns "
	let l:pat="s/\\s\\+$//e"
	if exists('a:firstline')
		exe l:cmd.a:firstline.",".a:lastline.l:pat
	else
		exe l:cmd.l:pat
	endif
	call winrestview(b:winview)
endfunction

function! TrimLeadingWhitespace() range
	let l:cmd="keepjumps keeppatterns "
	let l:pat="s/^\\s\\+//e"
	if exists('a:firstline')
		exe l:cmd.a:firstline.",".a:lastline.l:pat
	else
		exe l:cmd.l:pat
	endif
	call winrestview(b:winview)
endfunction

function! ToggleSyntax()
	if exists("g:syntax_on")
		syntax off
	else
		syntax enable
	endif
endfunction

function! ToggleMarkdownFolding()
	if g:vim_markdown_folding_disabled
		let g:vim_markdown_folding_disabled=0
		setlocal foldlevel=0
	else
		let g:vim_markdown_folding_disabled=1
		setlocal foldlevel=99
	endif
endfunction

function! ToggleHighlightLongLines()
	if exists('w:long_line_match')
		silent! call matchdelete(w:long_line_match)
		unlet w:long_line_match
	elseif &textwidth > 0
		let w:long_line_match =
			\ matchadd('ColorColumn', '\%>'.&textwidth.'v.\+', -1)
	else
		let w:long_line_match =
			\ matchadd('ColorColumn', '\%>79v.\+', -1)
	endif
endfunction

function! DiffOrig()
	exe "vert new ".expand('%').".orig~"
	r #
	1d_
	exe "setlocal bt=nofile bh=wipe nobl noswf ro ft=".&ft
	diffthis
	wincmd p
	diffthis
endfunction

function! DiffGit()
	let l:fp=expand('%')
	exe "vert new ".l:fp.".git~"
	exe "read !git diff ".fnameescape(l:fp)." | patch -p1 -Rs -o -"
	1d_
	exe "setlocal bt=nofile bh=wipe nobl noswf ro ft=".&ft
	diffthis
	wincmd p
	diffthis
endfunction

function! HighlightGroup()
	let l:syn_id=synID(line('.'), col('.'), 1)
	echo synIDattr(l:syn_id, 'name').' -> '.
		\ synIDattr(synIDtrans(l:syn_id), 'name')
endfunction

" Commands to use custom functions
command! -range=% TrimTrailingWhitespace
	\ let b:winview=winsaveview() |
	\ <line1>,<line2>call TrimTrailingWhitespace()

command! -range=% TrimLeadingWhitespace
	\ let b:winview=winsaveview() |
	\ <line1>,<line2>call TrimLeadingWhitespace()

command! -nargs=0 ToggleSyntax call ToggleSyntax()
command! -nargs=0 ToggleMarkdownFolding call ToggleMarkdownFolding()
command! -nargs=0 ToggleHighlightLongLines call ToggleHighlightLongLines()
command! -nargs=0 DiffOrig call DiffOrig()
command! -nargs=0 DiffGit call DiffGit()
command! -nargs=0 HighlightGroup call HighlightGroup()

" TODO: Add function, command and keymap to format text into table.
" TODO: Add function, command and keymap to search only in visual selections.
" TODO: Add custom function to format code using 'formatexpr=mylang#Format()'
" TODO: Add abbreviations to reduce typing.

" --- Auto commands ----------------------------------------------------------
" Auto commands common to all files
augroup mk_cmn
	autocmd!
	" jump to the last position when reopening a file
	autocmd BufReadPost *
		\   if line("'\"") >= 1 && line("'\"") <= line("$")
		\     && &ft !~# 'commit'
		\ |     exe "normal! g`\""
		\ | endif

	" Default options for any file type
	autocmd FileType *
		\   let g:statusline_wordcount_disabled=1
		\ | let g:vim_markdown_folding_disabled=1
		\ | setlocal nospell foldlevel=99
		\ | nnoremap <Leader>f <Nop>
augroup end

augroup mk_c
	autocmd!
	autocmd FileType c,cpp
		\ setlocal spell textwidth=78
augroup end

augroup mk_sh
	autocmd!
	autocmd FileType sh,zsh,bash,vim,lua
		\ setlocal spell textwidth=78
augroup end

augroup mk_py
	autocmd!
	autocmd FileType python
		\ setlocal spell textwidth=78 tabstop=4 softtabstop=4
		\ shiftwidth=4 expandtab
augroup end

augroup mk_git
	autocmd!
	autocmd FileType gitcommit,gitrebase
		\ setlocal spell
augroup end

augroup mk_md
	autocmd!
	autocmd FileType markdown
		\   let g:statusline_wordcount_disabled=0
		\ | setlocal spell textwidth=78 foldlevel=99 keywordprg=dictls
		\ | nnoremap <Leader>f :ToggleMarkdownFolding<cr>
augroup end

augroup mk_html
	autocmd!
	autocmd FileType html,jinja.html,css,scss,toml,yml
		\ setlocal spell textwidth=0 tabstop=2 softtabstop=2
		\ shiftwidth=2 expandtab
augroup end

" --- vim-plug section vim plugin manager ------------------------------------
" https://github.com/junegunn/vim-plug

" -- vim plugin options before loading -----------
" Use latest snipMate parser for new features.
let g:snipMate={ 'snippet_version' : 1 }

" 'vim-markdown' plugin settings
let g:vim_markdown_toml_frontmatter=1
let g:vim_markdown_new_list_item_indent=2

" Use '-' as easymotion prefix
map -                        <Plug>(easymotion-prefix)

" Specify a directory for plugins
" - Avoid using standard Vim directory names like 'plugin'
silent! if plug#begin(stdpath('data').'/plugged')
" List all plugins here
" Shorthand notation, fetches https://github.com/{user}/{repo}

" * UI/UX plugins
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'
Plug 'jlanzarotta/bufexplorer'
Plug 'simeji/winresizer'
Plug 'tpope/vim-unimpaired'
Plug 'tpope/vim-repeat'
Plug 'easymotion/vim-easymotion'
Plug 'junegunn/vim-peekaboo'
Plug 'preservim/nerdtree'
Plug 'milkypostman/vim-togglelist'
Plug 'manid2/vim-ypclipboard', {'branch': 'dev'}
Plug 'manid2/vim-grep-replace', {'branch': 'dev'}

" * Code editing plugins generic
Plug 'preservim/tagbar'
Plug 'tpope/vim-fugitive'
"Plug 'aperezdc/vim-template' " NOTE: enable when custom templates are created
" -- garbas/vim-snipmate dependencies begin ------
Plug 'MarcWeber/vim-addon-mw-utils'
Plug 'tomtom/tlib_vim'
Plug 'honza/vim-snippets'
" -- garbas/vim-snipmate dependencies end --------
Plug 'garbas/vim-snipmate'
Plug 'vim-scripts/DoxygenToolkit.vim'
Plug 'bergercookie/vim-deb-preview'
Plug 'preservim/nerdcommenter'
Plug 'preservim/vim-markdown'
Plug 'chrisbra/matchit'

" * Text editing plugins
Plug 'tpope/vim-surround'
Plug 'junegunn/vim-easy-align'
Plug 'google/vim-searchindex'

" * Syntax highlighters
Plug 'ekalinin/Dockerfile.vim'
Plug 'nathanalderson/yang.vim'
Plug 'Glench/Vim-Jinja2-Syntax'

" List ends here. Plugins become visible to Vim after this call.
call plug#end()
endif

" --- statusline section -----------------------------------------------------
" TODO: Move statusline section into a plugin
"   refer: https://stackoverflow.com/a/17184285
" TODO: Use autoload functions instead of function name prefix.

" Define global variables

" NOTE: Execute system commands at the start to avoid errors in vim and slows
" down vim as it evaluates status line expression continuously.
let s:git_str_cmd="$SHELL -c ".shellescape(
	\"source ~/.local/bin/git-sh-prompt; ".
	\"GIT_PS1_SHOWDIRTYSTATE='y' ".
	\"GIT_PS1_SHOWSTASHSTATE='y' ".
	\"GIT_PS1_SHOWUNTRACKEDFILES='y' ".
	\"GIT_PS1_DESCRIBE_STYLE='contains' ".
	\"GIT_PS1_SHOWUPSTREAM='auto' ".
	\"__git_ps1")
let g:vim_git_branch=trim(system(s:git_str_cmd))

" Disable word count on status line on start as it slows down vim.
let g:statusline_wordcount_disabled=1

" statusline helper functions
function! SiSlSecModeFlags()
	let l:md=mode(0)
	let l:ro=&readonly ? 'R' : ''
	let l:mo=!&modifiable ? 'M' : ''
	let l:mf=&modified ? '+' : ''
	let l:bfn=len(getbufinfo({'buflisted':1}))
	let l:bfn=l:bfn > 1 ? '/'.string(l:bfn) : ''
	return "%0.10(".l:md.l:ro.l:mo.l:mf." %n".l:bfn."%)"
endfunction

function! SiSlSecFileType()
	" TODO: truncate right when exceeding max chars.
	return "%0.10(".&filetype."%)"
endfunction

function! SiSlSecGitStr()
	return "%0.24(".g:vim_git_branch."%)"
endfunction

function! SiSlSecCurrentTag()
	let l:ct=''
	if exists(':TagbarCurrentTag')
		let l:ct="%0.24(".tagbar#currenttag('%s', '')."%)"
	endif
	return l:ct
endfunction

function! SiSlSecWordCount()
	let l:wc=''
	if g:statusline_wordcount_disabled
		return l:wc
	endif
	if has_key(wordcount(),'visual_words')
		let l:wc=wordcount().visual_words."/".wordcount().words
	else
		let l:wc=wordcount().cursor_words."/".wordcount().words
	endif
	return "%0.9(".l:wc."%)"
endfunction

function! SiSlSecRelFileInfo()
	return "%0.50(%f:%l:%c%V|%L|%p%%%)"
endfunction

function! StatuslineExpr()
	let l:sp=' '
	let l:secsp="%="
	let l:func_refs = [
		\ SiSlSecModeFlags(),
		\ SiSlSecFileType(),
		\ SiSlSecGitStr(),
		\ SiSlSecCurrentTag(),
		\ l:secsp,
		\ SiSlSecWordCount(),
		\ SiSlSecRelFileInfo()
		\ ]
	return join(l:func_refs, l:sp)
endfunction

set laststatus=2     " Always show statusline
set statusline=%{%StatuslineExpr()%}

" Custom status line functions.
function! ToggleStatuslineWordcount()
	if g:statusline_wordcount_disabled
		let g:statusline_wordcount_disabled=0
	else
		let g:statusline_wordcount_disabled=1
	endif
endfunction

" TODO: Add toggle function for status line sections to view them as needed.

" Custom status line commands.
command! -nargs=0 ToggleStatuslineWordcount call ToggleStatuslineWordcount()

" Custom status line keymaps.
nnoremap <silent> <Leader>wc :ToggleStatuslineWordcount<cr>

" --- keymaps section --------------------------------------------------------
" Common variables
let s:cword='<C-R>=expand("<cword>")<cr>'
let s:cfp='<C-R>=expand("%")<cr>'
let s:cfn='<C-R>=expand("%:t")<cr>'

" Save file in normal and also in insert mode
inoremap <C-S>               <ESC>:update<cr>
nnoremap <C-S>               :update<cr>
" Alternative to <C-S> when terminal stops updating
inoremap <C-A>s              <ESC>:update<cr>
nnoremap <C-A>s              :update<cr>

" Quit
inoremap <C-Q>               <ESC>:q<cr>
nnoremap <C-Q>               :q<cr>
nnoremap <C-Q>f              :q!<cr>
nnoremap <C-Q>fa             :qall!<cr>
nnoremap <C-Q>o              :only<cr>

" Movement
" window movements
nnoremap <C-J>               <C-w>w
nnoremap <C-K>               <C-w>W

" text movements
nnoremap 0                   ^
nnoremap 9                   $
nnoremap <Leader>0           0

" Indent and format file
nnoremap <C-A>i              gg=G``
nnoremap <C-A>q              gggqG``

" Highlight current word without jumping
exe 'nnoremap <Leader>h :let @/=''\<'.s:cword.'\>''<cr>:set hlsearch<cr>'

" Highlight group of cursor
nnoremap <Leader>hig :HighlightGroup<cr>

" Vim to new shell, after done exit or use ctrl+d to bring back vim
nnoremap <Leader>sh          :shell<cr>
" <C-Z> to get same shell as vim was started
" execute 'fg' command to bring vim back

" Custom functions keymaps
nnoremap <silent> <Leader>tt :TrimTrailingWhitespace<cr>
nnoremap <silent> <Leader>tl :TrimLeadingWhitespace<cr>
xnoremap <silent> <Leader>tt :TrimTrailingWhitespace<cr>
xnoremap <silent> <Leader>tl :TrimLeadingWhitespace<cr>
nnoremap <Leader>syn         :ToggleSyntax<cr>
nnoremap <Leader>hll         :ToggleHighlightLongLines<cr>
nnoremap <Leader>do          :DiffOrig<cr>
nnoremap <Leader>dg          :DiffGit<cr>

" TODO: Add insert mode keymap to toggle 'paste'
" TODO: Use generic heading using function and filetype
" Markdown headings
nnoremap <Leader>1           m`yypVr=``
nnoremap <Leader>2           m`yypVr-``
nnoremap <Leader>3           m`^i### <esc>``4l
nnoremap <Leader>4           m`^i#### <esc>``5l
nnoremap <Leader>5           m`^i##### <esc>``6l

" vim plugins keymaps
nnoremap <Leader>nt          :NERDTreeToggle<cr>
nnoremap <Leader>tb          :TagbarToggle<cr>
nnoremap <Leader>tc          :TagbarCurrentTag<cr>
nnoremap <Leader>ty          :call WClipboard(tagbar#currenttag('%s',''))<cr>

" vim-fugitive keymaps
nnoremap <Leader>gb          :Git blame<cr>
nnoremap <Leader>gl          :Git log<cr>
nnoremap <Leader>gd          :Git diff<cr>
nnoremap <Leader>gs          :Git<cr>

" fzf.vim keymaps
nnoremap fzf                 :Files<cr>
nnoremap fgf                 :GFiles<cr>
nnoremap fbf                 :Buffers<cr>
nnoremap frg                 :Rg<cr>
nnoremap flf                 :Lines<cr>
nnoremap fbl                 :BLines<cr>
nnoremap fft                 :Tags<cr>
nnoremap ffb                 :BTags<cr>
nnoremap ffm                 :Marks<cr>
nnoremap ffw                 :Windows<cr>
nnoremap fsf                 :History/<cr>
nnoremap fgc                 :Commits<cr>
nnoremap fbc                 :BCommits<cr>
nnoremap fcf                 :Commands<cr>
nnoremap fmf                 :Maps<cr>

" TODO: WIP implement fzf spell suggestions
"function! FzfSpellSink(word)
	"exe 'normal! "_ciw'.a:word
"endfunction

"function! FzfSpellSource(word)
	"return spellsuggest(a:word)
"endfunction

command! -bang -nargs=* GGrep
	\ call fzf#vim#grep(
	\   'git grep --line-number -- '.shellescape(<q-args>),
	\   0,
	\   fzf#vim#with_preview({
	\     'dir': systemlist('git rev-parse --show-toplevel')[0]}),
	\   <bang>0)

" Grep word under cursor with git grep useful when no tags.
exe 'nnoremap fgg :GGrep '.s:cword.'<cr>'

" Copy file path/name into clipboard
exe 'nnoremap <silent> <Leader>fp :WClipboard '.s:cfp.'<cr>'
exe 'nnoremap <silent> <Leader>fn :WClipboard '.s:cfn.'<cr>'

" Source local vimrc
nnoremap <Leader>lv          :source ./local-vimrc.vim <bar> edit<cr>
