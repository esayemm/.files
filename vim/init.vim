" ============================================================================
" GENERAL
" ============================================================================


" Enable filetype plugins
filetype plugin indent on
syntax enable

" Resize vim upon resize eg. pane sizing when resizing terminal window
au VimResized * exe "normal! \<c-w>="

set encoding=utf8
set nocompatible
set clipboard=unnamed                         " use system clipboard, vim must have +clipboard
set noreadonly                                " for vimdiff
set history=1000                              " Sets how many lines of history VIM has to remember
set ttyfast                                   " send more characters for faster redraws
set lazyredraw                                " Don't redraw while executing macros
set autoread                                  " update when a file is changed from the outside
" reload buffer when moving around for file changes from outside
" https://vi.stackexchange.com/questions/444/how-do-i-reload-the-current-file
au FocusGained,BufEnter * :checktime
set showcmd                                   " Show incomplete cmds down the bottom
set hidden                                    " A buffer becomes hidden when it is abandoned
set ignorecase smartcase hlsearch incsearch   " Search settings
set nobackup nowb noswapfile                  " No vim backup files
set ffs=unix,dos,mac                          " Use Unix as the standard file type
set noerrorbells novisualbell t_vb= tm=500    " No annoying sound on errors
set backspace=eol,start,indent                " Configure backspace so it acts as it should act
set whichwrap+=<,>,h,l                        " automatically wrap left and right
set relativenumber                            " show relative number from curent line
set t_Co=256                                  " 256 colors in vim
set textwidth=80 colorcolumn=80 lbr tw=80     " set line break to 80
set number numberwidth=2                      " show line number in left margin
set cursorline!                               " highlight current cursor's line
set ruler laststatus=2 title                  " Sets ruler show current line
set magic                                     " For regular expressions turn magic on
set showmatch                                 " Show matching brackets when text indicator is over them
set mat=2                                     " How many tenths of a second to blink when matching brackets
set wildmenu                                  " Turn on the WiLd menu
set wildmode=list:longest,full
set wildignorecase
set wildignore=*.o,*~,*.pyc                   " Ignore compiled files
set shiftwidth=2 tabstop=2 expandtab smarttab " tab space
set wrap                                      " Wrap lines
set cmdheight=2                               " Display for messages
set updatetime=300
set signcolumn=yes
set copyindent                                " Paste mode
set iskeyword+=- " treat dash as word

autocmd BufWritePre * :%s/\s\+$//e            " Clear trailing spaces on save

" File types
au BufRead,BufNewFile *.ejs,*.handlebars set filetype=html
au BufRead,BufNewFile *.css set filetype=scss.css
au BufRead,BufNewFile *.scss set filetype=scss
au BufRead,BufNewFile *.js set filetype=javascript
au BufRead,BufNewFile *.conf set filetype=nginx
au BufRead,BufNewFile *.sls,*.{yaml,yml},*.service set filetype=yaml
au BufRead,BufNewFile *.ts,*.tsx set filetype=typescript.tsx
au BufRead,BufNewFile *.groovy set filetype=Jenkinsfile
au BufRead,BufNewFile *.Dockerfile set filetype=dockerfile
au BufRead,BufNewFile .bazelrc set filetype=conf

autocmd FileType yaml setlocal ts=2 sts=2 sw=2 expandtab
autocmd FileType scss.css set omnifunc=csscomplete#CompleteCSS
autocmd FileType html,markdown setlocal omnifunc=htmlcomplete#CompleteTags
autocmd FileType javascript setlocal omnifunc=javascriptcomplete#CompleteJS
autocmd FileType python setlocal omnifunc=pythoncomplete#Complete
autocmd FileType xml setlocal omnifunc=xmlcomplete#CompleteTags
autocmd FileType json syntax match Comment +\/\/.\+$+

" vimdiff, ignore whitespace
if &diff
  " diff mode
  set diffopt+=iwhite
  map gs :call IwhiteToggle()<CR>
  function! IwhiteToggle()
    if &diffopt =~ 'iwhite'
      set diffopt-=iwhite
    else
      set diffopt+=iwhite
    endif
  endfunction
endif

" ============================================================================
" KEYBINDINGS
" ============================================================================

" Set Leader
let g:mapleader = ","

" save and quit
map <leader>w :w!<cr>
map <leader>q :qa<cr>

" jk to escape from all modes
imap jk <Esc>

" control a/e will go back and front of line
imap <C-a> <esc>I
imap <C-e> <esc>A

" tab buffer shortcuts
nmap <leader>[ :bprevious<CR>
nmap <leader>] :bnext<CR>
nmap <leader>d :BD<CR>

" Shorten next window command
" see more here
" :help <C-w>
map <C-w> <C-w>w

" next search will center screen
nnoremap n nzzzv
nnoremap N Nzzzv

" replace word under cursor
nnoremap <leader>r :%s/\<<C-r><C-w>\>//g<Left><Left>

" move up and down wrapped lines
nnoremap j gj
nnoremap k gk

" capitol movement keys will do sensible corresponding movement
noremap H ^
noremap L g_
noremap J 6j
noremap K 6k

" clear search highlight
nnoremap <leader><space> :nohlsearch<cr>

" shortcut for visual mode sort
vnoremap <leader>s :sort

" do not override register when pasting
xnoremap p pgvy

" execute macro on every line of visual selection
xnoremap @ :<C-u>call ExecuteMacroOverVisualRange()<CR>
function! ExecuteMacroOverVisualRange()
  echo "@".getcmdline()
  execute ":'<,'>normal @".nr2char(getchar())
endfunction

map <leader>e :Explore<CR>
let g:netrw_list_hide = '^\..*'
let g:netrw_hide = 1

" ============================================================================
" VIM_PLUG
" ============================================================================

let python3_bin = system("which python3")
let g:python3_host_prog=$python3_bin

call plug#begin('~/.vim/plugged')

source ~/.config/nvim/plugins.vim

call plug#end()

let base16colorspace=256        " Let base16 access colors present in 256 colorspace
colorscheme base16-default-dark

" ============================================================================
" Windows WSL
" ============================================================================

" Setup yanking from vim to windows clipboard
if system('uname -r') =~ "microsoft"
  augroup Yank
    autocmd!
    autocmd TextYankPost * :call system('clip.exe ',@")")
  augroup END
endif

set secure
