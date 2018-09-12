""""""""""""""""""""""""""""""""""""""""""""""""
" Generic setup
""""""""""""""""""""""""""""""""""""""""""""""""
filetype plugin indent on

let mapleader = ","
" Tell neovim where to find neovim python packages
let g:python_host_prod='/usr/local/bin/python2'
let g:python3_host_prog='/usr/local/bin/python3'

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

"""""""""""""""""""""""""""""""""""
" Operator Maps
"""""""""""""""""""""""""""""""""""
" Operator maps to get inside () '' and "
onoremap in( :<c-u>normal! f(vi(<cr>
onoremap in) :<c-u>normal! F)vi)<cr>
onoremap in{ :<c-u>normal! f{vi{<cr>
onoremap in} :<c-u>normal! F}vi}<cr>
onoremap in[ :<c-u>normal! f[vi[<cr>
onoremap in] :<c-u>normal! F]vi]<cr>
onoremap in' :<c-u>normal! f'vi'<cr>
onoremap il' :<c-u>normal! F'vi'<cr>
onoremap in" :<c-u>normal! f"vi"<cr>
onoremap il" :<c-u>normal! F"vi"<cr>

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

Plug 'flazz/vim-colorschemes'

Plug 'kien/rainbow_parentheses.vim', {'on': 'RainbowParenthesesToggleAll'}
nnoremap <leader>( :RainbowParenthesesToggleAll<cr>

Plug 'Yggdroot/indentLine'

Plug 'machakann/vim-highlightedyank'

" ##### APPEARENCE #####

if has('nvim')
    set inccommand=nosplit
endif


" ##### TEXT MANIPULATION #####
Plug 'tpope/vim-surround'
Plug 'tpope/vim-commentary'
Plug 'tmhedberg/matchit'

Plug 'godlygeek/tabular', {'on': 'Tabularize'}
" see http://vimcasts.org/episodes/aligning-text-with-tabular-vim/
if exists(":Tabularize")
    nnoremap <leader>a= :Tabularize /=<CR>
    vnoremap <leader>a= :Tabularize /=<CR>
    nnoremap <leader>a: :Tabularize /:\zs<CR>
    vnoremap <leader>a: :Tabularize /:\zs<CR>
endif
inoremap <silent> <Bar>   <Bar><Esc>:call <SID>align()<CR>a
function! s:align()
  let p = '^\s*|\s.*\s|\s*$'
  if exists(':Tabularize') && getline('.') =~# '^\s*|' && (getline(line('.')-1) =~# p || getline(line('.')+1) =~# p)
    let column = strlen(substitute(getline('.')[0:col('.')],'[^|]','','g'))
    let position = strlen(matchstr(getline('.')[0:col('.')],'.*|\s*\zs.*'))
    Tabularize/|/l1
    normal! 0
    call search(repeat('[^|]*|',column).'\s\{-\}'.repeat('.',position),'ce',line('.'))
  endif
endfunction
" end tabularize

inoremap <C-a> <Esc>I
inoremap <C-e> <Esc>A

" ##### TEXT MANIPULATION #####

" ##### COMPLETION #####
Plug 'SirVer/ultisnips'
let g:UltiSnipsEditSplit="context"
let g:UltiSnipsListSnippets="<c-s-tab>"
let g:ultisnips_python_style="sphinx"

if has('nvim')
    Plug 'shougo/deoplete.nvim', {'do': ':UpdateRemotePlugins'}
    Plug 'shougo/neco-syntax', {'do': 'UpdateRemotePlugins'}
    let g:deoplete#enable_at_startup = 1
endif

Plug 'Shougo/echodoc.vim'
set noshowmode
" needed for echodoc

Plug 'honza/vim-snippets'
Plug 'spiroid/vim-ultisnip-scala'


if has('nvim')
  Plug 'neovim/node-host', {'do': 'npm install'}
endif

" ##### NAVIGATION #####
Plug 'airblade/vim-rooter'
Plug 'tpope/vim-repeat'

Plug 'scrooloose/nerdtree', {'on':  'NERDTreeToggle'}
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
nnoremap <silent> <Leader>ll :Lines<CR>
nnoremap <silent> <Leader>lb :BLines<CR>
nnoremap <silent> <Leader>tt :Tags<CR>

command! -bang -nargs=* Find call fzf#vim#grep('rg --column --line-number --no-heading --fixed-strings --ignore-case --no-ignore --hidden --follow --glob "!.git/*" --color "always" '.shellescape(<q-args>).'| tr -d "\017"', 1, <bang>0)

set grepprg=rg\ --vimgrep

Plug 'majutsushi/tagbar', {'on': ['TagbarOpen']}
nnoremap <leader>tag :TagbarOpen fjc<cr>

" Working with the quickfix list
map <C-n> :cnext<CR>
map <C-m> :cprevious<CR>
nnoremap <leader>a :cclose<CR>

" ##### NAVIGATION #####

" ##### LANGUAGES #####
" Hopefully i can remove much of this and just use the language servers
Plug 'autozimu/LanguageClient-neovim', {
            \ 'branch': 'next',
            \ 'do': 'bash install.sh',
            \ }
set hidden
let g:LanguageClient_serverCommands = {
    \ 'rust': ['rustup', 'run', 'nightly', 'rls'],
    \ 'typescript': ['javascript-typescript-stdio'],
    \ 'javascript': ['javascript-typescript-stdio'],
    \ 'javascript.jsx': ['javascript-typescript-stdio'],
    \ 'python': ['pyls', '-v', '--log-file', '~/.pyls.log'],
    \ }

let g:LanguageClient_autoStart = 1
nnoremap <silent> K :call LanguageClient_textDocument_hover()<CR>
nnoremap <silent> gd :call LanguageClient_textDocument_definition()<CR>
nnoremap <silent> gf :call LanguageClient_textDocument_formatting()<CR>
nnoremap <silent> <F2> :call LanguageClient_textDocument_rename()<CR>

" ##### RUST #####
Plug 'rust-lang/rust.vim', {'for': ['rust']}
let g:rustfmt_autosave = 1
let g:rustfmt_command = "cargo fmt -- "

Plug 'elzr/vim-json', {'for': ['json']}
let g:vim_json_syntax_conceal = 0
autocmd FileType json setlocal foldmethod=syntax

Plug 'cstrahan/vim-capnp', {'for': ['capnp']}

Plug 'reedes/vim-pencil'
let g:pencil#textwidth = 100
let g:pencil#map#suspend_af = 'K'
nnoremap <leader>Q gqap

" ##### PYTHON ####
" Plug 'hdima/python-syntax', {'for': ['python']}
" Plug 'tshirtman/vim-cython', {'for': ['cython']}
" Set cython filetype if name contains pxi, pxd
" au BufRead,BufNewFile *.pxi set filetype=cython
" au BufRead,BufNewFile *.pxd set filetype=cython
" au BufRead,BufNewFile *.pyx set filetype=cython

" ##### GO ####
Plug 'fatih/vim-go', {'for': ['go']}
let g:go_fmt_options = {
    \ 'gofmt': '-s',
    \ 'goimports': '-local github.com/braincorp',
    \ }
let g:go_fmt_command = "goimports"
let g:go_auto_type_info = 0
autocmd FileType go nmap <leader>b <Plug>(go-build)
autocmd FileType go nmap <leader>r <Plug>(go-run)

Plug 'prettier/vim-prettier', {
    \ 'do': 'npm install',
    \ 'for': ['javascript', 'typescript', 'css', 'less', 'scss', 'json', 'graphql', 'markdown', 'vue']}
let g:prettier#autoformat = 0
autocmd BufWritePre *.js,*.jsx,*.mjs,*.ts,*.tsx,*.css,*.less,*.scss,*.json,*.graphql,*.md,*.vue PrettierAsync
" Plug 'mxw/vim-jsx', {'for': ['jsx']}
" Plug 'leafgarland/typescript-vim', {'for': ['typescript']}
" Plug 'Quramy/vim-js-pretty-template', {'for': ['typescript', 'javascript']}
" Plug 'jason0x43/vim-js-indent', {'for': ['typescript', 'javascript']}
" Plug 'Quramy/vim-dtsm', {'for': ['typescript']}
" Plug 'mhartington/vim-typings', {'for': ['typescript']}

" #### HTML ####
Plug 'mattn/emmet-vim', {'for': ['html', 'css']}
Plug 'vim-scripts/SQLUtilities', {'for': ['sql']}

Plug 'mitsuhiko/vim-jinja', {'for': ['jinja']}

" #### YAML ####
Plug 'stephpy/vim-yaml', {'for': ['yaml']}
Plug 'pedrohdz/vim-yaml-folds', {'for': ['yaml']}

" #### TOML ####
Plug 'cespare/vim-toml', {'for': ['toml']}
au BufRead,BufNewFile Pipfile set filetype=toml


Plug 'hashivim/vim-hashicorp-tools', {'for': ['terraform']}
let g:terraform_fmt_on_save = 1
let g:terraform_fold_sections = 1
let g:terraform_align =1
autocmd FileType terraform setlocal commentstring=#%s

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
nmap <leader>hv <Plug>GitGutterPreviewHunk

call plug#end()

colorscheme gruvbox
hi! Normal ctermbg=None guibg=None
