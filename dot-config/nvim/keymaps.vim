" --- nvim keymaps -----------------------------------------------------------
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

" Vim to new shell, after done exit or use ctrl+d to bring back vim
nnoremap <Leader>sh          :shell<cr>
" <C-Z> to get same shell as vim was started
" execute 'fg' command to bring vim back

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

" Copy file path/name into clipboard
exe 'nnoremap <silent> <Leader>fp :WClipboard '.s:cfp.'<cr>'
exe 'nnoremap <silent> <Leader>fn :WClipboard '.s:cfn.'<cr>'

" Source local vimrc
nnoremap <Leader>lv          :source ./local-vimrc.vim <bar> edit<cr>
