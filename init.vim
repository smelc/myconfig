call plug#begin(stdpath('data') . '/plugged')

Plug 'ndmitchell/ghcid', { 'rtp': 'plugins/nvim' }
Plug 'fcpg/vim-farout' " farout theme as visible in http://marco-lopes.com/articles/Vim-and-Haskell-in-2019/
Plug 'dracula/vim', { 'as': 'dracula' } " dracula theme
Plug 'neoclide/coc.nvim', {'branch': 'release'} " https://github.com/neoclide/coc.nvim
Plug 'dense-analysis/ale'
Plug 'tpope/vim-fugitive' " https://github.com/tpope/vim-fugitive
Plug 'airblade/vim-gitgutter' " https://github.com/airblade/vim-gitgutter
Plug 'vim-airline/vim-airline'
Plug 'LnL7/vim-nix' " https://github.com/LnL7/vim-nix
Plug 'sbdchd/neoformat' " :NeoFormat

call plug#end()

nmap <S-l> :tabn<CR>
nmap <S-h> :tabp<CR>
nmap ]h <Plug>(GitGutterNextHunk)
nmap [h <Plug>(GitGutterPrevHunk)

" Always display line numbers
set number
" Show column number in status bar
set statusline+=,\ col:%c

" Insert spaces instead of tabs
set expandtab

set colorcolumn=80

" Do not write .swp files, which I've never benefited of
set noswapfile

colorscheme dracula " farout

" Highlight trailing spaces:
highlight ExtraWhitespace ctermbg=red guibg=red
match ExtraWhitespace /\s\+$/

" See explanations at
" https://alldrops.info/posts/vim/2018-05-15_understand-vim-mappings-and-create-your-own-shortcuts/
nnoremap nf :Neoformat<CR>

runtime coc_config_nvim.vim
