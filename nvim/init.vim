set termguicolors
set nu
set sts=2
set ts=2
set sw=2
set cursorcolumn
set cursorline

call plug#begin('~/.config/nvim/plugged')
" VIM UI
Plug 'tpope/vim-vinegar'
Plug 'junegunn/fzf', {'do': {-> fzf#install()}}
Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'Yggdroot/indentLine'
Plug 'frazrepo/vim-rainbow'
let g:rainbow_active = 1


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
Plug 'w0ng/vim-hybrid'
call plug#end()

" COLOR SCHEME==========================================
colorscheme hybrid




"COC=======================================================
"COC - reaonml languageserver settings
let g:LanguageClient_serverCommands = {
			\'reason': ['/Users/sxhx/.config/nvim/languageservers/reason-language-server.exe']
			\}

"COC - autocompletion
inoremap <silent><expr> <c-space> coc#refresh()

if exists('*complete_info')
	inoremap <expr> <cr> complete_info()["selected"] != "-1" ? "\<C-y>" : "\<C-g>u\<CR>"
else
	inoremap <expr> <cr> pumvisible() ? "\<C-y>" : "\<C-g>g\<CR>"
endif

"COC - navigation
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




"FZF========================================================
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

let g:fzf_layout = {'down': '~25%'}

map <C-f> <Esc><Esc>:FZF<CR>

