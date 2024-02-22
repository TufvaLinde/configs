call plug#begin('~/.local/share/nvim/plugged')

" Add your plugins here, for example:
Plug 'lervag/vimtex'

call plug#end()

let g:UltiSnipsExpandTrigger       = '<Tab>'    " use Tab to expand snippets
let g:UltiSnipsJumpForwardTrigger  = '<Tab>'    " use Tab to move forward through tabstops
let g:UltiSnipsJumpBackwardTrigger = '<S-Tab>'  " use Shift-Tab to move backward through tabstops

let g:UltiSnipsSnippetDirectories=[$HOME.'/.config/nvim/UltiSnips']
