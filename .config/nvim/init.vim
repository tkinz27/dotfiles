""""""""""""""""""""""""""""""""""""""""""""""""
" Generic setup
""""""""""""""""""""""""""""""""""""""""""""""""
filetype plugin indent on

let mapleader = ","

"""""""""""""""""""""""""""""""
" => VIM user interface
"""""""""""""""""""""""""""""""
" Turn on the Wild menu
set wildmode=longest:full,full
set wildmenu
" Ignore compiled files
set wildignore=*.o,*~,*.pyc,*/tmp/*,*.zip
" Always show current position
set ruler
" When searching try to be smart about cases
set smartcase
" Highlight search results
set hlsearch
" Find words as typing out search
set incsearch
" Start scrolling before cursor hits top/bottom
set scrolloff=5
" Number of lines to jump when scrolling off screen
" -# = percentage
set scrolljump=-10

" Set the paste toggle
map <F10> :set paste<cr>
map <F11> :set nopaste<cr>
imap <F10> <C-O>:set paste<CR>
imap <F11> <nop>
set pastetoggle=<F11>

set diffopt+=vertical

" Quick funtion that will
" highlight over 80 columns
" autocmd FileType cpp :autocmd! BufWritePre * :match ErrorMsg '\%>80v.\+'

" Use Unix as the standard file type
set ffs=unix,mac,dos

""""""""""""""""""""""""""""
" => Tags
""""""""""""""""""""""""""""
" setup tags
set tags=./.tags;/

""""""""""""""""""""""""""""
" => Files, backups and undo
""""""""""""""""""""""""""""
" Turn backup off, since most stuff is in SVN, git etc.
set nobackup
set nowb
set noswapfile

" Echo the full path of file being edited
nnoremap <leader>path :echo expand('%:p')<cr>

" Source and Edit nvim/init
nnoremap <leader>src :source ~/.config/nvim/init.vim<cr>
nnoremap <leader>erc :vsp ~/.config/nvim/init.vim<cr>

" Sudo save a file
nnoremap <leader>save :w !sudo dd of=%<cr>

""""""""""""""""""""""""""""
" => Text, tab and indent related
""""""""""""""""""""""""""""
" Use spaces instead of tabs
set expandtab

" Do not expand tab for Makefiles
autocmd FileType make set noexpandtab

" Be smart when using tabs
set smarttab

" 1 tab == 4 spaces
set shiftwidth=4
set tabstop=4

" Auto indent and wrap lines
set ai
set wrap

" Set the backspace to work as expected
set backspace=2

" Auto remove trailing whitespace on write
autocmd BufWritePre * :%s/\s\+$//e

"""""""""""""""""""""""""""""""""""
" Grep
"""""""""""""""""""""""""""""""""""
" nnoremap <leader>g :set operatorfunc=GrepOperator<cr>g@
" vnoremap <leader>g :<c-u>call GrepOperator(visualmode())<cr>
"
" function! GrepOperator(type)
"     if a:type ==# 'v'
"         normal! `<v`>y
"     elseif a:type ==# 'char'
"         normal! `[v`]y
"     else
"         return
"     endif
"
"     silent execute "grep! -nHIRs " . shellescape(@@) . " ."
"     copen
" endfunction

"""""""""""""""""""""""""""""""""""
" Window Management Stuff
"""""""""""""""""""""""""""""""""""
" Move to next or previous tab
nnoremap <leader>T :tabn<cr>
nnoremap <leader>P :tabp<cr>

" Increase and Decrease the width of a vertically split window
nnoremap <leader>< :vertical resize -10<cr>
nnoremap <leader>> :vertical resize +10<cr>

" Rotate panes
nnoremap <leader>wvh <C-w>t<C-w>K
nnoremap <leader>whv <C-w>t<C-w>H

set background=dark

"""""""""""""""""""""""""""""""""""
" Neovim terminal support
"""""""""""""""""""""""""""""""""""
if has('nvim')
    tnoremap <Esc> <C-\><C-n>
endif

""""""""""""""""""""""""""""""""""""""""""""""""
" vim-plug setup
""""""""""""""""""""""""""""""""""""""""""""""""

call plug#begin('~/.local/share/nvim/plugged')


" ##### APPEARENCE #####
set termguicolors

Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
let g:airline#extensions#tabline#enabled = 1
let g:airline_powerline_fonts = 1
let g:airline_theme='distinguished'

Plug 'joshdick/onedark.vim'

Plug 'Yggdroot/indentLine'
Plug 'machakann/vim-highlightedyank'

" ##### APPEARENCE #####

if has('nvim')
    set inccommand=nosplit
endif


" ##### TEXT MANIPULATION #####
Plug 'tpope/vim-surround'
Plug 'tpope/vim-commentary'
Plug 'tommcdo/vim-lion'

inoremap <C-a> <Esc>I
inoremap <C-e> <Esc>A

" ##### TEXT MANIPULATION #####

" ##### NAVIGATION #####
Plug 'airblade/vim-rooter'
Plug 'tpope/vim-repeat'

Plug 'scrooloose/nerdtree'
Plug 'ryanoasis/vim-devicons'
Plug 'Xuyuanp/nerdtree-git-plugin'
nnoremap <F6> :NERDTreeToggle<cr>

Plug 'junegunn/fzf', {'dir': '~/.fzf', 'do': './install --all'}
Plug 'junegunn/fzf.vim'
nmap <leader><tab> <plug>(fzf-maps-n)
xmap <leader><tab> <plug>(fzf-maps-x)
omap <leader><tab> <plug>(fzf-maps-o)

" Insert mode completion
imap <c-x><c-k> <plug>(fzf-complete-word)
imap <c-x><c-f> <plug>(fzf-complete-path)
imap <c-x><c-j> <plug>(fzf-complete-file-ag)
imap <c-x><c-l> <plug>(fzf-complete-line)

nnoremap <silent> <Leader>ff :Files<CR>
nnoremap <silent> <Leader>fc :Colors<CR>
nnoremap <silent> <Leader>fh :History<CR>
nnoremap <silent> <Leader>bb :Buffers<CR>
nnoremap <silent> <Leader>; :Commands<CR>
nnoremap <silent> <Leader>h :Helptags<CR>
nnoremap <silent> <Leader>cm :Commits<CR>
nnoremap <silent> <Leader>rg :Rg<CR>

let g:fzf_layout = {'window': {'width': 0.95, 'height': 0.5, 'border': 'rounded'}}

" Working with the quickfix list
map <C-n> :cnext<CR>
map <C-m> :cprevious<CR>
nnoremap <leader>a :cclose<CR>

" ##### NAVIGATION #####

" ##### LANGUAGES #####
Plug 'neovim/nvim-lsp'
Plug 'liuchengxu/vista.vim'

let g:vista_default_executive = 'nvim_lsp'
nnoremap <leader>tag :Vista!!<cr>

" ##### BAZEL #####
Plug 'google/vim-maktaba'
Plug 'bazelbuild/vim-bazel'

" ##### GOLANG #####
" Plug 'fatih/vim-go', {'for': ['go'], 'do': ':GoUpdateBinaries'}

" ##### RUST #####
" Plug 'rust-lang/rust.vim', {'for': ['rust']}
" let g:rustfmt_autosave = 1
" let g:rustfmt_command = "cargo fmt -- "
"
Plug 'elzr/vim-json', {'for': ['json']}
let g:vim_json_syntax_conceal = 0
autocmd FileType json setlocal foldmethod=syntax

Plug 'cstrahan/vim-capnp', {'for': ['capnp']}
Plug 'mitsuhiko/vim-jinja', {'for': ['jinja']}
"
" " #### YAML ####
Plug 'stephpy/vim-yaml', {'for': ['yaml']}
Plug 'pedrohdz/vim-yaml-folds', {'for': ['yaml']}

" " #### TOML ####
" Plug 'cespare/vim-toml', {'for': ['toml']}
" au BufRead,BufNewFile Pipfile set filetype=toml

" " #### jsonnet ####
Plug 'google/vim-jsonnet', {'for': ['jsonnet']}


" " #### terraform ####
Plug 'hashivim/vim-terraform', {'for': ['terraform']}
let g:terraform_fmt_on_save = 1
let g:terraform_fold_sections = 1
let g:terraform_align =1

" ##### Jenkinsfile #####
Plug 'martinda/Jenkinsfile-vim-syntax', {'for': ['Jenkinsfile']}

" ##### Dockerfile #####
Plug 'ekalinin/Dockerfile.vim', {'for': ['dockerfile']}
" Set Dockefile filetype if name contains Dockerfile
au BufRead,BufNewFile Dockerfile set filetype=dockerfile
au BufRead,BufNewFile Dockerfile* set filetype=dockerfile

" ##### LANGUAGES #####

" ##### GIT #####
Plug 'tpope/vim-fugitive'
Plug 'airblade/vim-gitgutter'
let g:gitgutter_diff_args = '--ignore-space-at-eol'
nmap [h <Plug>GitGutterPrevHunk
nmap ]h <Plug>GitGutterNextHunk

Plug 'rhysd/git-messenger.vim'

" ##### External #####
Plug 'glacambre/firenvim', { 'do': { _ -> firenvim#install(0) } }
let g:firenvim_config = {'localSettings': {}}
let fc = g:firenvim_config['localSettings']
let fc['.*'] = { 'takeover': 'never' }

if exists('g:started_by_firenvim')
    nnoremap <leader>exit :call firenvim#focus_page()<CR>
endif

" Add custom plugins
" Plug '~/code/github.com/tkinz27/nvim-symbar'

call plug#end()


" ##### LSP #####
lua << EOF
local nvim_lsp = require 'nvim_lsp'

nvim_lsp.gopls.setup{}

nvim_lsp.sumneko_lua.setup{}

nvim_lsp.pyls_ms.setup{
    log_level = vim.lsp.protocol.MessageType.Log;
    message_level = vim.lsp.protocol.MessageType.Log;
}

nvim_lsp.bashls.setup{}
EOF

nnoremap <silent> gd    <cmd>lua vim.lsp.buf.definition()<CR>
nnoremap <silent> gh     <cmd>lua vim.lsp.buf.hover()<CR>
nnoremap <silent> gD    <cmd>lua vim.lsp.buf.implementation()<CR>
nnoremap <silent> <c-k> <cmd>lua vim.lsp.buf.signature_help()<CR>
nnoremap <silent> gr    <cmd>lua vim.lsp.buf.references()<CR>
nnoremap <silent> gW    <cmd>lua vim.lsp.buf.workspace_symbol()<CR>
nnoremap <silent> g0    <cmd>lua vim.lsp.buf.document_symbol()<CR>
set omnifunc=v:lua.vim.lsp.omnifunc

" autocmd BufWritePre *.go lua vim.lsp.buf.formatting()

colorscheme onedark
set termguicolors

highlight Normal ctermbg=none guibg=none
highlight NonText ctermbg=none guibg=none
