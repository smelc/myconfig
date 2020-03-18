call plug#begin(stdpath('data') . '/plugged')

Plug 'ndmitchell/ghcid', { 'rtp': 'plugins/nvim' }
Plug 'fcpg/vim-farout' " farout theme as visible in http://marco-lopes.com/articles/Vim-and-Haskell-in-2019/
Plug 'dracula/vim', { 'as': 'dracula' } " dracula theme
Plug 'neoclide/coc.nvim', {'branch': 'release'} " https://github.com/neoclide/coc.nvim
Plug 'tpope/vim-fugitive' " https://github.com/tpope/vim-fugitive
Plug 'airblade/vim-gitgutter' " https://github.com/airblade/vim-gitgutter

call plug#end()

nmap <S-l> :tabn<CR>
nmap <S-h> :tabp<CR>
nmap ]h <Plug>(GitGutterNextHunk)
nmap [h <Plug>(GitGutterPrevHunk)

" Always display line numbers
set number
" Show column number in status bar
set statusline+=col:\ %c

" Insert spaces instead of tabs
set expandtab

:set colorcolumn=80
colorscheme dracula " farout

runtime coc_config_nvim.vim
