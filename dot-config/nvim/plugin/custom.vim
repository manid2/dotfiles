" --- nvim custom commands ---------------------------------------------------
command! -range=% TrimTrailingWhitespace
	\ let b:winview=winsaveview() |
	\ <line1>,<line2>call custom#functions#trim_trail_ws()

command! -range=% TrimLeadingWhitespace
	\ let b:winview=winsaveview() |
	\ <line1>,<line2>call custom#functions#trim_lead_ws()

command! -nargs=0 ToggleSyntax call custom#functions#toggle_syn()
command! -nargs=0 ToggleMarkdownFolding call custom#functions#toggle_md_fold()
command! -nargs=0 ToggleHighlightLongLines
	\ call custom#functions#toggle_hi_long_lines()
command! -nargs=0 DiffOrig call custom#functions#diff_orig()
command! -nargs=0 DiffGit call custom#functions#diff_git()
command! -nargs=0 HighlightGroup call custom#functions#hi_grp()

command! -nargs=0 GitGrep
	\ call custom#functions#fzf_git_grep(expand("<cword>"))
command! -nargs=* GitGrepPattern
	\ call custom#functions#fzf_git_grep(<q-args>)

command! -nargs=? Spell
	\ call custom#functions#fzf_spell_suggest(<q-args>)
command! -nargs=? Dict
	\ call custom#functions#fzf_dict(<q-args>)

command! -nargs=0 Date
	\ echo custom#functions#date()
command! -nargs=0 DateAppend
	\ call custom#functions#date_append()

for level in range(1, 5)
	exe "command! -nargs=0 AddHeadingMd".level.
		\ " call custom#functions#add_heading_md(".level.")"
	exe "command! -nargs=0 AddHeadingRst".level.
		\ " call custom#functions#add_heading_rst(".level.")"
endfor

command! -nargs=0 Update
	\ call custom#functions#update()

" keymaps
nnoremap <silent> <Leader>tt :TrimTrailingWhitespace<cr>
nnoremap <silent> <Leader>tl :TrimLeadingWhitespace<cr>
xnoremap <silent> <Leader>tt :TrimTrailingWhitespace<cr>
xnoremap <silent> <Leader>tl :TrimLeadingWhitespace<cr>
nnoremap <Leader>syn         :ToggleSyntax<cr>
nnoremap <Leader>hll         :ToggleHighlightLongLines<cr>
nnoremap <Leader>do          :DiffOrig<cr>
nnoremap <Leader>dg          :DiffGit<cr>
nnoremap <Leader>hig         :HighlightGroup<cr>
nnoremap <Leader>fgg         :GitGrep<cr>
nnoremap <Leader>fgp         :GitGrepPattern<space>
nnoremap <Leader>z=          :Spell <C-r>=expand("<cword>")<cr><cr>
nnoremap <Leader>zw          :Spell<space>
nnoremap <Leader>dc          :Dict <C-r>=expand("<cword>")<cr><cr>
nnoremap <Leader>dw          :Dict<space>
nnoremap <Leader>dt          :DateAppend<cr>
inoremap <C-\>dt             <C-O>:DateAppend<cr>
iabbrev <expr> dtz           custom#functions#date()
