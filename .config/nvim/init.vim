" new lua config
lua require('locals')

" Quick funtion that will
" highlight over 80 columns
" autocmd FileType cpp :autocmd! BufWritePre * :match ErrorMsg '\%>80v.\+'


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
" Do not expand tab for Makefiles
autocmd FileType make set noexpandtab

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
" let g:rooter_manual_only = 1

" Plug 'tpope/vim-repeat'

" Plug 'yssl/QFEnter'

" Plug 'junegunn/fzf', {'dir': '~/.fzf', 'do': './install --all'}
" Plug 'junegunn/fzf.vim'
" nmap <leader><tab> <plug>(fzf-maps-n)
" xmap <leader><tab> <plug>(fzf-maps-x)
" omap <leader><tab> <plug>(fzf-maps-o)

" Insert mode completion
" imap <c-x><c-k> <plug>(fzf-complete-word)
" imap <c-x><c-f> <plug>(fzf-complete-path)
" imap <c-x><c-j> <plug>(fzf-complete-file-ag)
" imap <c-x><c-l> <plug>(fzf-complete-line)

" nnoremap <silent> <Leader>ff :Files<CR>
" nnoremap <silent> <Leader>fc :Colors<CR>
" nnoremap <silent> <Leader>fh :History<CR>
" nnoremap <silent> <Leader>bb :Buffers<CR>
" nnoremap <silent> <Leader>; :Commands<CR>
" nnoremap <silent> <Leader>h :Helptags<CR>
" nnoremap <silent> <Leader>cm :Commits<CR>
" nnoremap <silent> <Leader>rg :Rg<CR>

" let g:fzf_layout = {'window': {'width': 0.95, 'height': 0.5, 'border': 'rounded'}}

" Working with the quickfix list
map <C-n> :cnext<CR>
map <C-m> :cprevious<CR>
nnoremap <leader>a :cclose<CR>

" ##### NAVIGATION #####

" ##### LANGUAGES #####
" let g:vista_default_executive = 'nvim_lsp'
" nnoremap <leader>tag :Vista!!<cr>

" Plug 'nvim-lua/completion-nvim'

" ##### javascript #####
Plug 'prettier/vim-prettier', {
    \ 'do': 'yarn install',
    \ 'for': ['javascript', 'typescript', 'css', 'less', 'scss', 'json', 'graphql', 'markdown', 'vue', 'yaml', 'html'] }

" ##### BAZEL #####
Plug 'google/vim-maktaba'
Plug 'bazelbuild/vim-bazel'

Plug 'cappyzawa/starlark.vim'

Plug 'elzr/vim-json', {'for': ['json']}
let g:vim_json_syntax_conceal = 0
autocmd FileType json setlocal foldmethod=syntax

Plug 'cstrahan/vim-capnp', {'for': ['capnp']}
Plug 'mitsuhiko/vim-jinja', {'for': ['jinja']}
"
" " #### YAML ####
Plug 'stephpy/vim-yaml', {'for': ['yaml']}
Plug 'pedrohdz/vim-yaml-folds', {'for': ['yaml']}

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

" ##### Helm #####
Plug 'towolf/vim-helm', {'for': ['helm']}

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

call plug#end()


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
