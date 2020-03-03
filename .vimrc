nmap <S-Right> :tabn<CR>                                                                                                                                                                                    
nmap <S-Left> :tabp<CR>                                                         
nmap <S-l> :tabn<CR>                                                            
nmap <S-h> :tabp<CR>

" So that "+p works
" set clipboard=unnamedplus

" Highlight current line's background
set cursorline
:syntax on

" Always display line numbers
set number

" Insert spaces instead of tabs
set expandtab

" For large files:
" :syntax off
" :se binary nospell

" Call ~/.vim/autoload/pathogen.vim
" cd .vim/; mkdir autoload; git clone https://github.com/tpope/vim-pathogen.git
" mv $(find . -name pathogen.vim) autoload/.; rm -Rf vim-pathogen
call pathogen#infect()
call pathogen#helptags()

" Call the plugin ~/.vim/bundle/tagbar
" cd .vim/bundle; git clone https://github.com/majutsushi/tagbar
nmap <F8> :TagbarToggle<CR> 
" Update position in outline every 0.5s (default is 4)
set updatetime=500
" Sort by name
let g:tagbar_sort = 0
" Put tagbar on the left
let g:tagbar_left = 1

" Default is 10 O_o
set tabpagemax=128

" Highlight search results
set hlsearch

" cd .vim/bundle; git clone https://github.com/dracula/vim dracula
colorscheme dracula
" colorscheme farout

set laststatus=2
set statusline+=%{FugitiveStatusline()}
