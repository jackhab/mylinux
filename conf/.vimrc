if v:lang =~ "utf8$" || v:lang =~ "UTF-8$"
   set fileencodings=utf-8,latin1
endif

set nocompatible	" Use Vim defaults (much better!)
set bs=2		" allow backspacing over everything in insert mode
set ai			" always set autoindenting on
"set backup		" keep a backup file
set viminfo='20,\"50	" read/write a .viminfo file, don't store more
			" than 50 lines of registers
set history=100		" keep 50 lines of command line history
set ruler		" show the cursor position all the time

" Only do this part when compiled with support for autocommands
if has("autocmd")
  " In text files, always limit the width of text to 78 characters
"  autocmd BufRead *.txt set tw=78
  " When editing a file, always jump to the last cursor position
  autocmd BufReadPost *
  \ if line("'\"") > 0 && line ("'\"") <= line("$") |
  \   exe "normal g'\"" |
  \ endif
endif

" Switch syntax highlighting on, when the terminal has colors
" Also switch on highlighting the last used search pattern.
if &t_Co > 2 || has("gui_running")
  syntax on
  set hlsearch
endif

if &term=="xterm"
     set t_Co=8
     set t_Sb=^[4%dm
     set t_Sf=^[3%dm
endif


"--------------------------CUSTOM CONFIGURATION----------------------------------"

""""""""""""""""""""""""""""
"Keyboard  maps
"""""""""""""""""""""""""""

"save file
map  <F2> :w!
map! <F2> :w!a

"toggle Taglist 
map  <F3> :Tlist
map! <F3> :Tlista

"toggle maximized window
map  <F4> :WinFullScreen
map! <F4> :WinFullScreena

"build
map  <F7> :w\|make\|cw
map! <F7> :w\|make\|cwa

"toggle folding
map  <F5> zA
map! <F5> zA
map  <S-F5> zM
map! <S-F5> zM

"toggle line wrap
nnoremap <S-F2> :set invwrap	

"always jump to file in a new window
nnoremap gf :e <cfile><CR>		

"use incremental search highlighting
set incsearch						

"path to find files
set path=**,.,,,			

"when jumping to other file reuse open file, if none -> open new window
set switchbuf=useopen,usetab,split			

"status line format
set statusline=%<%F\ %h%m%r%=%-14.(%l,%c%V%)\ %P	

"status always on
set laststatus=2					

"terminal title format
set title titlestring=%<%F%=%l/%L-%P titlelen=70	

"path to search tags file
set tags=./tags,tags,/usr/include/tags		

set nowrap
set textwidth=0

"case insensitive search
set ignorecase			

"set foldmethod=syntax	
"set nofoldenable
"set foldcolumn=3

"hide menu and toolbar in GUI
set guioptions=aegimrLt		

set guifont="MiscFixed 11"

"enable popup menu
set mousemodel=popup		

"all mouse functions enabled
set mouse=a			        

set sessionoptions=sesdir,folds,resize,tabpages,winpos,winsize,buffers

set tabstop=4
set shiftwidth=4
set expandtab
set modeline

set notitle

"always show tabline
set showtabline=2		

"show control chars (use set list to activate)
set listchars=eol:$,tab:>-			

hi FoldColumn guibg=DarkGrey
hi FoldColumn guifg=Black
hi Pmenu guibg=Black


" Set an orange cursor in Insert mode, and red cursor otherwise.
" Works at least for xterm and rxvt terminals
" Does not work at least for gnome terminal, konsole, xfce4-terminal
" in terminator cursor disappears after vim exit
"if &term =~ "xterm\\|rxvt"
"	:silent !echo -ne "\033]12;red\007"
"	let &t_SI = "\033]12;green\007"
"	let &t_EI = "\033]12;red\007"
"	autocmd VimLeave * :!echo -ne "\033]12;red\007"
"endif



colorscheme jellybeans


function! InsertStatuslineColor(mode)
  if a:mode == 'i'
    hi statusline guibg=magenta
  elseif a:mode == 'r'
    hi statusline guibg=blue
  else
    hi statusline guibg=red
  endif
endfunction

au InsertEnter * call InsertStatuslineColor(v:insertmode)
au InsertChange * call InsertStatuslineColor(v:insertmode)
au InsertLeave * hi statusline guibg=green

" default the statusline to green when entering Vim
hi statusline guibg=green


"pathogens automatically installs plugins located in .vim/bundle directory
"installation example: cd ~/.vim/bundle &&"git clone https://github.com/scrooloose/nerdtree.git
execute pathogen#infect() 















