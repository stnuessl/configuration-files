"
" Vim configuration file
"

set nocompatible

" Set the cursor to a (blinking) block for all modes
set guicursor=a:block

" Enable utf-8 encoding
set encoding=utf-8
set fileencoding=utf-8

" Enable auto-indentation after opening braces
" and keep an indentation level
set smartindent
set autoindent

"
" Set tab width to 4 spaces and
" insert spaces instead of tabs
"
set tabstop=4
set shiftwidth=4
set expandtab

" Show tabs as '>---' and trailing spaces as '~'
set list
set listchars=tab:>-,trail:~

" Show line numbers
set number

" Disable mouse
set mouse=

" Enable syntax highlighting
syntax enable

" Set colorscheme
set termguicolors
set background=dark
colorscheme gruvbox-dark

" Don't show the sign column
set signcolumn=no

" Set textwidth and show an indicator
set textwidth=80
set colorcolumn=+1
set nowrap

set completeopt=menuone,longest

" Set completion style when entering file paths
set wildmode=longest,list,full
set wildmenu

" Do not expand tabs to spaces in make files
autocmd FileType make setlocal noexpandtab

" Remove trailing whitespaces before saving a buffer
autocmd BufWritePre * :% s/\s\+$//e

" Source the language server protocol configuration for C or C++ files
autocmd
    \ BufRead *.{c,h,cc,cpp,cxx,hpp,hxx}
    \ luafile ~/.config/nvim/lua/lsp/clangd.lua

" Disable auto-wrapping
autocmd
    \ BufEnter *
    \ setlocal formatoptions=

