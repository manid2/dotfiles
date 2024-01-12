" --- nvim colors-- ----------------------------------------------------------
" Override colors for some highlight groups
"
" For xterm256 colors refer:
" https://vimhelp.org/syntax.txt.html#cterm-colors

hi clear CursorLine
hi clear SpellBad
hi clear SpellCap
hi clear StatusLine
hi clear StatusLineNC

hi CursorColumn ctermfg=White  ctermbg=Blue
hi CursorLine   ctermfg=White  ctermbg=Blue
hi DiffAdd      ctermfg=White  ctermbg=Black
hi DiffChange   ctermfg=White  ctermbg=DarkGrey
hi DiffDelete   ctermfg=White  ctermbg=DarkRed
hi DiffText     ctermfg=White  ctermbg=DarkGreen
hi MatchParen   ctermfg=Cyan   ctermbg=DarkGrey
hi Normal       ctermfg=Grey
hi NormalFloat                 ctermbg=None
hi FloatBorder  ctermfg=None   ctermbg=None
hi StatusLine   ctermfg=Green  ctermbg=None
hi StatusLineNC ctermfg=Grey   ctermbg=None
hi Search       ctermfg=Yellow ctermbg=DarkBlue
hi Visual       ctermfg=White  ctermbg=DarkBlue
hi SignColumn                  ctermbg=None

hi ColorColumn  cterm=bold      ctermfg=White     ctermbg=Magenta
hi CursorLineNr cterm=bold      ctermfg=DarkGreen ctermbg=DarkGrey
hi SpellBad     cterm=underline ctermfg=DarkGrey
hi SpellCap     cterm=underline ctermfg=Red
