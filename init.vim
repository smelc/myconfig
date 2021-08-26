call plug#begin(stdpath('data') . '/plugged')

" Color themes
Plug 'fcpg/vim-farout' " farout theme as visible in http://marco-lopes.com/articles/Vim-and-Haskell-in-2019/
Plug 'dracula/vim', { 'as': 'dracula' } " dracula theme
" Plug 'tomasr/molokai' " molokai
" Plug 'changyuheng/color-scheme-holokai-for-vim' " holokai
Plug 'joshdick/onedark.vim' " onedark

Plug 'ndmitchell/ghcid', { 'rtp': 'plugins/nvim' }
Plug 'neoclide/coc.nvim', {'branch': 'v0.0.80' }
" Plug 'dense-analysis/ale'  " for shellcheck integration
Plug 'tpope/vim-fugitive' " https://github.com/tpope/vim-fugitive
Plug 'airblade/vim-gitgutter' " https://github.com/airblade/vim-gitgutter
Plug 'vim-airline/vim-airline'
Plug 'LnL7/vim-nix' " https://github.com/LnL7/vim-nix
Plug 'sbdchd/neoformat' " :NeoFormat
Plug 'mhinz/vim-grepper'
Plug 'junegunn/fzf', {'dir': '~/.fzf', 'do': './install --all'}
Plug 'monkoose/fzf-hoogle.vim'
Plug 'tpope/vim-commentary'
Plug 'ctrlpvim/ctrlp.vim'
Plug 'majutsushi/tagbar'

call plug#end()

nmap <S-l> :tabn<CR>
nmap <S-h> :tabp<CR>

" https://github.com/vim-airline/vim-airline/issues/1845
let g:airline_section_a = ''
let g:airline_section_x = ''
let g:airline_section_y = ''
let g:airline#extensions#tabline#formatter = 'unique_tail'

" Ignore files in .gitignore at Ctrl-P, https://github.com/ctrlpvim/ctrlp.vim#basic-options
let g:ctrlp_user_command = ['.git', 'cd %s && git ls-files -co --exclude-standard']

nmap <F8> :TagbarToggle<CR>

nmap ]h <Plug>(GitGutterNextHunk)
nmap [h <Plug>(GitGutterPrevHunk)
" nnoremap <leader>hU :GitGutterUndoHunk<cr>
nmap ghs <Plug>(GitGutterStageHunk)
nmap ghu <Plug>(GitGutterUndoHunk)

" https://github.com/mhinz/vim-grepper/wiki/example-configurations-and-mappings
nnoremap <leader>g :Grepper -tool git<cr>
nnoremap <leader>G :Grepper -tool ag<cr>
nmap gs <plug>(GrepperOperator)
xmap gs <plug>(GrepperOperator)

" Always display line numbers
set number

" Insert spaces instead of tabs
set expandtab

set colorcolumn=80

" Do not write .swp files, which I've never benefited of
set noswapfile

colorscheme onedark " dracula farout

" See explanations at
" https://alldrops.info/posts/vim/2018-05-15_understand-vim-mappings-and-create-your-own-shortcuts/
nnoremap <Leader>nf :Neoformat<CR>

" Highlight trailing spaces:
highlight ExtraWhitespace ctermbg=red guibg=red
match ExtraWhitespace /\s\+$/

runtime coc_config_nvim.vim
