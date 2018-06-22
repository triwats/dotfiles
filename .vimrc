" ScarZy's vim config
" github.com/Skarzee

call plug#begin('~/.vim/plugged')
Plug 'tpope/vim-sensible'
Plug 'rodjek/vim-puppet'
Plug 'godlygeek/tabular'
Plug 'tpope/vim-fugitive'
Plug 'scrooloose/nerdtree'
Plug 'airblade/vim-gitgutter'
" Plug 'scrooloose/syntastic'
Plug 'vim-airline/vim-airline'
Plug 'SirVer/ultisnips'
Plug 'tpope/vim-surround'
Plug 'w0rp/ale'
Plug 'tpope/vim-unimpaired'
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
Plug 'tomtom/tcomment_vim'
Plug 'hashivim/vim-terraform'
Plug 'elzr/vim-json'
Plug 'pearofducks/ansible-vim'
" Visuals
Plug 'nanotech/jellybeans.vim'
call plug#end()

" Set Colourscheme
colorscheme jellybeans 

" Theme specific
set termguicolors

" Behaviour
set number
set modelines=5
set hidden
set tabstop=4
set smarttab
set bs=1
set ignorecase
set softtabstop=4
set shiftwidth=4
set wildmenu
set viminfo='125,<1000,s100,h
set expandtab

" Configure identLine
let g:indentLine_leadingSpaceEnabled = 1

" Configuration for BufTabLine
let g:buftabline_indicators=1
let g:buftabline_numbers=1

" Installation of Powerline fonts for Pragmata
let g:airline_powerline_fonts = 1
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tabline#fnamemod = ':t'

" Smart Buffer Delete
nnoremap <silent> <C-x> :Sbd<CR>

" NerdTree Params
map <C-n> :NERDTreeToggle<CR>
let NERDTreeShowBookmarks=1
let NERDTreeShowHidden=1
let NERDTreeBookmarksSort = 1

" ALE Specific
let g:ale_sign_column_always = 1
let g:ale_yaml_yamllint_options = 'line-length: {max: 120}'

" Terraform
let g:terraform_align=1

" Change Position of FZF
let g:fzf_layout = { 'window': 'enew' }

if executable('FZF')
  " FZF {{{
  " <C-p> or <C-t> to search files
  nnoremap <silent> <C-s> :FZF -m<cr>

  " <M-p> for open buffers
  nnoremap <silent> <M-p> :Buffers<cr>

  " <M-S-p> for MRU
  nnoremap <silent> <M-S-p> :History<cr>

  " Use fuzzy completion relative filepaths across directory
  imap <expr> <c-x><c-f> fzf#vim#complete#path('git ls-files $(git rev-parse --show-toplevel)')

  " Better command history with q:
  command! CmdHist call fzf#vim#command_history({'right': '40'})
  nnoremap q: :CmdHist<CR>

  " Better search history
  command! QHist call fzf#vim#search_history({'right': '40'})
  nnoremap q/ :QHist<CR>

  command! -bang -nargs=* Ack call fzf#vim#ag(<q-args>, {'down': '40%', 'options': --no-color'})
  " }}}
:endif
