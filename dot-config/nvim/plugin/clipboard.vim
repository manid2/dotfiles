" -- vim registers to system clipboard
function! s:Message(msg)
	echohl WarningMsg
	echomsg 'clipboard: ' . a:msg
	echohl None
endfunction

function! s:YPGetSystemClipboard(rw)
	let l:clip_cmd = ''
	let l:clip_cmd_args = ''

	" TODO: handle cases where xclip is not available use alternatives
	" i.e. xsel, tmux, gnu screen
	if executable('xclip')
		let l:clip_cmd = 'xclip'
		let l:clip_cmd_args = ' -selection clipboard'
		if a:rw == 'w'
			let l:clip_cmd_args .= ' -i'
		elseif a:rw == 'r'
			let l:clip_cmd_args .= ' -o'
		endif
	else
		call s:Message('No suitable clipboard command is found in '.
			\ 'the system install one of xclip, xsel, tmux.')
	endif

	return l:clip_cmd.l:clip_cmd_args
endfunction

function! WClipboard(text)
	let l:clip_cmd = s:YPGetSystemClipboard('w')

	if empty(l:clip_cmd)
		return
	endif

	call system(l:clip_cmd, a:text)
endfunction

function! RClipboard(reg)
	let l:clip_cmd = s:YPGetSystemClipboard('r')

	if empty(l:clip_cmd)
		return
	endif

	let l:clipboard_content = system(l:clip_cmd)
	call setreg(a:reg, l:clipboard_content)
	exe 'normal! "'.a:reg.'p'
endfunction

command! -nargs=1 WClipboard           call WClipboard(<q-args>)
command! -nargs=1 RClipboard           call RClipboard(<args>)

nnoremap <silent> <Leader>y            :WClipboard <C-R>=getreg('"')<cr><cr>
nnoremap <silent> <Leader>p            :RClipboard '"'<cr>
inoremap <silent> <C-\>p               <C-O>:RClipboard '"'<cr>
