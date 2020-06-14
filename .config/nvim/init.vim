let g:python3_host_prog = '/home/bpaterni/.pyenv/versions/py3nvim/bin/python'
let g:node_host_prog = '/usr/local/bin/neovim-node-host'

call plug#begin(stdpath('data') . '/plugged')
Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'morhetz/gruvbox'
call plug#end()

colorscheme gruvbox

set tabstop=2
set shiftwidth=2
set expandtab
set termguicolors

" Better display for messages
set cmdheight

" Relative line numbers
set relativenumber

" Don't give |ins-completion-menu| messsages
set shortmess+=c

" Always show signcolumns
set signcolumn=yes

" You will have bad experience for diagnostice messages when it's default
" 4000.
set updatetime=300

" Use tab to trigger completion with characters ahead and navigate.
" Use command ":verbose imap <tab>' to make sure tab is not mapped by other
" plugins
inoremap <silent><expr> <TAB>
  \ pumvisible() ? "\<C-n>" :
  \ <SID>check_back_space() ? "\<TAB>" :
  \ coc#refresh()
inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"

function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1] =~# '\s'
endfunction

" Use <c-space> to trigger completion
inoremap <silent><expr> <c-space> coc#refresh()

" Use <cr> to confirm completion. '<C-g>u' means break undo chain at current
" position.
inoremap <expr> <cr> complete_info()["selected"] != "-1" ? "\<C-y>" : "\<C-g>u\<CR>"

" Use '[g' and ']g' to navigate diagnostics
nmap <silent> [g <Plug>(coc-diagnostic-prev)
nmap <silent> ]g <Plug>(coc-diagnostic-next)

nmap <silent> gd <Plug>(cod-definition)
nmap <silent> gv <Plug>(cod-type-definition)
nmap <silent> gi <Plug>(cod-implementation)
nmap <silent> gr <Plug>(cod-references)

"set statusline^=%{coc#status()}
