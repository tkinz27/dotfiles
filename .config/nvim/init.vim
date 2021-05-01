" new lua config
lua require('locals')

" Do not expand tab for Makefiles
" autocmd FileType make set noexpandtab

" Auto remove trailing whitespace on write
" autocmd BufWritePre * :%s/\s\+$//e


" ##### LANGUAGES #####
" let g:vista_default_executive = 'nvim_lsp'
" nnoremap <leader>tag :Vista!!<cr>

" ##### javascript #####
" Plug 'prettier/vim-prettier', {
"     \ 'do': 'yarn install',
"     \ 'for': ['javascript', 'typescript', 'css', 'less', 'scss', 'json', 'graphql', 'markdown', 'vue', 'yaml', 'html'] }
"
" Plug 'elzr/vim-json', {'for': ['json']}
" let g:vim_json_syntax_conceal = 0
" autocmd FileType json setlocal foldmethod=syntax
"
" " " #### YAML ####
" Plug 'stephpy/vim-yaml', {'for': ['yaml']}
" Plug 'pedrohdz/vim-yaml-folds', {'for': ['yaml']}
"
" " ##### LANGUAGES #####
"
" " ##### GIT #####
" Plug 'tpope/vim-fugitive'
" Plug 'airblade/vim-gitgutter'
" let g:gitgutter_diff_args = '--ignore-space-at-eol'
" nmap [h <Plug>GitGutterPrevHunk
" nmap ]h <Plug>GitGutterNextHunk
"
" Plug 'rhysd/git-messenger.vim'
"
" let g:git_messenger_always_into_popup = v:true
