" put this line first in ~/.vimrc
set nocompatible | filetype indent plugin on | syn on

fun! EnsureVamIsOnDisk(plugin_root_dir)
  " windows users may want to use http://mawercer.de/~marc/vam/index.php
  " to fetch VAM, VAM-known-repositories and the listed plugins
  " without having to install curl, 7-zip and git tools first
  " -> BUG [4] (git-less installation)
  let vam_autoload_dir = a:plugin_root_dir.'/vim-addon-manager/autoload'
  if isdirectory(vam_autoload_dir)
    return 1
  else
    if 1 == confirm("Clone VAM into ".a:plugin_root_dir."?","&Y\n&N")
      " I'm sorry having to add this reminder. Eventually it'll pay off.
      call confirm("Remind yourself that most plugins ship with ".
                  \"documentation (README*, doc/*.txt). It is your ".
                  \"first source of knowledge. If you can't find ".
                  \"the info you're looking for in reasonable ".
                  \"time ask maintainers to improve documentation")
      call mkdir(a:plugin_root_dir, 'p')
      execute '!git clone --depth=1 git://github.com/MarcWeber/vim-addon-manager '.
                  \       shellescape(a:plugin_root_dir, 1).'/vim-addon-manager'
      " VAM runs helptags automatically when you install or update 
      " plugins
      exec 'helptags '.fnameescape(a:plugin_root_dir.'/vim-addon-manager/doc')
    endif
    return isdirectory(vam_autoload_dir)
  endif
endfun

fun! SetupVAM()
  " Set advanced options like this:
  " let g:vim_addon_manager = {}
  " let g:vim_addon_manager.key = value
  "     Pipe all output into a buffer which gets written to disk
  " let g:vim_addon_manager.log_to_buf =1

  " Example: drop git sources unless git is in PATH. Same plugins can
  " be installed from www.vim.org. Lookup MergeSources to get more control
  " let g:vim_addon_manager.drop_git_sources = !executable('git')
  " let g:vim_addon_manager.debug_activation = 1

  " VAM install location:
  let c = get(g:, 'vim_addon_manager', {})
  let g:vim_addon_manager = c
  let c.plugin_root_dir = expand('$HOME/.vim/vim-addons', 1)
  if !EnsureVamIsOnDisk(c.plugin_root_dir)
    echohl ErrorMsg | echomsg "No VAM found!" | echohl NONE
    return
  endif
  let &rtp.=(empty(&rtp)?'':',').c.plugin_root_dir.'/vim-addon-manager'

  " Tell VAM which plugins to fetch & load:
 
 
  call vam#ActivateAddons([
              \ 'github:fholgado/minibufexpl.vim',
              \ 'github:scrooloose/nerdcommenter',
              \ 'github:scrooloose/nerdtree',
              \ 'github:vim-scripts/pytest.vim',
              \ 'github:vim-scripts/taglist.vim',
              \ 'github:garbas/vim-snipmate',
              \ 'github:kien/ctrlp.vim',
              \ 'vim-airline',
              \ 'github:davidhalter/jedi-vim', 
              \ 'github:klen/python-mode',
              \ 'github:mileszs/ack.vim',
              \ 'github:SirVer/ultisnips',
              \ 'github:Valloric/YouCompleteMe',
              \ 'github:christoomey/vim-tmux-navigator',
              \ ], {'auto_install' : 1})
 
              "\ 'powerline',
              "\ 'github:Raimondi/delimitMate',
              "\ 'github:heavenshell/vim-pydocstring',
              "\ 'github:Yggdroot/indentLine',
 
 
  " sample: call vam#ActivateAddons(['pluginA','pluginB', ...], {'auto_install' : 0})
  " Also See "plugins-per-line" below

  " Addons are put into plugin_root_dir/plugin-name directory
  " unless those directories exist. Then they are activated.
  " Activating means adding addon dirs to rtp and do some additional
  " magic

  " How to find addon names?
  " - look up source from pool
  " - (<c-x><c-p> complete plugin names):
  " You can use name rewritings to point to sources:
  "    ..ActivateAddons(["github:foo", .. => github://foo/vim-addon-foo
  "    ..ActivateAddons(["github:user/repo", .. => github://user/repo
  " Also see section "2.2. names of addons and addon sources" in VAM's documentation
endfun
call SetupVAM()
" experimental [E1]: load plugins lazily depending on filetype, See
" NOTES
" experimental [E2]: run after gui has been started (gvim) [3]
" option1:  au VimEnter * call SetupVAM()
" option2:  au GUIEnter * call SetupVAM()
" See BUGS sections below [*]
" Vim 7.0 users see BUGS section [3]

colorscheme slate
"remap mapleader to ,
let mapleader = ","

"map <silent> <C-Up> :wincmd k<CR>
"map <silent> <C-Down> :wincmd j<CR>
"map <silent> <C-Left> :wincmd h<CR>
"map <silent> <C-Right> :wincmd l<CR>

"map <silent> <C-k> :wincmd k<CR>
"map <silent> <C-j> :wincmd j<CR>
"map <silent> <C-h> :wincmd h<CR>
"map <silent> <C-l> :wincmd l<CR>

"rotate through buffers
map <c-tab> :bn<cr>
map <c-s-tab> :bp<cr>

map <c-PageDown> :bn<cr>
map <c-PageUp> :bp<cr>

"close buffers without closing splitted windows
map <leader>w :bp<bar>bd#<cr>

"find and replace
map <leader>h :promptrepl<cr>

"use system clipboard
set clipboard=unnamedplus

syntax on
filetype on
filetype plugin indent on
let g:pyflakes_use_quickfix = 1
let g:pep8_map='<leader>p'

let g:pymode_lint = 1
let g:pymode_lint_unmodified = 1
let g:pymode_lint_checkers = ['pyflakes', 'pep8']
let g:pymode_lint_ignore = "E501,C901"
let g:pymode_folding =0
let g:pymode_utils_whitespaces = 1
let g:pymode_rope = 0 " DEACTIVATE ROPE, with jedi activated
let g:pymode_rope_completion = 0
let g:pymode_run = 0

let g:jedi#use_tabs_not_buffers = 0
let g:jedi#rename_command = "<leader>r"

let g:syntastic_mode_map = { 'mode': 'active',
                            \ 'active_filetypes': ['ruby', 'php', 'python', 'c++'],
                            \ 'passive_filetypes': [] }
""some code completion
"au FileType python set omnifunc=pythoncomplete#Complete

"let g:tex_flavor='latex'

"let g:miniBufExplMapWindowNavVim = 1 
"let g:miniBufExplMapWindowNavArrows = 1 
"let g:miniBufExplMapCTabSwitchBufs = 1 
"let g:miniBufExplModSelTarget = 1 

"set completeopt=menuone,longest,preview

"map <leader>j :RopeGotoDefinition<CR>
"map <C-c>r :RopeRename<CR>
nmap <leader>a <Esc>:Ack! 
map <leader>n :NERDTreeToggle<CR>
map <leader>t : TlistToggle<CR>

let g:ctrlp_extensions = ['tag', 'buffertag', 'line']
map <c-t> :CtrlPTag<CR>

let Tlist_Auto_Highlight_Tag = 0
let Tlist_Use_Right_Window = 1
let Tlist_Show_One_File = 1

autocmd FileType python setlocal completeopt-=preview

set wildignore+=*.o,*.obj,.git,*.pyc

set wildmenu
set wildmode=longest:full,full

set nocompatible
set expandtab
set tabstop=4
set shiftwidth=4
set sts=4
set smartindent
set autoindent
set selectmode=mouse
set showcmd
set number
set relativenumber
set title
set ruler

"smoother look n feel
set ttyfast

"better searching
set ignorecase
set smartcase
set incsearch

"backup to one dir
set backupdir=~/.vim/tmp,.
set directory=~/.vim/tmp,.

" při dosažení konce řádku skok na další
set whichwrap+=<,>,[,]

"chování backspace jako ve zbytku systému
set backspace=indent,eol,start

"nastaveni zalamovani -wrap
set wrap
set linebreak
set nolist
set textwidth=0
set wrapmargin=0

"kratka ctrl-backspace smaze cele slovo
:imap <C-BS> <C-W>
:imap <C-Del> <C-O>dw

"vždy zobraz statusline
set laststatus=2
set encoding=UTF-8
set noshowmode " Hide the default mode text (e.g. -- INSERT -- below the statusline)

" show partial lines
set display=lastline
set autoread " automatically update rewritten file

let g:ycm_global_ycm_extra_conf = '/home/psebek/.vim/vim-addons/github-Valloric-YouCompleteMe/cpp/ycm/.ycm_extra_conf.py' 

if has('gui_running')
    set guifont=Monospace\ 9
endif

