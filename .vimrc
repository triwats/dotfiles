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
Plug 'stephpy/vim-yaml'
Plug 'SirVer/ultisnips'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-unimpaired'
Plug 'cespare/vim-sbd'
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
Plug 'tomtom/tcomment_vim'

" Visuals
Plug 'nanotech/jellybeans.vim'
Plug 'sjl/badwolf'
Plug 'chriskempson/base16-vim'
Plug 'reedes/vim-colors-pencil'
Plug 'fxn/vim-monochrome'
Plug 'croaker/mustang-vim'
Plug 'sts10/vim-mustard'
call plug#end()

" Set Colourscheme
colorscheme jellybeans

" Behaviour
set number
set modelines=5 
set hidden
set tabstop=4
set smarttab
set bs=1
set ignorecase
set wildmenu
set viminfo='125,<1000,s100,h

"Configuration for BufTabLine
let g:buftabline_indicators=1
let g:buftabline_numbers=1

" Installation of powerline fonts for Pragmata
let g:airline_powerline_fonts = 1
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tabline#fnamemod = ':t'

" Smart Buffer Delete
nnoremap <silent> <C-x> :Sbd<CR>

" CTRL-P Voodoo
let g:ctrlp_match_window = 'bottom,order:ttb'
let g:ctrlp_switch_buffer = 0
let g:ctrlp_working_path_mode = 0
let g:ctrlp_user_command = '/usr/local/bin/ag %s -l --nocolor --hidden -g ""'

" NerdTree Params
map <C-n> :NERDTreeToggle<CR>
let NERDTreeShowBookmarks=1
let NERDTreeShowHidden=1
let NERDTreeBookmarksSort = 1

" SilverSearch (Ag)
nnoremap <C-s> :Ag 
