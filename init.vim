call plug#begin(stdpath('data') . '/plugged')

" Color themes
Plug 'fcpg/vim-farout' " farout theme as visible in http://marco-lopes.com/articles/Vim-and-Haskell-in-2019/
Plug 'dracula/vim', { 'as': 'dracula' } " dracula theme
Plug 'joshdick/onedark.vim' " onedark

Plug 'neoclide/coc.nvim', {'branch': 'release' }  " :CocInstall coc-jedi for basic python lsp, or coc-pyright
Plug 'tpope/vim-fugitive' " https://github.com/tpope/vim-fugitive
Plug 'airblade/vim-gitgutter' " https://github.com/airblade/vim-gitgutter
Plug 'vim-airline/vim-airline'
Plug 'LnL7/vim-nix' " https://github.com/LnL7/vim-nix
Plug 'sbdchd/neoformat' " :NeoFormat
Plug 'mhinz/vim-grepper'
Plug 'tpope/vim-commentary'
Plug 'ctrlpvim/ctrlp.vim' " Ctrl-p

" Workspace search
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'
Plug 'antoinemadec/coc-fzf' " use FZF for interacting with CoC. Needs bat:
" https://github.com/sharkdp/bat for colorful previews

Plug 'nvim-lua/plenary.nvim'
Plug 'nvim-telescope/telescope.nvim'
Plug 'nvim-telescope/telescope-fzf-native.nvim'
Plug 'nvim-treesitter/nvim-treesitter'

call plug#end()

nmap <S-l> :tabn<CR>
nmap <S-h> :tabp<CR>

" https://github.com/vim-airline/vim-airline/issues/1845
let g:airline_section_a = ''
let g:airline_section_b = ''
let g:airline_section_x = ''
let g:airline_section_y = ''
let g:airline#extensions#tabline#formatter = 'unique_tail'

" Ignore files in .gitignore at Ctrl-P, https://github.com/ctrlpvim/ctrlp.vim#basic-options
let g:ctrlp_user_command = ['.git', 'cd %s && git ls-files -co --exclude-standard | grep -v \.html$']

nmap ]h <Plug>(GitGutterNextHunk)
nmap [h <Plug>(GitGutterPrevHunk)
" nnoremap <leader>hU :GitGutterUndoHunk<cr>
nmap ghs <Plug>(GitGutterStageHunk)
nmap ghu <Plug>(GitGutterUndoHunk)

" https://github.com/mhinz/vim-grepper/wiki/example-configurations-and-mappings
" \g, \G
nnoremap <leader>g :Grepper -tool git<cr>
nnoremap <leader>G :Grepper -tool ag<cr>
" nmap gs <plug>(GrepperOperator)
" xmap gs <plug>(GrepperOperator)

" https://github.com/nvim-telescope/telescope.nvim, \ff, \fg, \fb, \fh
nnoremap <leader>ff <cmd>Telescope find_files<cr>
nnoremap <leader>fg <cmd>Telescope live_grep<cr>
nnoremap <leader>fb <cmd>Telescope buffers<cr>
nnoremap <leader>fh <cmd>Telescope help_tags<cr>

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

" https://hackage.haskell.org/package/hls-tactics-plugin

" <space>d to perform a pattern match, <leader>n to fill a hole
nnoremap <silent> <leader>d  :<C-u>set operatorfunc=<SID>WingmanDestruct<CR>g@l
nnoremap <silent> <leader>n  :<C-u>set operatorfunc=<SID>WingmanFillHole<CR>g@l
" nnoremap <silent> <leader>r  :<C-u>set operatorfunc=<SID>WingmanRefine<CR>g@l
" nnoremap <silent> <leader>c  :<C-u>set operatorfunc=<SID>WingmanUseCtor<CR>g@l
" nnoremap <silent> <leader>a  :<C-u>set operatorfunc=<SID>WingmanDestructAll<CR>g@l


function! s:JumpToNextHole()
  call CocActionAsync('diagnosticNext', 'hint')
endfunction

function! s:GotoNextHole()
  " wait for the hole diagnostics to reload
  sleep 500m
  " and then jump to the next hole
  normal 0
  call <SID>JumpToNextHole()
endfunction

function! s:WingmanRefine(type)
  call CocAction('codeAction', a:type, ['refactor.wingman.refine'])
  call <SID>GotoNextHole()
endfunction

function! s:WingmanDestruct(type)
  call CocAction('codeAction', a:type, ['refactor.wingman.caseSplit'])
  call <SID>GotoNextHole()
endfunction

function! s:WingmanDestructAll(type)
  call CocAction('codeAction', a:type, ['refactor.wingman.splitFuncArgs'])
  call <SID>GotoNextHole()
endfunction

function! s:WingmanFillHole(type)
  call CocAction('codeAction', a:type, ['refactor.wingman.fillHole'])
  call <SID>GotoNextHole()
endfunction

function! s:WingmanUseCtor(type)
  call CocAction('codeAction', a:type, ['refactor.wingman.useConstructor'])
  call <SID>GotoNextHole()
endfunction

" Do not autoreload files on change, ask for confirmation instead
set noautoread
