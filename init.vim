call plug#begin(stdpath('data') . '/plugged')

Plug 'ndmitchell/ghcid', { 'rtp': 'plugins/nvim' }
Plug 'fcpg/vim-farout' " farout theme as visible in http://marco-lopes.com/articles/Vim-and-Haskell-in-2019/
Plug 'dracula/vim', { 'as': 'dracula' } " dracule theme

call plug#end()

nmap <S-l> :tabn<CR>
nmap <S-h> :tabp<CR>

" Always display line numbers
set number

" Insert spaces instead of tabs
set expandtab

:set colorcolumn=80
colorscheme dracula " farout
