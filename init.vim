call plug#begin(stdpath('data') . '/plugged')

" Color themes
Plug 'fcpg/vim-farout' " farout theme as visible in http://marco-lopes.com/articles/Vim-and-Haskell-in-2019/
Plug 'dracula/vim', { 'as': 'dracula' } " dracula theme
" Plug 'tomasr/molokai' " molokai
" Plug 'changyuheng/color-scheme-holokai-for-vim' " holokai
Plug 'joshdick/onedark.vim' " onedark

Plug 'ndmitchell/ghcid', { 'rtp': 'plugins/nvim' }
Plug 'neoclide/coc.nvim', {'branch': 'release'}
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
Plug 'kien/ctrlp.vim'
Plug 'majutsushi/tagbar'

" for OCaml, following https://www.rockyourcode.com/setup-ocaml-with-neovim/
" Plug 'autozimu/LanguageClient-neovim', { 'branch': 'next', 'do': 'bash install.sh', } " https://github.com/autozimu/LanguageClient-neovim
" Plug 'ajh17/VimCompletesMe'

call plug#end()

nmap <S-l> :tabn<CR>
nmap <S-h> :tabp<CR>

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
" Show column number in status bar
set statusline+=,\ col:%c

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

" https://www.rockyourcode.com/setup-ocaml-with-neovim/
" set hidden
" let g:LanguageClient_serverCommands = { 'ocaml': ['ocamllsp'], }
" nnoremap <F5> :call LanguageClient_contextMenu()<CR>
" Or map each action separately
" nnoremap <silent> K :call LanguageClient#textDocument_hover()<CR>
" nnoremap <silent> gd :call LanguageClient#textDocument_definition()<CR>
" nnoremap <silent> <F2> :call LanguageClient#textDocument_rename()<CR>
" /https://www.rockyourcode.com/setup-ocaml-with-neovim/

runtime coc_config_nvim.vim
