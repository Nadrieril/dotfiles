scriptencoding utf-8

execute pathogen#infect()

" General settings {{{
let mapleader="," " Use comma as the leader key
set shada="!,'100,<50,s10,h"
set undofile
set writebackup
set backupskip+=*.gpg " Don't save backups of *.gpg files
set updatetime=1000
set whichwrap=h,l,b,s,<,>,[,] " arrow keys, bs, space wrap to next/prev line
set ignorecase smartcase " case insensitive search if all lowercase

" Don't eval modelines by default. See Gentoo bugs #14088 and #73715.
set modelines=0
set nomodeline

" Indentation
set copyindent " Copy the structure of existing lines when indenting a new line
set expandtab " Always use space, no tabs
set shiftwidth=4
set softtabstop=4 " number of spaces in tab when editing
set tabstop=4 " number of visual spaces per TAB


" Enable folding based on indentation
set foldmethod=indent
set nofoldenable

" Default /bin/sh is bash, not ksh, so syntax highlighting for .sh files should
" default to bash. See :help sh-syntax and Gentoo bug #101819.
if has("eval")
  let is_bash=1
endif

" Configure completion
set wildmenu
set wildmode=longest:list,full
set wildignore+=*~,*.bak,*.o,*.pyc,*.pyo,*.swo,*.swp
set wildignore+=*.dll,*.exe,*.so,*.swf,*.zip,*.tar
set wildignore+=*/.git/*,*/.hq/*,*/.svn/*
set wildignorecase


" }}}


" UI settings {{{
set ruler " Show the cursor position all the time
set showfulltag " View full tag when doing a tag search
set scrolloff=12 " Always show at least n lines above and below the cursor
set sidescrolloff=5 " Always show at least 5 columns at cursor sides in nowrap mode
set ffs=unix,dos,mac " Use <NL>-terminated lines by default, then <CR><NL> and finally <CR>
set number " Show line numbers
set relativenumber " Show relative line numbers
set numberwidth=3 " When displaying line numbers, don't use an annoyingly wide number column.
let $NVIM_TUI_ENABLE_CURSOR_SHAPE = 2 " allows cursor change in tmux
set cursorline " highlight current line
set cursorcolumn " highlight cursor column
set list
set listchars=tab:›─,trail:─,nbsp:␣,extends:»,precedes:«
set showmatch " Show matching brackets
" set showmode " Show the current mode on the last line

" t: autowrap text using textwidth
" l: long lines are not broken in insert mode
" c: autowrap comments using textwidth, inserting leader
" r: insert comment leader after <CR>
" o: insert comment leader after o or O
set formatoptions-=t
set formatoptions+=lcr

" options for diff mode
" set diffopt=filler
" set diffopt+=context:4
" set diffopt+=iwhite
" set diffopt+=vertical


" Colors
set background=dark
set termguicolors
colorscheme onedark
let g:airline_theme='onedark'

" Highlight extra whitespaces
highlight ExtraWhitespace ctermbg=red guibg=red
let g:m_extra_whitespace = matchadd('ExtraWhitespace', '\s\+$')

" keep cursor column last so it overrides all others
highlight CursorLine cterm=none ctermbg=15
highlight CursorColumn cterm=none ctermbg=DarkGrey


" }}}


" Mappings {{{

" {{{ General
" easier move screen up/down
nmap <M-j> 5<C-e>
nmap <M-k> 5<C-y>
nmap <C-j> <C-D>
nmap <C-k> <C-U>

" Fold/unfold code with space
nnoremap <SPACE> za
vnoremap <SPACE> zf

" Escape when inserting "jk"
inoremap jk <ESC>
inoremap kj <ESC>

" Sometimes we forget to leave insertion mode
inoremap :w<CR> <ESC>:w<CR>
inoremap :wq<CR> <ESC>:wq<CR>

" Undo in insertion mode
inoremap <C-U> <Esc>ui

" Join with next line
inoremap <C-j> <C-o>J

" Convenience
map à 0

" Duplicate line/block
vnoremap <Leader>d y'>p
nnoremap <Leader>d yyp

" Use <C-L> to clear the highlighting of :set hlsearch.
if maparg('<C-L>', 'n') ==# ''
  nnoremap <silent> <C-L> :nohlsearch<C-R>=has('diff')?'<Bar>diffupdate':''<CR><CR><C-L>
endif

" Indentation
vnoremap <Tab> >gv
vnoremap <S-Tab> <gv
vnoremap > >gv
vnoremap < <gv

" Move lines up/down
nnoremap <M-j> :m.+1<CR>==
nnoremap <M-k> :m.-2<CR>==
inoremap <M-j> <Esc>:m.+1<CR>==gi
inoremap <M-k> <Esc>:m.-2<CR>==gi
vnoremap <M-j> :m'>+1<CR>gv=gv
vnoremap <M-k> :m'<-2<CR>gv=gv

" " use arrow keys to swap between split windows
" nmap <left> <C-W>h
" nmap <right> <C-W>l
" nmap <up> <C-W>k
" nmap <down> <C-W>j
"}}}

"f keys {{{
" Get rid of F1
" nmap <F1> <nop>
" imap <F1> <nop>
" nmap <F2> :call ToggleColumns()<CR>
" imap <F2> <C-o>:call ToggleColumns()<CR>
" nmap <F3> :Nload<CR>
" nmap <F4> :NERDTree<CR>
" set pastetoggle=<F5>
" " <F6>
" nmap <F7> :!updatedev.php %:p<CR>
" nmap <F8> :call WriteTrace()<CR>
" nmap <F9> \ph
" " <F10>
" " <F11> don't use; terminal full-screen "
" " <F12>
" " }}}

" Tab management {{{
" open dir of current file in new tab
nmap <Leader>oc :tabe %:h<CR>

" Navigate to tab to the left/right
nmap H gT
nmap L gt

" " move tab left or right
" nmap <C-l> :call MoveTab(0)<CR>
" nmap <C-h> :call MoveTab(-2)<CR>

" gf should use new tab, not current buffer
map gf :tabe <cfile><CR>

" " map keys to tabs
" nmap <C-t> :tabnew<CR>
" imap <C-t> <ESC>:tabnew<CR>i
" map <C-t> :tabnew<CR>:E<CR>
" nnoremap <LEADER>nt :tabnew<CR>
" nnoremap <LEADER>h :tabprevious<CR>
" nnoremap <LEADER>l :tabnext<CR>

"}}}

"}}}


" Plugin configuration {{{

" mbbill/undotree
map <F12> :UndotreeToggle<CR>
imap <F12> <C-O>:UndotreeToggle<CR>

" ctrlpvim/ctrlp
" let g:ctrlp_map = '<Esc>d'

" terryma/vim-multiple-cursors
" let g:multi_cursor_quit_key='<C-E>'
let g:multi_cursor_exit_from_visual_mode=0
let g:multi_cursor_exit_from_insert_mode=0

" easymotion
map <Leader> <Plug>(easymotion-prefix)

" airline
let g:airline_powerline_fonts = 1
let g:airline_extensions = ['branch', 'tabline']

" rhysd/committia.vim
let g:committia_open_only_vim_starting = 0
let g:committia_hooks = {}
function! g:committia_hooks.edit_open(info)
    setlocal spell

    if a:info.vcs ==# 'git' && getline(1) ==# ''
        startinsert
    end

    imap <buffer><C-n> <Plug>(committia-scroll-diff-down-half)
    imap <buffer><C-p> <Plug>(committia-scroll-diff-up-half)
endfunction

" yggdroot/indentline
" let g:indentLine_setColors = 0
let g:indentLine_char = '│'
let g:indentLine_color_term = 59

" }}}


" Helper functions {{{

" Move tabs
fun! MoveTab(n)
  let which = tabpagenr()
  let which = which + a:n
  exe "tabm ".which
endfunction

"make it easy to remove line number column etc. for cross-terminal copy/paste
fun! ToggleColumns()
  if &number
    set nonumber
    set foldcolumn=0
    let s:showbreaktmp = &showbreak
    set showbreak=
  else
    set number
    set foldcolumn=2
    let &showbreak = s:showbreaktmp
  end
endfunction

" Save with sudo
command! -nargs=1 Wroot :w !sudo tee <args> > /dev/null


" }}}

