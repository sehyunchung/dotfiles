syntax on
set noerrorbells
set expandtab
set smartindent
set nowrap
set smartcase
set incsearch
set termguicolors
set t_Co=256
set nu
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
set lsp=5
set noswapfile
set nobackup
set undodir=~/.vim/undodir
set undofile
imap jk <Esc>

call plug#begin('~/.config/nvim/pluGged')
" VIM UI
Plug 'neovim/nvim-lspconfig'
Plug 'tpope/vim-surround'
Plug 'nvim-lua/popup.nvim'
Plug 'nvim-lua/plenary.nvim'
Plug 'nvim-telescope/telescope.nvim'
" telescope
" Find files using Telescope command-line sugar.
nnoremap <leader>ff <cmd>Telescope find_files<cr>
nnoremap <leader>fg <cmd>Telescope live_grep<cr>
nnoremap <leader>fb <cmd>Telescope buffers<cr>
nnoremap <leader>fh <cmd>Telescope help_tags<cr>

Plug 'tpope/vim-vinegar'

Plug 'voldikss/vim-floaterm'
let g:floaterm_width=0.8
let g:floaterm_autoclose=1
nnoremap <C-m> <Esc><Esc>:FloatermNew<CR>

Plug 'vim-scripts/vim-auto-save'
let g:auto_save = 0

Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'

Plug 'junegunn/fzf', {'do': {-> fzf#install()}}
Plug 'junegunn/fzf.vim'

Plug 'neoclide/coc.nvim', {'branch': 'release'}

Plug 'frazrepo/vim-rainbow'
let g:rainbow_active = 0

" Git
Plug 'tpope/vim-fugitive'
Plug 'airblade/vim-gitgutter'

" Fish
Plug 'dag/vim-fish'

" Racket
Plug 'wlangstroth/vim-racket'

" JS/TS
Plug 'pangloss/vim-javascript'
Plug 'leafgarland/typescript-vim'
Plug 'peitalin/vim-jsx-typescript'
Plug 'styled-components/vim-styled-components', {'branch': 'main'}
Plug 'jparise/vim-graphql'
autocmd BufNewFile,BufRead *.tsx,*.jsx set filetype=typescriptreact

" mdx
Plug 'jxnblk/vim-mdx-js'

" Ruby
Plug 'vim-ruby/vim-ruby'
Plug 'tpope/vim-rails'

" Elixir
Plug 'elixir-editors/vim-elixir'
Plug 'elixir-lsp/coc-elixir', {'do': 'yarn install && yarn prepack'}

" themes
Plug 'chriskempson/base16-vim'
Plug 'sainnhe/sonokai'
Plug 'mswift42/vim-themes'
Plug 'rakr/vim-one'
Plug 'arcticicestudio/nord-vim'
Plug 'Nequo/vim-allomancer'
Plug 'hzchirs/vim-material'
Plug 'kaicataldo/material.vim'
Plug 'tomasiser/vim-code-dark'
Plug 'jacoborus/tender.vim'
Plug 'liuchengxu/space-vim-dark'
Plug 'junegunn/seoul256.vim'
Plug 'sts10/vim-pink-moon'
Plug 'cseelus/vim-colors-lucid'

call plug#end()

set background=dark
colorscheme sonokai
let g:sonokai_style='default'
let g:airline_theme='sonokai'
let base16colorspace=256

" lua
lua << EOF
  local lspconfig = require 'lspconfig'
  lspconfig.rust_analyzer.setup({})
EOF

command! Scratch lua require'tools'.makeScratch()

" use alt+hjkl to move between split/vsplit panels
tnoremap <A-h> <C-\><C-n><C-w>h
tnoremap <A-j> <C-\><C-n><C-w>j
tnoremap <A-k> <C-\><C-n><C-w>k
tnoremap <A-l> <C-\><C-n><C-w>l
nnoremap <A-h> <C-w>h
nnoremap <A-j> <C-w>j
nnoremap <A-k> <C-w>k
nnoremap <A-l> <C-w>l


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
command! -nargs=0 P :CocCommand prettier.formatFile


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

map <silent> <C-f> <Esc><Esc>:GitFiles<CR>
map <silent> <C-g> <Esc><Esc>:Rg<CR>
map <silent> <C-b> <Esc><Esc>:bnext<CR>
