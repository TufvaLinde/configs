" Ctrl-t toggles a terminal at the bottom of the screen (same terminal every time).
" Inside it: Esc goes to normal mode (scroll/copy), i to type again.
let g:term_buf = 0
let g:term_win = 0
function! TermToggle(height)
    if win_gotoid(g:term_win)
        hide
    else
        botright new
        exec "resize " . a:height
        try
            exec "buffer " . g:term_buf
        catch
            call jobstart($SHELL, {"term": v:true})
            let g:term_buf = bufnr("")
            setlocal nonumber norelativenumber signcolumn=no
        endtry
        startinsert!
        let g:term_win = win_getid()
    endif
endfunction

nnoremap <C-t> <Cmd>call TermToggle(12)<CR>
inoremap <C-t> <Esc><Cmd>call TermToggle(12)<CR>
tnoremap <C-t> <C-\><C-n><Cmd>call TermToggle(12)<CR>
tnoremap <Esc> <C-\><C-n>
