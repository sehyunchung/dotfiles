set termguicolors
set t_Co=256
set t_AB=^[[48;5;%dm
set t_AF=^[[38;5;%dm
set rnu
set sts=2
set ts=2
set sw=2
set cursorcolumn
set cursorline
set hidden
set updatetime=300
set shortmess+=c
set noshowmode

call plug#begin('~/.config/nvim/plugged')
" VIM UI
Plug 'tpope/vim-surround'
Plug 'tpope/vim-vinegar'
Plug 'voldikss/vim-floaterm'
let g:floaterm_width=0.8
let g:floaterm_autoclose=1
map <C-o> <Esc><Esc>:FloatermNew<CR>
Plug 'vim-scripts/vim-auto-save'
let g:auto_save = 1

Plug 'itchyny/lightline.vim'
let g:lightline = {
      \ 'colorscheme': 'wombat',
      \ 'active': {
      \   'left': [ [ 'mode', 'paste' ],
      \             [ 'gitbranch', 'readonly', 'filename', 'modified' ] ]
      \ },
      \ 'component_function': {
      \   'gitbranch': 'FugitiveHead'
      \ },
      \ }

Plug 'junegunn/fzf', {'do': {-> fzf#install()}}
Plug 'junegunn/fzf.vim'

Plug 'neoclide/coc.nvim', {'branch': 'release'}

Plug 'frazrepo/vim-rainbow'
let g:rainbow_active = 0

" TERMINAL
set splitright
set splitbelow
tnoremap <C-x> <C-\><C-n>
au BufEnter * if &buftype == 'terminal' | :startinsert | endif
function! OpenTerminal()
	vsplit term://zsh
	vertical resize 100
endfunction
nnoremap <c-\> :call OpenTerminal()<CR>

" Git
Plug 'tpope/vim-fugitive'
Plug 'airblade/vim-gitgutter'

" Fish
Plug 'dag/vim-fish'

" REASONML
Plug 'reasonml-editor/vim-reason-plus'
Plug 'jordwalke/vim-reasonml'
Plug 'autozimu/LanguageClient-neovim', {'branch': 'next', 'do': 'bash install.sh'}

" JS/TS
Plug 'pangloss/vim-javascript'
Plug 'leafgarland/typescript-vim'
Plug 'peitalin/vim-jsx-typescript'
Plug 'styled-components/vim-styled-components', {'branch': 'main'}
Plug 'jparise/vim-graphql'
autocmd BufNewFile,BufRead *.tsx,*.jsx set filetype=typescriptreact

" Ruby
Plug 'vim-ruby/vim-ruby'
Plug 'tpope/vim-rails'

" Elixir
Plug 'elixir-editors/vim-elixir'
Plug 'elixir-lsp/coc-elixir', {'do': 'yarn install && yarn prepack'}

" THEMES
Plug 'w0ng/vim-hybrid'
Plug 'chriskempson/base16-vim'
Plug 'NLKNguyen/papercolor-theme'
Plug 'aonemd/kuroi.vim'
Plug 'dracula/vim', { 'as': 'dracula' }

call plug#end()

" use alt+hjkl to move between split/vsplit panels
tnoremap <A-h> <C-\><C-n><C-w>h
tnoremap <A-j> <C-\><C-n><C-w>j
tnoremap <A-k> <C-\><C-n><C-w>k
tnoremap <A-l> <C-\><C-n><C-w>l
nnoremap <A-h> <C-w>h
nnoremap <A-j> <C-w>j
nnoremap <A-k> <C-w>k
nnoremap <A-l> <C-w>l


" COLOR SCHEME==========================================
colorscheme grb256
let base16colorspace=256
set background=dark




"COC=======================================================

"COC - autocompletion
inoremap <silent><expr> <c-space> coc#refresh()

if exists('*complete_info')
	inoremap <expr> <cr> complete_info()["selected"] != "-1" ? "\<C-y>" : "\<C-g>u\<CR>"
else
	inoremap <expr> <cr> pumvisible() ? "\<C-y>" : "\<C-g>g\<CR>"
endif


"COC - navigation
nmap <space>e :CocCommand explorer<CR>
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)


"COC - tooltips
nnoremap <silent> K :call <SID>show_documentation()<CR>

function! s:show_documentation()
	if (index(['vim', 'help'], &filetype) >= 0)
		execute 'h '.expand('<cword>')
	else
		call CocAction('doHover')
	endif
endfunction

nnoremap <nowait><expr> <C-f> coc#float#has_scroll() ? coc#float#scroll(1) : "\<C-f>"
nnoremap <nowait><expr> <C-b> coc#float#has_scroll() ? coc#float#scroll(0) : "\<C-b>"
inoremap <nowait><expr> <C-f> coc#float#has_scroll() ? "\<c-r>=coc#float#scroll(1)\<cr>" : "\<Right>"
inoremap <nowait><expr> <C-b> coc#float#has_scroll() ? "\<c-r>=coc#float#scroll(0)\<cr>" : "\<Left>"

"COC - codeaction
nmap <leader>do <Plug>(coc-codeaction)

"COC - languageserver settings
let g:LanguageClient_serverCommands = {
			\'reason': ['/Users/sxhx/.config/nvim/languageservers/reason-language-server.exe'],
			\'vue': ['vls']
			\}

"COC - format
command! -nargs=0 Prettier :CocCommand prettier.formatFile


"FZF========================================================
let $FZF_DEFAULT_COMMAND = 'ag -g ""'
function! s:build_quickfix_list(lines)
	call setqflist(map(copy(a:lines), '{ "filename": v:val }'))
	copen
	cc
endfunction

let g:fzf_action = {
			\'ctrl-q': function('s:build_quickfix_list'),
			\'ctrl-t': 'tab split',
			\'ctrl-x': 'split',
			\'ctrl-v': 'vsplit' }

let g:fzf_layout ={'window': { 'width': 0.8, 'height': 0.6, 'xoffset': 0.5 }} 

map <silent> <Leader>g <Esc><Esc>:FZF<CR>
map <silent> <Leader>f <Esc><Esc>:Rg<CR>
