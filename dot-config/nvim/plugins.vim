" --- vim plugins ------------------------------------------------------------
" vim-plug plugin manager
" https://github.com/junegunn/vim-plug

" -- vim plugin options before loading -----------
" Use latest snipMate parser for new features.
let g:snipMate={ 'snippet_version' : 1 }

" 'vim-markdown' plugin settings
let g:vim_markdown_toml_frontmatter=1
let g:vim_markdown_new_list_item_indent=2

" Use '-' as easymotion prefix
map -                        <Plug>(easymotion-prefix)

" Use 'ga' prefix for EasyAlign
" Start interactive EasyAlign in visual mode (e.g. vipga)
xmap ga                      <Plug>(EasyAlign)

" Start interactive EasyAlign for a motion/text object (e.g. gaip)
nmap ga                      <Plug>(EasyAlign)

" Specify a directory for plugins
" - Avoid using standard Vim directory names like 'plugin'
let s:plugged='~/.vim/plugged'
if has('nvim')
	let s:plugged=stdpath('data').'/plugged'
endif

silent! if plug#begin(s:plugged)
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
Plug 'yegappan/mru'
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
if has('cscope')
	Plug 'manid2/vim-cscope-settings', {'branch': 'dev'}
endif
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
