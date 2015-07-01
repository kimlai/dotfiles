set nocompatible " Make vim behave in a more useful way

" Nicer mapleader
let mapleader=" "

" Vundle bundles
if filereadable(expand("~/.vimrc.bundles"))
    source ~/.vimrc.bundles
endif

" Colors and theme
set t_Co=16
set background=dark
syntax enable
colorscheme solarized

" Miscellaenous configuration
set backspace=indent,eol,start " Make backspace behave like most editors
set complete=.,w,b,u,t
set cursorline " Highlight current line
set expandtab "Expand tabs to spaces
set hidden " When a buffer is brought to foreground, remember history and marks
set history=500 " Increase history from default 20 to 500
set incsearch "Highlight dynamically as pattern is typed
set laststatus=2 " Always show status line
set list listchars=tab:»·,trail:· " display extra whitespaces
set noshowmode " Hide the default mode text (e.g. -- INSERT -- below the statusline)
set number " Show line numbers
set ruler " Show the cursor position
set scrolloff=4 " Minimal number of screen lines to keep above and below the cursor
set shiftwidth=4 " Number of spaces to use for each step of (auto)indent
set showcmd " Show (partial) command in the last line of the screen
set softtabstop=4 " Number of insterted spaces when <TAB> or <Bs> are used
set splitbelow " New windows go below
set splitright " New windows go right
set updatetime=1250
set wildignore+=*/cache/*,*/logs/*,*/vendor/* "symfony2
set wildmenu " Hitting <TAB> in command mode will show possible completions above command line.
set wildmode=list:longest,list:full
set diffopt+=vertical

" Status line
let g:airline_powerline_fonts = 0
let g:airline_theme='solarized'
let g:airline#extensions#tmuxline#enabled = 0
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tabline#fnamemod = ':t'
if !exists('g:airline_symbols')
  let g:airline_symbols = {}
endif

" unicode symbols
let g:airline_left_sep = ''
let g:airline_right_sep = ''
let g:airline_symbols.linenr = '¶'
let g:airline_symbols.branch = '⎇'
let g:airline_symbols.paste = 'ρ'
let g:airline_symbols.paste = 'Þ'
let g:airline_symbols.paste = '∥'
let g:airline_symbols.whitespace = 'Ξ'

" Split navigation (Ctrl+j, Ctrl+k, Ctrl+h, Ctrl+h)
nnoremap <C-J> <C-W><C-J>
nnoremap <C-K> <C-W><C-K>
nnoremap <C-L> <C-W><C-L>
nnoremap <C-H> <C-W><C-H>

" " Faster split resizing (+,-)
" if bufwinnr(1)
"     map + <C-W>+
"     map - <C-W>-
" endif
"
" Disable arrow keys
nnoremap <up> :echoe "Use k"<CR>
nnoremap <down> :echoe "Use j"<CR>
nnoremap <left> :echoe "Use h"<CR>
nnoremap <right> :echoe "Use l"<CR>

" When in insert mode, type kj instead of <ESC> to go back to normal mode
imap kj <ESC>

" Automatially insert use statement for class under the cursor.
noremap <Leader>u :call PhpInsertUse()<CR>

" Insert newline
map <leader><Enter> o<ESC>

" Remove trailing whitespace with <leader>S
nnoremap <leader>S :%s/\s\+$//<cr>:let @/=''<CR>

" Yank from cursor to end of line
nnoremap Y y$

" Create a getter for the word under the cursor
map <leader>g mayiwGO<CR>public function get<ESC>pblll~A()<CR>{<CR>return $this-><ESC>pA;<CR>}<ESC>gg=G`a:delm a<CR>

" Make mouse middle click paste without formatting it.
map <MouseMiddle> <Esc>"*p

" Bind K to grep word under cursor
nnoremap K :grep! "\b<C-R><C-W>\b"<CR>:cw<CR>

" Stop that stupid window from popping up
map q: :q

" Go to the previously viewed buffer
:nmap <C-e> :e#<CR>

" Open ctrl-p buffer search
:nnoremap , :CtrlPBuffer<CR>

" Azerty sucks
nnoremap . ;
nnoremap ; .

" Sort use statements
nnoremap <Leader>so magg/use<CR>vip:sort<CR>`a:delmarks a<CR>

" Move between buffers using Ctrl-[h-l]
nnoremap <C-h> :bn<CR>
nnoremap <C-l> :bp<CR>

" CtrlP
let g:ctrlp_working_path_mode = 'r' " Wroking dir is the nearest ancestor that contains a `.git` folder
let g:ctrlp_mru_files = 0 " Disable Most Recently Used files feature
let g:ctrlp_jump_to_buffer = 2 " Jump to tab AND buffer if already open

" vim-sneak
let g:sneak#s_next = 1
map . <Plug>SneakNext

map <Leader>T :Dispatch<CR>

" Filetype syntax
autocmd BufNewFile,BufReadPost *.coffee setl shiftwidth=2 expandtab " Coffescript indentation
autocmd BufNewFile,BufReadPost *.feature setl shiftwidth=2 expandtab " Behat indentation
autocmd Filetype gitcommit setlocal spell textwidth=72 " Git commit messages spellcheck + word-wrap
autocmd BufNewFile,BufReadPost *.md set filetype=markdown

" The Silver Searcher
if executable('ag')
    " Use ag over grep
    set grepprg=ag\ --nogroup\ --nocolor

    " Use ag in CtrlP for listing files. Lightning fast and respect .gitignore
    let g:ctrlp_user_command = 'ag %s -l --nocolor -g ""'

    " ag is fast enough that CtrlP doesn't need to cache
    let g:ctrlp_use_caching = 0
endif
" Bind \ to grep shortcut
command -nargs=+ -complete=file -bar Ag silent! grep! <args>|cwindow|redraw!
nnoremap \ :Ag<SPACE>

" When editing a file, always jump to the last known cursor position.
" Don't do it for commit messages, when the position is invalid, or when
" inside an event handler (happens when dropping a file on gvim).
autocmd BufReadPost *
    \ if &ft != 'gitcommit' && line("'\"") > 0 && line("'\"") <= line("$") |
        \   exe "normal g`\"" |
    \ endif

" Tab completion
" will insert tab at beginning of line,
" will use completion if not at beginning
function! InsertTabWrapper()
    let col = col('.') - 1
    if !col || getline('.')[col - 1] !~ '\k'
        return "\<tab>"
    else
        return "\<c-n>"
    endif
endfunction
inoremap <Tab> <c-r>=InsertTabWrapper()<cr>

" Git syntax highlighting sucks in French...
let g:fugitive_git_executable = 'LANG=en git'

" vdebug
" TODO : move this in a project specific file, or find a way to look in git root dir
let g:vdebug_options = { 'server' : "10.9.8.1" } "vagrant remote host
let g:vdebug_options['path_maps'] = {"/vagrant/": "/home/kimlai/Documents/Projets/lrqdo/back-web/"}
