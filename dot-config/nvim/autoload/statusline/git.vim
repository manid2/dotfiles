let s:cache = ''
let s:timer = v:null
let s:script = expand('~/.local/lib/git-sh-prompt')

function! s:fetch(is_manual) abort
    if !filereadable(s:script)
        return a:is_manual ? s:out('Error: script not found', 'ErrorMsg') : 0
    endif

    let l:cmd = printf(
        \ 'unset GIT_PS1_SHOWCOLORHINTS && source %s && ' .
        \ 'p=$(__git_ps1 "%%s") && ' .
        \ 's=$(git rev-parse --short=7 HEAD 2>/dev/null) && ' .
        \ 'echo "$p $s"', s:script)

    call job_start(['bash', '-c', l:cmd], {
        \ 'out_cb': {c, m -> s:handle_output(m, a:is_manual)},
        \ 'err_cb': {c, m -> a:is_manual ? s:out(m, 'ErrorMsg') : 0}
        \ })
endfunction

function! s:handle_output(msg, is_manual) abort
    let l:res = trim(a:msg)
    " Ensure we don't store a single space if both commands returned empty
    let s:cache = (l:res ==# '' || l:res ==# ' ') ? '' : l:res

    if a:is_manual
        redraw | call s:out(empty(s:cache) ? 'Not in a git repo' : s:cache, 'Title')
    endif
    redrawstatus
endfunction

function! s:out(m, hl)
    execute 'echohl ' . a:hl | echo 'Git PS1: ' . a:m | echohl None
endfunction

function! statusline#git#start_updates() abort
    if s:timer == v:null
        let s:timer = timer_start(2000, {-> s:fetch(0)}, {'repeat': -1})
        call s:fetch(0)
    endif
endfunction

function! statusline#git#stop_updates() abort
    if s:timer != v:null | call timer_stop(s:timer) | let s:timer = v:null | endif
endfunction

function! statusline#git#ps1(...) abort
    if a:0 > 0 && a:1
        call s:fetch(1)
        return ''
    endif
    return s:cache
endfunction