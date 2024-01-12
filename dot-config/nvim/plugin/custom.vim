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
