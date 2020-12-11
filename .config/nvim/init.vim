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
" let g:rooter_manual_only = 1

Plug 'tpope/vim-repeat'

Plug 'scrooloose/nerdtree'
Plug 'ryanoasis/vim-devicons'
Plug 'Xuyuanp/nerdtree-git-plugin'
nnoremap <F6> :NERDTreeToggle<cr>

Plug 'yssl/QFEnter'

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
Plug 'neovim/nvim-lspconfig'
" Plug 'liuchengxu/vista.vim'

" let g:vista_default_executive = 'nvim_lsp'
" nnoremap <leader>tag :Vista!!<cr>

Plug 'nvim-lua/completion-nvim'

" ##### BAZEL #####
Plug 'google/vim-maktaba'
Plug 'bazelbuild/vim-bazel'

Plug 'cappyzawa/starlark.vim'

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
Plug 'cespare/vim-toml', {'for': ['toml']}
" au BufRead,BufNewFile Pipfile set filetype=toml

" " #### rego ####
Plug 'tsandall/vim-rego', {'for': ['rego']}


" " #### jsonnet ####
Plug 'google/vim-jsonnet', {'for': ['jsonnet']}

" " #### protobuf ####
Plug 'uarun/vim-protobuf', {'for': ['proto']}

" #### terraform ####
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

" ##### Mustache #####
Plug 'mustache/vim-mustache-handlebars', {'for': ['mustache']}

" ##### LANGUAGES #####

" ##### GIT #####
Plug 'tpope/vim-fugitive'
Plug 'airblade/vim-gitgutter'
let g:gitgutter_diff_args = '--ignore-space-at-eol'
nmap [h <Plug>GitGutterPrevHunk
nmap ]h <Plug>GitGutterNextHunk

Plug 'rhysd/git-messenger.vim'

let g:git_messenger_always_into_popup = v:true

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
local lspconfig = require 'lspconfig'
local configs = require 'lspconfig/configs'

local on_attach_vim = function(client)
  require'completion'.on_attach(client)
end

lspconfig.gopls.setup{
  on_attach=on_attach_vim;
  cmd = {"gopls", "-vv", "-rpc.trace", "-logfile", "/tmp/gopls.log"};
  settings = {
    usePlaceholders = true;
    experimentalWorkspaceModule = true;
  };
}

lspconfig.rust_analyzer.setup{}

lspconfig.cmake.setup{}

-- lspconfig.sumneko_lua.setup{}

-- lspconfig.pyls.setup{}

-- if not nvim_lsp.pyright then
--   configs.pyright = {
--     default_config = {
--       cmd = {"pyright-langserver", "--stdio"};
--       filetypes = {"python"};
--       root_dir = util.root_pattern(".git", "setup.py", "setup.cfg", "pyproject.toml", "requirements.txt");
--       settings = {
--         analysis = { autoSearchPaths = true; };
--         pyright = { useLibraryCodeForTypes = true; };
--       };
--       before_init = function(initialize_params)
--         initialize_params['workspaceFolders'] = {{
--           name = 'workspace',
--           uri = initialize_params['rootUri']
--         }}
--       end
--     };
--   }
-- end
-- nvim_lsp.pyright.setup{}

lspconfig.bashls.setup{
  on_attach=on_attach_vim;
}

lspconfig.terraformls.setup{
  on_attach=on_attach_vim;
  cmd={'terraform-ls', 'serve', '-log-file', '/tmp/terraform-ls.log'};
}

lspconfig.yamlls.setup{
  on_attach=on_attach_vim;
}

-- organize imports sync
function go_org_imports(options, timeout_ms)
  local context = { source = { organizeImports = true } }
  vim.validate { context = { context, 't', true } }
  local params = vim.lsp.util.make_range_params()
  params.context = context

  local result = vim.lsp.buf_request_sync(0, "textDocument/codeAction", params, timeout_ms)
  if not result then return end
  result = result[1].result
  if not result then return end
  edit = result[1].edit
  vim.lsp.util.apply_workspace_edit(edit)
end

-- vim.api.nvim_command("au BufWritePre *.go lua go_org_imports({}, 1000)")

vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(
  vim.lsp.diagnostic.on_publish_diagnostics, {
    virtual_text = {
      spacing = 4,
      prefix = "■",
    }
  }
)
EOF

call sign_define("LspDiagnosticsErrorSign", {"text" : "✗", "texthl" : "LspDiagnosticsError"})
call sign_define("LspDiagnosticsWarningSign", {"text" : "⚠", "texthl" : "LspDiagnosticsWarning"})
call sign_define("LspDiagnosticsInformationSign", {"text" : "ⓘ", "texthl" : "LspDiagnosticsInformation"})
call sign_define("LspDiagnosticsHintSign", {"text" : "✓", "texthl" : "LspDiagnosticsHint"})

set completeopt=menuone,noinsert,noselect
set shortmess+=c

nnoremap <silent> gd    <cmd>lua vim.lsp.buf.definition()<CR>
nnoremap <silent> gh     <cmd>lua vim.lsp.buf.hover()<CR>
nnoremap <silent> gD    <cmd>lua vim.lsp.buf.implementation()<CR>
nnoremap <silent> <c-k> <cmd>lua vim.lsp.buf.signature_help()<CR>
nnoremap <silent> gr    <cmd>lua vim.lsp.buf.references()<CR>
nnoremap <silent> gW    <cmd>lua vim.lsp.buf.workspace_symbol()<CR>
nnoremap <silent> gs    <cmd>lua vim.lsp.buf.document_symbol()<CR>
nnoremap <silent> gnd   <cmd>lua vim.lsp.diagnostic.goto_next()<CR>
set omnifunc=v:lua.vim.lsp.omnifunc

autocmd BufWritePre *.go lua vim.lsp.buf.formatting_sync({}, 1000)
autocmd BufWritePre *.tf lua vim.lsp.buf.formatting_sync({}, 1000)

colorscheme onedark
set termguicolors

highlight Normal ctermbg=none guibg=none
highlight NonText ctermbg=none guibg=none
