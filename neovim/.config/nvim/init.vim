set encoding=utf-8
scriptencoding utf-8

set nocompatible

map <space> <leader>

" General reminders
" - Shortcuts
"   - ctrl<C> and alt<A> shortcuts cannot be case sensitive (<C-f> and <C-F> are the same)
"   - only plain shift key shortcut (also with leader) can be case sensitive (ie f and F, or <leader>f and <leader>F )
" - Augroups
"   - augroups namespace autocommands together, autocmd! clears all commands in the namespace first
"   - remaps using FileType and <buffer> will only be active for that given buffer and FileType
"   - all other remaps apply to all filetypes and buffers

" ============================================================================
" VIM-PLUG
" ============================================================================
if empty(glob('~/.config/nvim/autoload/plug.vim'))
  silent !curl -fLo ~/.config/nvim/autoload/plug.vim --create-dirs
        \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

call plug#begin('~/.config/nvim/plugged')

" sweet syntax highlighting
Plug 'nvim-treesitter/nvim-treesitter'
" TODO autocmd to run this on startup?
" :TSInstall all
" :TSUpdate

Plug 'neoclide/coc.nvim', {'branch': 'release'}

Plug 'editorconfig/editorconfig-vim'

" fuzzy file/line/text searching, use leading ' (single quote) to do exact searches
let g:fzf_preview_window='up:60%'
Plug '/usr/local/opt/fzf'
Plug 'junegunn/fzf.vim'

" color theme
Plug 'gruvbox-community/gruvbox'

" :GV git viewer
Plug 'junegunn/gv.vim'

Plug 'kevinhwang91/rnvimr'
let g:rnvimr_enable_ex = 1
let g:rnvimr_enable_bw = 1
let g:rnvimr_enable_picker = 1

" turns mouse on, focus, cursor shape, and paste support for terminal mode
Plug 'wincent/terminus'

" visual undo tree
let g:undotree_SetFocusWhenToggle = 1
let g:undotree_CustomUndotreeCmd  = 'topleft vertical 35 new'
let g:undotree_CustomDiffpanelCmd = 'botright 15 new'
Plug 'mbbill/undotree'
nnoremap <leader>u :UndotreeToggle<CR>

" nicer status bar
" let g:airline#extensions#tabline#enabled = 1
" let g:airline#extensions#tabline#fnamecollapse = 0
let g:airline_powerline_fonts = 1
let g:airline_section_c = '%<%F%m %#__accent_red#%{airline#util#wrap(airline#parts#readonly(),0)}%#__restore__#' " show full filepaths
Plug 'vim-airline/vim-airline'

" let me close buffer without closing window
Plug 'moll/vim-bbye'
function! DeleteBuffer()
    if &buftype ==# 'terminal'
        Bwipeout!
    else
        Bwipeout
    endif
endfunction
nnoremap <leader>d :call DeleteBuffer()<CR>

" gc helper
Plug 'tpope/vim-commentary'

" demandware syntax
Plug 'clavery/vim-dwre'

" :Git command
Plug 'tpope/vim-fugitive'

" repeat extra stuff with .
Plug 'tpope/vim-repeat'

" csiw '
Plug 'tpope/vim-surround'

" allow ctrl+jkl; to navigate both vim and tmux together
let g:tmux_navigator_save_on_switch = 1
Plug 'christoomey/vim-tmux-navigator'

Plug 'tpope/vim-unimpaired'

" allow <leader>ww to mark and swap windows
let g:windowswap_map_keys = 0 "prevent default bindings
Plug 'wesQ3/vim-windowswap'
nnoremap <leader>ww :call WindowSwap#EasyWindowSwap()<CR>

call plug#end()

" ============================================================================
" GENERAL VIM SETTINGS
" ============================================================================
" let vim overwrite/use system clipboard
" if has("clipboard") " yank to clipboard
"   set clipboard=unnamed " copy to the system clipboard
"   if has("unnamedplus") " X11 support
"     set clipboard+=unnamedplus
"   endif
" endif
" this is way faster, unnamed started causing crazy lag on dd
vnoremap y "+y
nnoremap y "+y

set history=10000          " undo history to x items

set nomodeline             " don't read first few lines of files for ex commands

if !exists("g:loaded_matchit") && findfile("plugin/matchit.vim", &runtimepath) ==# ""
  runtime! macros/matchit.vim " matchit responsible for % matching
endif

set shortmess=I           " don't show startup message, shorten prompt on long messages to avoid Enter
set cmdheight=2
set updatetime=300         " time until swap file writes, additionally how long until CursorHold fires
set signcolumn=no         " never show column to left of line number

set timeoutlen=1000        " wait 1000 ms for mapping delay
set ttimeoutlen=10         " wait 10 ms for keycodes

set nrformats-=octal       " treat leading 007 as not octal numbers for increment <C-a> and decrement <C-x>

set viminfo+=!             " persist upper case variables and marks 'A to viminfo

set inccommand=nosplit     " :s/ will show changes live in buffer

" ============================================================================
" WINDOW
" ============================================================================
set title             " change window title to always show full file path

set display+=lastline " always show whole last line in document instead of @ symbol

set laststatus=2      " window always has status line

set number            " always show current line number
"set relativenumber    " show number relative to current line

set report=0          " always show 'x lines yanked'

set showcmd           " show current leader command in bottom right

if exists(':AirlineRefresh')
  set noshowmode      " airline already shows the mode
else
  set ruler             " always show cursor position in bottom right, only used when airline is off
endif

set splitbelow        " default vertical splits to be down
set splitright        " default horizontal splits to be right

" open all :h in new tab, allow tab to close with q
function! s:helptab()
  if &buftype == 'help'
    wincmd T
    nnoremap <buffer> q :q<CR>
  endif
endfunction
augroup help_tab
  autocmd!
  autocmd BufEnter *.txt call s:helptab()
augroup END

" Set all buffers to hide whether dirty or not (don't require saving to switch buffers)
set hidden

" ============================================================================
" TEXT DISPLAY AND COLORS
" ============================================================================
" allows for coloring based on syntax words
syntax on

" allow colors to work inside tmux
let &t_8f = "\<Esc>[38;2;%lu;%lu;%lum"
let &t_8b = "\<Esc>[48;2;%lu;%lu;%lum"
set termguicolors
set background=dark " tells VIM colorscheme has dark background

let g:gruvbox_italic=1
let g:gruvbox_contrast_dark='hard'
colorscheme gruvbox

" transparency
hi! Normal ctermbg=NONE guibg=NONE
hi! NonText ctermbg=NONE guibg=NONE guifg=NONE ctermfg=NONE

"use a taller pipe and slash symbol
set fillchars=vert:│,stl:\ ,stlnc:\

" nicer symbols for whitespace characters
set list
set listchars=tab:→\ ,trail:·,extends:↷,precedes:↶,nbsp:·
set showbreak=↪\

set showmatch " highlights matching {([
set matchtime=3 "300ms to show paren match

" show horizontal highlight on active line in active window
augroup CursorLineOnlyInActiveWindow
  autocmd!
  autocmd VimEnter,WinEnter,BufWinEnter * setlocal cursorline
  autocmd WinLeave * setlocal nocursorline
augroup END

set ttyfast " faster redrawing
set lazyredraw " dont redraw during macro
set regexpengine=1 " use old engine for speed

set nowrap
" set whichwrap=b,s " allow backspace and space to traverse wrapped lines
" set formatoptions+=1 " don't break on one character word
" set wrap linebreak nolist " wrap lines only at linebreak
" if has('patch-7.4.338')
"   set breakindent
"   set breakindentopt=sbr
" endif

set diffopt=filler,internal,algorithm:histogram,indent-heuristic

" ============================================================================
" COMPLETION
" ============================================================================
set complete-=i                                            " do not scan included files, .tags is more performant
set completeopt=noinsert,menuone,noselect                  " Autocomplete behavior, always show menu, don't
set infercase                                              " case sensitive ins-completion when uppercase present
set pumheight=10                                           " limit popup result height
set wildignore+=*swp,*.class,*.pyc,*.png,*.jpg,*.gif,*.zip " ignore these files
set wildignore+=*/tmp/*,*.o,*.obj,*.so                     " Unix
set wildmenu                                               " cmd (:) completion
set wildmode=list:longest,full                             " bash like behavior

filetype plugin indent on " turn on filetype analysis allows file specific plugins, indentation, and completion

" Use tab for trigger completion with characters ahead and navigate.
" Use command ':verbose imap <tab>' to make sure tab is not mapped by other plugin.
inoremap <silent><expr> <TAB>
      \ pumvisible() ? "\<C-n>" :
      \ <SID>check_back_space() ? "\<TAB>" :
      \ coc#refresh()
inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"

function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

" <CR> selects currently selected item
" <CR> also selects first item in dropdown if none are selected
" otherwise <CR> simply acts like <CR> and adds a carriage return
inoremap <expr> <CR> complete_info()["selected"] != "-1" ? "\<C-y>" : pumvisible() ? "\<C-n>\<C-y>" : "<CR>"

" close preview window when completion done
autocmd! CompleteDone * if pumvisible() == 0 | pclose | endif

" ============================================================================
" SEARCHING
" ============================================================================
set hlsearch    " show highlighed searches by default
set ignorecase  " case insensitive search
if has('reltime')
  set incsearch " allow incremental search per letter typed
endif
set smartcase   " case sensitive search when uppercase present

if executable('rg')
  "use ripgrep for :grep searches
  "todo use fancy fzf streaming instead
  set grepprg=rg\ --no-heading\ --vimgrep
  set grepformat=%f:%l:%c:%m
endif

" don't jump to next result when using *, // will access reg with value
nnoremap * :let @/ = '\<'.expand('<cword>').'\>'\|set hlsearch<C-m>

" ============================================================================
" INDENTATION
" ============================================================================
set autoindent   " copies indentation from previous line
set expandtab    " tab inserts x spaces in insert mode
set shiftwidth=2 " tab inserts x spaces when using >>
set smarttab     " let tab behave like >> or <<
set tabstop=2    " tab counts as x spaces when reading

" ============================================================================
" FILE SAVING AND READING
" ============================================================================
set autoread " reread files modified outside of vim, https://unix.stackexchange.com/a/383044
augroup auto_read
  autocmd!
  autocmd CursorHold,CursorHoldI * :checktime
  autocmd FocusGained,BufEnter * :checktime
augroup END

set backup " put all backup/undo/swap files into ~/.vim
if !isdirectory($HOME.'/.vim')
  call mkdir($HOME.'/.vim', '', 0770)
endif
if !isdirectory($HOME.'/.vim/_backup')
  call mkdir($HOME.'/.vim/_backup', '', 0700)
endif
if !isdirectory($HOME.'/.vim/_swp')
  call mkdir($HOME.'/.vim/_swp', '', 0700)
endif
set backupdir=~/.vim/_backup//
set directory=~/.vim/_swp//

if has('persistent_undo')
  if !isdirectory($HOME.'/.vim/_undo')
    call mkdir($HOME.'/.vim/_undo', '', 0700)
  endif
  set undodir=~/.vim/_undo
  set undofile
  set undolevels=1000 "number of changes to store
  set undoreload=10000 "number of lines to undo
endif

set sessionoptions-=options "don't store options that will just be set by vimrc anyway

augroup savecursorposition
  autocmd!
  " When editing a file, always jump to the last known cursor position.
  autocmd BufReadPost *
        \ if line("'\"") >= 1 && line("'\"") <= line("$") && &ft !~# 'commit'
        \ |   exe "normal! g`\""
        \ | endif
augroup END

" automatically close location list when buffer closes
augroup CloseLoclistWindowGroup
  autocmd!
  autocmd QuitPre * if empty(&buftype) | lclose | endif
augroup END

" quicksave current buffer with double space
noremap <leader><space> :wa<CR>

" ============================================================================
" EDITING
" ============================================================================

" allow backspace to go backwards normally
set backspace=indent,eol,start

" do not automatically comment next line after hitting enter
augroup comment
  autocmd!
  autocmd BufNewFile,BufRead * setlocal formatoptions-=cro
augroup END

set scrolloff=5
set sidescroll=1
set sidescrolloff=20

" ============================================================================
" REMAPS - FZF
" ============================================================================
" fuzzy search open buffer names
augroup fzf
  autocmd!

  ":buf fuzzy navigation
  nnoremap <leader>b :Buffers<CR>

  " fuzzy search file names using current working directory (:PWD)
  nnoremap <leader>f :Files!<CR>
  nnoremap <leader>F :Files<CR>

  " fuzzy search text in open buffers
  nnoremap <leader>l :Lines!<CR>

  " fuzzy search text without restarting ripgrep on keystroke using working directory (:PWD)
  nnoremap <leader>p :Rg!<space>
  " fuzzy search text without restarting ripgrep on keystroke using working directory (:PWD) and starting with word under cursor
  nnoremap <leader>P :Rg! <C-r><C-w><CR>

  " function! s:p(bang, ...)
  "   let preview_window = get(g:, 'fzf_preview_window', a:bang && &columns >= 80 || &columns >= 120 ? 'right': '')
  "   if len(preview_window)
  "     return call('fzf#vim#with_preview', add(copy(a:000), preview_window))
  "   endif
  "   return {}
  " endfunction
  " command! -bang -nargs=* Rg call fzf#vim#grep('rg --column --line-number --no-heading --color=always --smart-case -- '.shellescape(<q-args>), 1, s:p(<bang>0), <bang>0)
augroup END

" ============================================================================
" REMAPS - BUFFERS
" ============================================================================

" easier navigation for buffers
augroup termIgnore
    autocmd!
    " if has('nvim')
    "   autocmd TermOpen * setlocal nobuflisted
    " else
    "   autocmd TerminalOpen * setlocal nobuflisted
    " endif
    autocmd FileType qf setlocal nobuflisted

    " exit qf with q
    autocmd FileType qf nnoremap <buffer> q :q<CR>

    " always make quickfix window be on the bottom
    au FileType qf wincmd J
augroup END

" ============================================================================
" REMAPS - EDITING AND NAVIGATION
" ============================================================================

" allow double escape to clear highlighting from / (:set hlsearch) (single escape broken in wsl)
nnoremap <silent> <esc><esc> :nohl<CR>

" fix control u and control w during insert mode to start new undo path
" deletes last line in insert mode
inoremap <C-u> <C-g>u<C-u>

" deletes last word in insert mode
inoremap <C-w> <C-g>u<C-w>

" make Y behave like C and D
nnoremap Y "+y$

" easier navigation of wrapped lines
vmap j gj
vmap k gk
nmap j gj
nmap k gk

"visual shifting does not exit visual mode
vnoremap < <gv
vnoremap > >gv

" paste will not replace register with pasted over text
xnoremap <expr> p 'pgv"'.v:register.'y`>'

" first remap for <leader>d exits terminal mode
" second remap for 'esc' exits insert mode
tnoremap <silent> <leader>d <C-\><C-n>:q!<CR>
augroup escinterminalbuffers
  autocmd!

  autocmd TermOpen * tnoremap <buffer> <esc> <C-\><C-n>
  autocmd FileType fzf tunmap <buffer> <esc>
augroup END

" vim-tmux-navigator works in terminal mode
if exists(':TmuxNavigateLeft')
  tnoremap <silent> <C-h> <C-\><C-n>:TmuxNavigateLeft<CR>
  tnoremap <silent> <C-j> <C-\><C-n>:TmuxNavigateDown<CR>
  tnoremap <silent> <C-k> <C-\><C-n>:TmuxNavigateUp<CR>
  tnoremap <silent> <C-l> <C-\><C-n>:TmuxNavigateRight<CR>
else
  tnoremap <silent> <C-h> <C-\><C-n><C-w><C-h><CR>
  tnoremap <silent> <C-j> <C-\><C-n><C-w><C-j><CR>
  tnoremap <silent> <C-k> <C-\><C-n><C-w><C-k><CR>
  tnoremap <silent> <C-l> <C-\><C-n><C-w><C-l><CR>
endif

nnoremap <C-j> <C-w><C-j>
nnoremap <C-k> <C-w><C-k>
nnoremap <C-l> <C-w><C-l>
nnoremap <C-h> <C-w><C-h>

" ============================================================================
" REMAPS - OTHER
" ============================================================================
" edit vim config
noremap <leader>vc :e ~/.config/nvim/init.vim<CR>

" source vim config
noremap <leader>vs :source ~/.config/nvim/init.vim<CR>

" :W sudo saves the file
command! W w !sudo tee % > /dev/null

" Don't use Ex mode, use Q for formatting.
map Q gq

augroup filemanager
  autocmd!

  " open ranger in exact directory of file under cursor
  " gw goes to cwd
  nnoremap - :RnvimrToggle<CR>
  tnoremap - <C-\><C-n>:RnvimrToggle<CR>
  tnoremap _ <C-\><C-n>:RnvimrResize<CR>
augroup END

" ============================================================================
" FUNCTIONS
" ============================================================================

" Zoom / Restore window.
function! s:ZoomToggle() abort
  if exists('t:zoomed') && t:zoomed
    execute t:zoom_winrestcmd
    let t:zoomed = 0
  else
    let t:zoom_winrestcmd = winrestcmd()
    resize
    vertical resize
    let t:zoomed = 1
  endif
endfunction
command! ZoomToggle call s:ZoomToggle()
nnoremap <silent> <leader>z :ZoomToggle<CR>

" ============================================================================
" LSP
" ============================================================================

lua <<EOF
  require'nvim-treesitter.configs'.setup {
    highlight = {
      enable = true
    }
  }
EOF

