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

" Plug 'neoclide/coc.nvim', {'branch': 'release'} " autocompletion that I would like to replace with something simpler but works too damn well
Plug 'editorconfig/editorconfig-vim' " use .editorconfig files per project
Plug '/usr/local/opt/fzf' " use local fzf installation
Plug 'junegunn/fzf.vim' " fuzzy finder
Plug 'gruvbox-community/gruvbox' " colorscheme
Plug 'junegunn/gv.vim' " git history viewer
Plug 'kevinhwang91/rnvimr' " ranger file viewer in a popup
Plug 'mbbill/undotree' " visual undo using vim history
Plug 'vim-airline/vim-airline' " fancy status line
Plug 'moll/vim-bbye' " buffer removal while leaving windows in place
Plug 'tpope/vim-commentary' " better commenting with gc and gcu
Plug 'clavery/vim-dwre' " isml syntax
Plug 'tpope/vim-fugitive' " git plugin
Plug 'pangloss/vim-javascript' " better javascript highlighting
Plug 'tpope/vim-repeat' " . repeat
Plug 'tpope/vim-surround' " ysiw
Plug 'christoomey/vim-tmux-navigator' " navigate between vim and tmux
Plug 'tpope/vim-unimpaired' " [q and ]q
Plug 'wesQ3/vim-windowswap' " swap buffers between windows

call plug#end()

" ============================================================================
" PLUGIN SETTINGS
" ============================================================================

" fzf.vim
let g:fzf_preview_window='up:60%'

" gruvbox
let g:gruvbox_invert_selection = 0
let g:gruvbox_italic=1
let g:gruvbox_contrast_dark='hard'
colorscheme gruvbox
" transparent nvim background
hi! Normal ctermbg=NONE guibg=NONE
hi! NonText ctermbg=NONE guibg=NONE guifg=NONE ctermfg=NONE

" rnvimr
let g:rnvimr_enable_ex = 1
let g:rnvimr_enable_bw = 1
let g:rnvimr_enable_picker = 1
let g:rnvimr_presets = [
  \ {'width': 0.900, 'height': 0.900},
  \ ]

" undotree
let g:undotree_SetFocusWhenToggle = 1
let g:undotree_CustomUndotreeCmd  = 'topleft vertical 35 new'
let g:undotree_CustomDiffpanelCmd = 'botright 15 new'

" vim-airline
let g:airline_powerline_fonts = 1
let g:airline_section_c = '%<%F%m %#__accent_red#%{airline#util#wrap(airline#parts#readonly(),0)}%#__restore__#' " show full filepaths

" vim-tmux-navigator
let g:tmux_navigator_save_on_switch = 1

" vim-windowswap
let g:windowswap_map_keys = 0 "prevent default bindings

" ============================================================================
" GENERAL NVIM SETTINGS
" ============================================================================

set completeopt=noinsert,menuone,noselect " Autocomplete behavior, always show menu, don't
set cmdheight=2 " always show 2 lines for cmd status on bottom of screen
set diffopt=filler,internal,algorithm:histogram,indent-heuristic " better vim diffing
set expandtab " tab inserts x spaces in insert mode
set formatoptions-=ro " do not automatically comment next line after hitting enter
if executable('rg')
  "use ripgrep for :grep searches
  "todo use fancy fzf streaming instead
  set grepprg=rg\ --no-heading\ --vimgrep
  set grepformat=%f:%l:%c:%m
endif
set hidden " don't require saving to switch buffers
set ignorecase " case insensitive search
set inccommand=nosplit     " :s/ will show changes live in buffer
set infercase " case sensitive ins-completion when uppercase present
" set lazyredraw " dont redraw during macro
set list " nicer symbols for whitespace characters
set listchars=tab:→\ ,trail:·,extends:↷,precedes:↶,nbsp:·
set matchtime=3 "300ms to show paren match
set nomodeline " don't read first few lines of files for ex commands
set nowrap " can't stand wrapping lines
set number " always show current line number
set pumheight=10 " limit popup result height
" set regexpengine=1 " use old engine for speed
set report=0 " always show 'x lines yanked'
set scrolloff=5 " scroll with 5 vertial lines left at bottom of screen
set sidescrolloff=20 " scroll with 20 columns left on side of screen
set signcolumn=no " never show column to left of line number
set shiftwidth=2 " tab inserts x spaces when using >>
set showbreak=↪\
set smartcase " case sensitive search when uppercase present
set splitbelow " default vertical splits to be down
set splitright " default horizontal splits to be right
set tabstop=2 " tab counts as x spaces when reading
set termguicolors " enable 24 bit colors in TUI
set timeoutlen=1000 " wait 1000 ms for mapping delay
set title " change window title to always show full file path
set updatetime=500 " time until swap file writes, additionally how long until CursorHold fires
set wildignore+=*swp,*.class,*.pyc,*.png,*.jpg,*.gif,*.zip " ignore these files
set wildignore+=*/tmp/*,*.o,*.obj,*.so " Unix
set wildmode=list:longest,full " bash like behavior

" storing here, apparently I had these settings with :set wrap
" set whichwrap=b,s " allow backspace and space to traverse wrapped lines
" set formatoptions+=1 " don't break on one character word
" set wrap linebreak nolist " wrap lines only at linebreak
" set breakindent
" set breakindentopt=sbr

" ============================================================================
" PLUGIN REMAPS AND CUSTOM FUNCTIONS
" ============================================================================

" coc.nvim
" Use tab for trigger completion with characters ahead and navigate.
" Use command ':verbose imap <tab>' to make sure tab is not mapped by other plugin.
" function! s:check_back_space() abort
"   let col = col('.') - 1
"   return !col || getline('.')[col - 1]  =~# '\s'
" endfunction
" inoremap <silent><expr> <TAB>
"       \ pumvisible() ? "\<C-n>" :
"       \ <SID>check_back_space() ? "\<TAB>" :
"       \ coc#refresh()

" fzf.vim
":buf fuzzy navigation
nnoremap <leader>b :Buffers<CR>
" fuzzy search file names using current working directory (:PWD)
nnoremap <leader>f :Files!<CR>
nnoremap <leader>F :Files<CR>
" fuzzy search text in open buffers
nnoremap <leader>l :Lines!<CR>
nnoremap <leader>L :Lines<CR>
" fuzzy search text without restarting ripgrep on keystroke using working directory (:PWD)
nnoremap <leader>p :Rg!<space>
" fuzzy search text without restarting ripgrep on keystroke using working directory (:PWD) and starting with word under cursor
nnoremap <leader>P :Rg! <C-r><C-w><CR>

" gv.vim
" show history of entire repo
nnoremap <leader>gl :GV<CR>
" show history of current buffer
nnoremap <leader>gv :GV!<CR>

" rnvimr
nnoremap - :RnvimrToggle<CR>

" undotree
nnoremap <leader>u :UndotreeToggle<CR>

" vim-bbye
function! DeleteBuffer()
    if &buftype ==# 'terminal'
        Bwipeout!
    else
        Bwipeout
    endif
endfunction
nnoremap <leader>d :call DeleteBuffer()<CR>

" vim-tmux-navigator
" if exists(':TmuxNavigateLeft')
"   " vim-tmux-navigator works in terminal mode
"   tnoremap <silent> <C-h> <C-\><C-n>:TmuxNavigateLeft<CR>
"   tnoremap <silent> <C-j> <C-\><C-n>:TmuxNavigateDown<CR>
"   tnoremap <silent> <C-k> <C-\><C-n>:TmuxNavigateUp<CR>
"   tnoremap <silent> <C-l> <C-\><C-n>:TmuxNavigateRight<CR>
" endif
" if !exists(':TmuxNavigateLeft')
"   tnoremap <silent> <C-h> <C-\><C-n><C-w><C-h><CR>
"   tnoremap <silent> <C-j> <C-\><C-n><C-w><C-j><CR>
"   tnoremap <silent> <C-k> <C-\><C-n><C-w><C-k><CR>
"   tnoremap <silent> <C-l> <C-\><C-n><C-w><C-l><CR>
" endif

" vim-windowswap
nnoremap <leader>ww :call WindowSwap#EasyWindowSwap()<CR>

" ============================================================================
" VIM REMAPS
" ============================================================================
" space as leader
map <space> <leader>

" let vim overwrite/use system clipboard, using clipboard+=unnamedplus started causing crazy lag on dd
vnoremap y "+y
nnoremap y "+y

" don't jump to next result when using *, // will access reg with value
nnoremap * :let @/ = '\<'.expand('<cword>').'\>'\|set hlsearch<C-m>

" shifttab goes up pum suggestions, otherwise back 1 character
inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"
" <CR> selects currently selected item
" <CR> also selects first item in dropdown if none are selected
" otherwise <CR> simply acts like <CR> and adds a carriage return
inoremap <expr> <CR> complete_info()["selected"] != "-1" ? "\<C-y>" : pumvisible() ? "\<C-n>\<C-y>" : "<CR>"

" quicksave all buffers with double space
noremap <leader><space> :wa<CR>

" allow double escape to clear highlighting from / (:set hlsearch)
nnoremap <silent> <esc><esc> :nohl<CR>

" fix control u and control w during insert mode to start new undo path
" deletes to 0 line in insert mode
inoremap <C-u> <C-g>u<C-u>
" deletes previous word in insert mode
inoremap <C-w> <C-g>u<C-w>

" make Y behave like C and D
nnoremap Y "+y$

" easier navigation of wrapped lines
vnoremap <expr> j v:count == 0 ? 'gj' : 'j'
vnoremap <expr> k v:count == 0 ? 'gk' : 'k'
nnoremap <expr> j v:count == 0 ? 'gj' : 'j'
nnoremap <expr> k v:count == 0 ? 'gk' : 'k'

"visual shifting does not exit visual mode
vnoremap < <gv
vnoremap > >gv

" paste will not replace register with pasted over text
xnoremap <expr> p 'pgv"'.v:register.'y`>'

" edit vim config
noremap <leader>vc :e ~/.config/nvim/init.vim<CR>

" source vim config
noremap <leader>vs :source ~/.config/nvim/init.vim<CR>

" :W sudo saves the file
command! W w !sudo tee % > /dev/null

" Don't use Ex mode, use Q for formatting.
map Q gq

" navigate window splits with ctrl + hjkl
nnoremap <C-j> <C-w><C-j>
nnoremap <C-k> <C-w><C-k>
nnoremap <C-l> <C-w><C-l>
nnoremap <C-h> <C-w><C-h>

" closes terminal mode buffer
tnoremap <silent> <leader>d <C-\><C-n>:q!<CR>

" ============================================================================
" NVIM AUGROUPS WITH FUNCTIONS AND REMAPS
" ============================================================================
augroup auto_close_location_list_on_buffer_close
  autocmd!
  autocmd QuitPre * if empty(&buftype) | lclose | endif
augroup END

augroup auto_read_force_checktime
  autocmd!
  autocmd CursorHold,CursorHoldI * :checktime
  autocmd FocusGained,BufEnter * :checktime
augroup END

augroup custom_zoom_toggle_command
  autocmd!
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
augroup END

augroup cursor_line_only_in_active_window
  autocmd!
  autocmd VimEnter,WinEnter,BufWinEnter * setlocal cursorline
  autocmd WinLeave * setlocal nocursorline
augroup END

augroup close_pum_when_completion_done
  autocmd!
  autocmd CompleteDone * if pumvisible() == 0 | pclose | endif
augroup END

" augroup esc_exist_insert_mode_in_terminal_buffer
"   autocmd!

"   " esc exits insert mode in terminal
"   autocmd TermOpen * tnoremap <buffer> <esc> <C-\><C-n>
"   autocmd FileType fzf tunmap <buffer> <esc>
" augroup END

augroup highlight_yanked_region_for_1_second
    autocmd!
    au TextYankPost * silent! lua vim.highlight.on_yank { higroup='IncSearch', timeout=1000 }
augroup END

augroup jump_to_last_location_on_file_load
  autocmd!
  autocmd BufReadPost *
        \ if line("'\"") >= 1 && line("'\"") <= line("$") && &ft !~# 'commit'
        \ |   exe "normal! g`\""
        \ | endif
augroup END

augroup open_help_in_new_tab_exit_with_q
  function! s:helptab()
    if &buftype == 'help'
      wincmd T
      nnoremap <buffer> q :q<CR>
    endif
  endfunction

  autocmd!
  autocmd BufEnter *.txt call s:helptab()
augroup END

augroup quickfix_hide_buff_always_below_and_exit_with_q
    autocmd!

    autocmd FileType qf setlocal nobuflisted " hide qf from :buffers
    " exit qf with q
    autocmd FileType qf nnoremap <buffer> q :q<CR>
    " always make quickfix window be on the bottom
    au FileType qf wincmd J
augroup END

" ============================================================================
" FILE SAVING AND READING
" ============================================================================
if !isdirectory($HOME.'/.config')
  call mkdir($HOME.'/.config', '', 0770)
endif
if !isdirectory($HOME.'/.config/nvim')
  call mkdir($HOME.'/.config/nvim', '', 0770)
endif
if !isdirectory($HOME.'/.config/nvim/_backup')
  call mkdir($HOME.'/.config/nvim/_backup', '', 0700)
endif
if !isdirectory($HOME.'/.config/nvim/_swp')
  call mkdir($HOME.'/.config/nvim/_swp', '', 0700)
endif
set backup " put all backup/undo/swap files into ~/.config/nvim
set backupdir=~/.config/nvim/_backup//
set directory=~/.config/nvim/_swp//

if has('persistent_undo')
  if !isdirectory($HOME.'/.config/nvim/_undo')
    call mkdir($HOME.'/.config/nvim/_undo', '', 0700)
  endif
  set undodir=~/.config/nvim/_undo
  set undofile
  set undolevels=1000 "number of changes to store
  set undoreload=10000 "number of lines to undo
endif

