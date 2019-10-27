"
" Vim configuration file
"

set nocompatible

" Set the cursor to a (blinking) block for all modes
set guicursor=a:block

" Enable utf-8 encoding
set enc=utf-8
set fenc=utf-8
set termencoding=utf-8

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

" Show line numbers
set number

" Enable syntax highlighting
syntax enable

" Set colorscheme
set termguicolors
set background=dark
colorscheme gruvbox-dark

" Set textwidth and show an indicator
set textwidth=80
set colorcolumn=+1
set nowrap

" Show tabs as '>---' in makefiles and python sources and do not expand them
autocmd FileType make,python setlocal noexpandtab list listchars=tab:>-
