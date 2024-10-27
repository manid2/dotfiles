" -- vim cscope
if exists("loaded_cscope")
	finish
endif

function! s:Message(msg)
	echohl WarningMsg
	echomsg 'cscope: ' . a:msg
	echohl None
endfunction

let s:vim = 'vim'
if has('nvim')
	let s:vim = 'nvim'
endif

if !has("cscope")
	call s:Message("This ".s:vim." version has no support for cscope")
	finish
endif

let s:cscope_cmd = 'cscope'
let s:cscope_db = 'cscope.out'

" Use gtags if available with gtags-cscope plugin
if executable('gtags-cscope')
	let s:cscope_cmd = 'gtags-cscope'
	let s:cscope_db = 'GTAGS'
elseif !executable('cscope')
	call s:Message("System doesn't have gtags-cscope or cscope")
	let loaded_cscope = 1
	finish
endif

" set cscope program
exe 'set csprg='.s:cscope_cmd
" use both cscope and ctag for 'ctrl-]', ':ta', and 'vim -t'
set cscopetag
" check symbol in ctags first and then cscope
set csto=0

" don't show any error msg before adding cscope db
set nocscopeverbose

" add cscope db from default file or from CSCOPE_DB environment variable.
if filereadable(s:cscope_db)
	exe 'cs add '.s:cscope_db
elseif $CSCOPE_DB != ""
	exe 'cs add '.$CSCOPE_DB
endif

" show msg when any other cscope db added
set cscopeverbose

" cscope find command

" set csope quickfix options to show cscope results in quickfix &
" location list windows
let s:csfindopts = ['s', 'g', 'd', 'c', 't', 'e', 'f', 'i']
if has("quickfix")
	if (v:version > 800)
		let s:csfindopts += ['a']
	endif
	exe 'set cscopequickfix=' . join(s:csfindopts, '-,') . '-'
endif

" cscope keymaps
for s:csfcmd in ['cs', 'scs', 'vert scs', 'lcs']
	let s:csfcmdkey='\'
	if s:csfcmd == 'scs'
		let s:csfcmdkey = ']'
	elseif s:csfcmd == 'vert scs'
		let s:csfcmdkey = "'"
	elseif s:csfcmd == 'lcs'
		let s:csfcmdkey = 'l'
	endif

	for s:csfopt in s:csfindopts
		let s:csfkeymap='nnoremap <Leader>'
		let s:csfkeymap .= s:csfcmdkey.s:csfopt.' :'.s:csfcmd.' find '
			\.s:csfopt

		if s:csfopt == 'f'
			let s:csfkeymap .= ' <C-R>=expand("<cfile>")<CR><CR>'
		elseif s:csfopt == 'i'
			let s:csfkeymap .= ' <C-R>=expand("<cfile>")<CR>$<CR>'
		else
			let s:csfkeymap .= ' <C-R>=expand("<cword>")<CR><CR>'
		endif

		exe s:csfkeymap

		let s:csfkeymap2='nnoremap <C-\>'
		let s:csfkeymap2.=s:csfcmdkey.s:csfopt.' :'.s:csfcmd.' find '
			\.s:csfopt.' '
		exe s:csfkeymap2
	endfor
endfor

let loaded_cscope = 1
