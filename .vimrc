" ScarZy's vim config
" tristan.watson@protonmail.ch
" github.com/Skarzee


call plug#begin('~/.vim/plugged')
Plug 'tpope/vim-sensible'
Plug 'rodjek/vim-puppet'
Plug 'scrooloose/syntastic'
Plug 'godlygeek/tabular'
Plug 'tpope/vim-fugitive'
Plug 'kien/ctrlp.vim'
Plug 'scrooloose/nerdtree'
Plug 'airblade/vim-gitgutter'
Plug 'scrooloose/syntastic'
Plug 'vim-airline/vim-airline'
Plug 'ambdalisue/vim-pyenv'
Plug 'stephpy/vim-yaml'
Plug 'SirVer/ultisnips'

" Visuals
Plug 'nanotech/jellybeans.vim'
Plug 'sjl/badwolf'
Plug 'chriskempson/base16-vim'
Plug 'reedes/vim-colors-pencil'
Plug 'fxn/vim-monochrome'
Plug 'croaker/mustang-vim'
Plug 'sts10/vim-mustard'
call plug#end()

set number
set modelines=5 
set hidden
set tabstop=4
set smarttab
set bs=1
set ignorecase
set wildmenu
set viminfo='125,<1000,s100,h
" Installation of powerline fonts for Pragmata
let g:airline_powerline_fonts = 1
