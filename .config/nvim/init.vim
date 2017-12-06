scriptencoding utf-8

" execute pathogen#infect()

" General settings {{{
let mapleader="," " Use comma as the leader key
set shada="!,'100,<50,s10,h"
set undofile
set writebackup
set backupskip+=*.gpg " Don't save backups of *.gpg files
set updatetime=1000
set whichwrap=h,l,b,s,<,>,[,] " arrow keys, bs, space wrap to next/prev line
set ignorecase smartcase " case insensitive search if all lowercase
set breakindent
set fixendofline " Ensure file ends with new line
set nojoinspaces
" set virtualedit=onemore " Allow cursor to move one char past the end of the line
set autoread " Reload current file if changed on disk but not in buffer
set mouse=a
set viewoptions=cursor,folds,slash,unix " Recommended by vim-stay plugin
set hidden
set tags="/home/nadrieril/.local/share/nvim/tags"
let g:easytags_file="/home/nadrieril/.local/share/nvim/tags"

" Don't eval modelines by default. See Gentoo bugs #14088 and #73715.
set modelines=0
set nomodeline

" Indentation
set copyindent " Copy the structure of existing lines when indenting a new line
set expandtab " Always use space, no tabs
set shiftwidth=4
set softtabstop=4 " number of spaces in tab when editing
set tabstop=4 " number of visual spaces per TAB
set smartindent


" Enable folding based on indentation
set foldmethod=indent
set nofoldenable

" Default /bin/sh is bash, not ksh, so syntax highlighting for .sh files should
" default to bash. See :help sh-syntax and Gentoo bug #101819.
if has("eval")
  let is_bash=1
endif

" Configure completion
set wildmode=longest:full,full
set wildignore+=*~,*.bak,*.o,*.pyc,*.pyo,*.swo,*.swp,*.class
set wildignore+=*.dll,*.exe,*.so,*.swf,*.zip,*.tar
set wildignore+=*/.git/*,*/.hq/*,*/.svn/*
set wildignorecase

" Bepo langmap
" set langmap=ba,éz,pe,or,èt,çy,vu,di,lo,fp,j^,z$,aq,us,id,ef,\\,g,ch,tj,sk,rl,nm,mù,^*,ê<,àw,yx,xc,.v,kb,'n,q\\,,g\\;,h:,f!,BA,ÉZ,PE,OR,ÈT,ÇY,VU,DI,LO,FP,J¨,Z£,AQ,US,ID,EF,?G,CH,TJ,SK,RL,NM,M%,!*,Ê>,ÀW,YX,XC,:V,KB,\\;N,QG,G.,H/,F§,@œ,_&,"é,«",»',((,)-,+è,-_,*ç,/à,=),%=,$Œ,^°,µ+,#“,{´,}~,<#,>{,[[,]|,±`,¬\,×^,÷@,¯],%}

" }}}


" UI settings {{{
set ruler " Show the cursor position all the time
set showfulltag " View full tag when doing a tag search
set scrolloff=6 " Always show at least n lines above and below the cursor
set sidescrolloff=5 " Always show at least 5 columns at cursor sides in nowrap mode
set ffs=unix,dos,mac " Use <NL>-terminated lines by default, then <CR><NL> and finally <CR>
set number " Show line numbers
set relativenumber " Show relative line numbers
set numberwidth=3 " When displaying line numbers, don't use an annoyingly wide number column.
set guicursor=n-v-c-sm:block,i-ci-ve:ver25,r-cr-o:hor20 " allows cursor change in terminal
set list
set listchars=tab:›─,trail:─,nbsp:␣,extends:»,precedes:«
set showmatch " Show matching brackets
" set showmode " Show the current mode on the last line

set cursorline " highlight current line
" set cursorcolumn " highlight cursor column
" au WinLeave * set nocursorline nocursorcolumn
" au WinEnter * set cursorline cursorcolumn

" t: autowrap text using textwidth
" l: long lines are not broken in insert mode
" c: autowrap comments using textwidth, inserting leader
" r: insert comment leader after <CR>
" o: insert comment leader after o or O
set formatoptions=clqr

" options for diff mode
set diffopt=filler
" set diffopt+=context:4
" set diffopt+=iwhite
set diffopt+=vertical

set splitbelow
set splitright


" Colors
set background=dark
" set termguicolors

" " Highlight extra whitespaces
" autocmd ColorScheme * highlight ExtraWhitespace ctermbg=darkred
" highlight ExtraWhitespace ctermbg=darkred
" let g:m_extra_whitespace = matchadd('ExtraWhitespace', '\s\+$')

colorscheme onedark
let g:airline_theme='onedark'

" }}}


" Mappings {{{

" General {{{
" Make $ move to the end of the line when virtualedit=onemore
" noremap $ g$
" noremap £ $

" Leave the cursor in place when exiting Insert mode
" inoremap <ESC> <C-O>mz<ESC>`z

" Backspace deletes as expected
map <BS> "_X


" easier move screen up/down
nmap <C-j> <C-D>
nmap <C-k> <C-U>

" Disable arrow keys
noremap <Up> <nop>
noremap <Down> <nop>
noremap <Left> <nop>
noremap <Right> <nop>

" " Fold/unfold code with space
" nnoremap <SPACE> za
" vnoremap <SPACE> zf

" Undo in insertion mode
" imap <C-U> <Esc>ui

" (un)comment in insert mode
" imap <C-_> <C-o>gcc<C-o>$

" Easier save
imap <C-S> <Esc>:w<CR>
nnoremap <C-S> :w<CR>
nnoremap <C-z> :q<CR>

" Join with next line
inoremap <C-j> <C-o>J

" Convenience
map à 0
nmap <CR> o<ESC>

" Duplicate line/block
" vnoremap <Leader>d "zy'>"zp
" nnoremap <Leader>d "zyy"zp

" Use <C-L> to clear the highlighting of :set hlsearch.
nnoremap <silent> <C-L> :nohlsearch<C-R>=has('diff')?'<Bar>diffupdate':''<CR><CR><C-L>

" Indentation
" vnoremap <Tab> >gv
" vnoremap <S-Tab> <gv
vnoremap > >gv
vnoremap < <gv

" " use arrow keys to swap between split windows
" nmap <left> <C-W>h
" nmap <right> <C-W>l
" nmap <up> <C-W>k
" nmap <down> <C-W>j

" " sets current word/selection as search pattern
function! MakePattern(text)
  let pat = escape(a:text, '[]/\.*')
  " Trim whitespace
  let pat = substitute(pat, '\_s\+$', '', '')
  let pat = substitute(pat, '^\_s\+', '', '')
  " Expand internal whitespace
  let pat = substitute(pat, '\_s\+',  '\\_s\\+', 'g')
  return '\\V' . escape(pat, '\"')
endfunction
function! EscapePattern(text)
  return escape(a:text, '[]/\.*\"')
endfunction
function! HighlightText(text)
  return 'let @/="<C-R>='.a:text.'<CR>"\|set hlsearch'
endfunction
function! ReplaceFromCursor(text)
  return ',$s/<C-R>='.a:text.'<CR>//gce\|echo "Continue at beginning of file? (y/q)"\|if getchar()==121\|1,''''-&&\|en\|:nohls'.repeat('<left>',84)
endfunction

" vmap / y:execute "/".escape(@",'[]/\.*')<CR>`<
exe 'nnoremap <silent> * :'.HighlightText('expand("<cword>")').'<CR>'
exe 'vnoremap <silent> * "zy:'.HighlightText('MakePattern(@z)').'<CR>'
exe 'vnoremap q* "zy<ESC>:'.HighlightText('MakePattern(@z)').'<CR>:'.ReplaceFromCursor('EscapePattern(@")')

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
" " <F11> don't use; terminal full-screen
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
let g:ctrlp_mruf_relative = 1
let g:ctrlp_tabpage_position = 'al'
let g:ctrlp_working_path_mode = 'w'
let g:ctrlp_prompt_mappings = {
  \ 'AcceptSelection("e")': ['<c-t>'],
  \ 'AcceptSelection("t")': ['<cr>', '<2-LeftMouse>'],
\ }

" terryma/vim-multiple-cursors
" let g:multi_cursor_quit_key='<C-E>'
let g:multi_cursor_exit_from_visual_mode=0
let g:multi_cursor_exit_from_insert_mode=0

" easymotion
map <Leader> <Plug>(easymotion-prefix)

" airline
let g:airline_powerline_fonts = 1
let g:airline_extensions = ['branch', 'tabline', 'ctrlp', 'obsession', 'neomake', 'ale']
let g:airline#parts#ffenc#skip_expected_string = 'utf-8[unix]'
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tabline#formatter = 'unique_tail_improved'
" let g:airline#extensions#tabline#show_close_button = 0
let g:airline#extensions#obsession#enabled = 1

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

" ale
let g:ale_emit_conflict_warnings = 0
let g:ale_echo_msg_error_str = 'E'
let g:ale_echo_msg_warning_str = 'W'
let g:ale_echo_msg_format = '[%linter%] %s [%severity%]'
let g:ale_linters = {
\   'haskell': ['stack-ghc', 'stack-ghc-mod', 'hlint'],
\}

" neomake
nmap <C-B> <C-S>:Neomake!<CR>
imap <C-B> <C-S>:Neomake!<CR>

function! OnNeomakeJobFinished() abort
  let context = g:neomake_hook_context
  echom printf('The job for maker "%s" exited (%s)',
    \ context.jobinfo.maker.name, context.jobinfo.exit_code)
endfunction
autocmd User NeomakeJobFinished call OnNeomakeJobFinished()

" deoplete
let g:deoplete#enable_at_startup = 1
call deoplete#custom#set('_', 'matchers', ['matcher_fuzzy'])
set completeopt=menuone,preview,longest

imap <expr><TAB>
      \ neosnippet#jumpable() ? "\<Plug>(neosnippet_jump)" :
      \ pumvisible() ? "\<c-n>" :
      \ <SID>check_back_space() ? "\<TAB>" :
      \ deoplete#mappings#manual_complete()
imap <expr><S-TAB> pumvisible() ? "\<c-p>" : "\<S-TAB>"

function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~ '\s'
endfunction"

" Workaround to really insert newline on <Enter>
inoremap <silent> <CR> <C-r>=<SID>really_newline()<CR>
function! s:really_newline() abort
  return deoplete#close_popup() . "\<CR>"
endfunction


" supertab
" let g:SuperTabLongestEnhanced = 1

" neosnippet
let g:neosnippet#enable_completed_snippet = 1
autocmd CompleteDone * if !empty(v:completed_item) && neosnippet#expandable() | exec "normal i\<Plug>(neosnippet_expand)" | end

let g:neosnippet#enable_snipmate_compatibility = 1
let g:neosnippet#snippets_directory='~/.config/nvim/snippets'
let g:neosnippet#disable_runtime_snippets = { '_' : 1 }

" vim-pandoc-syntax
let g:pandoc#syntax#conceal#use = 0
augroup pandoc_syntax
  au! BufNewFile,BufFilePre,BufRead *.md set filetype=markdown.pandoc
augroup end

" tex.vim
let g:tex_conceal = "amgs"

" auto-pairs
let g:AutoPairsMultilineClose = 0

" latex-unicoder
let g:unicoder_no_map = 1
nmap <Leader>l <Plug>Unicoder
imap <C-l> <Plug>Unicoder
vmap <Leader>l <Plug>Unicoder

" t9md/vim-textmanip
nmap <leader>d <Plug>(textmanip-duplicate-down)
nmap <leader>D <Plug>(textmanip-duplicate-up)
vmap <leader>d <Plug>(textmanip-duplicate-down)
vmap <leader>D <Plug>(textmanip-duplicate-up)
vmap <leader>Dl <Plug>(textmanip-duplicate-right)
vmap <leader>Dh <Plug>(textmanip-duplicate-left)

imap <M-j> <C-o><Plug>(textmanip-move-down)
imap <M-k> <C-o><Plug>(textmanip-move-up)
nmap <M-j> <Plug>(textmanip-move-down)
nmap <M-k> <Plug>(textmanip-move-up)
vmap <M-j> <Plug>(textmanip-move-down)
vmap <M-k> <Plug>(textmanip-move-up)
vmap <M-h> <Plug>(textmanip-move-left)
vmap <M-l> <Plug>(textmanip-move-right)

" haskell-vim
" Disable haskell-vim omnifunc
let g:haskellmode_completion_ghc = 0
autocmd FileType haskell setlocal omnifunc=necoghc#omnifunc

let g:haskell_enable_quantification = 1   " enable highlighting of `forall`
" let g:haskell_indent_disable = 1

" vim-hindent
" let g:hindent_indent_size = 4

" ghc-mod
map <silent> <leader>ht :GhcModType<CR>
map <silent> <leader>hT :GhcModTypeInsert<CR>
map <silent> <leader>hc :GhcModSplitFunCase<CR>
map <silent> <leader>hl :GhcModTypeClear<CR>

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

" Strip trailing whitespace
function! StripTrailingWhite()
  let l:winview = winsaveview()
  silent! %s/\s\+$//
  call winrestview(l:winview)
endfunction

function! s:openterm() abort
  let currdir = getcwd()
  let netrwdir = fnamemodify(b:netrw_curdir, ':t')
  execute 'lcd '.netrwdir
  execute 'terminal'
  execute 'lcd '.currdir
endfunction

function MarkdownLevel()
  let h = matchstr(getline(v:lnum), '^#\+')
  if ! empty(h)
    return ">" . len(h)
  elseif ! empty(matchstr(getline(v:lnum), '^<div'))
    return "a1"
  elseif ! empty(matchstr(getline(v:lnum), '^</div'))
    return "s1"
  else
    return "="
  endif
endfunction
" }}}

" Autocmds {{{

" Remove trailing whitespace on write
autocmd FileType c,cpp,java,php,python,scala,haskell autocmd BufWritePre <buffer> call StripTrailingWhite()

au BufEnter *.md setlocal foldexpr=MarkdownLevel()
au BufEnter *.md setlocal foldmethod=expr

autocmd FileType haskell setlocal shiftwidth=4 formatprg=hindent

autocmd BufWritePre /tmp/* setlocal noundofile
autocmd BufWritePre /dev/shm/* setlocal noundofile

" }}}

