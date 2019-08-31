"==================================
"    Nombre:     $HOME/.config/nvim/init.vim
"    Autor:      Daniel Santiago
"    Github:     dspelaez/dotfiles
"    Fecha:      2015-05-05
"    Modificado: 2019-08-26
"==================================

" ============================= sintaxis y formato ===================================
" sincronizar rutas de nvim y python {{{
" ----------------------------------
  set runtimepath+=~/.vim,~/.vim/after
  set packpath+=~/.vim

  let g:loaded_python_provider = 1
  let g:python3_host_prog=expand('~/.miniconda/envs/neovim/bin/python')
" --- }}}

" habilitar sintaxis y numeros de lineas {{{
" ---------------------------------------
  set relativenumber
  set number
  syntax enable
  set noshowmode
  set laststatus=2
  set showtabline=2
  set guioptions-=e
  set noswapfile
  "highlight Comment cterm=italic
" --- }}}

" configurar indentado {{{
" --------------------
  set expandtab
  set shiftwidth=2
  set softtabstop=2
" --- }}}

" configurar columnas {{{
" -------------------
  set textwidth=80
  let &colorcolumn=join(range(90,90),",")
  highlight ColorColumn ctermbg=15 guibg=lightgrey
" --- }}}

" configurar split {{{
" ----------------
  nnoremap <C-J> <C-W><C-J>
  nnoremap <C-K> <C-W><C-K>
  nnoremap <C-L> <C-W><C-L>
  nnoremap <C-H> <C-W><C-H>
  set splitbelow
  set splitright
" --- }}}

" habilitar backspace {{{
" -------------------
  set nocompatible
  set backspace=2
" --- }}}

" habilitar copy-paste {{{
" -------------------
  if has("mac")
    set clipboard=unnamed
  else
    set clipboard=unnamedplus
  endif
" --- }}}

" moverse entre buffers{{{
" -----------
  nnoremap <S-Tab> :bnext<CR>
" --- }}}

" folding methods {{{
" ---------------
  set foldmethod=marker
" --- }}}

"clear highlight in the last search {{{
  nnoremap <CR> :noh<CR>
" --- }}}
"
" mapear algunos comandos {{{
" -----------
  map <Esc><Esc> :w<CR>
  map Q mxgqip`x
" --- }}}



" ============================= tipos de archivo ====================================
" text files {{{
" ----------
  filetype plugin on
  autocmd FileType markdown set spell spelllang=en,es
  autocmd FileType tex      set spell spelllang=en,es
" --- }}}

" python files {{{
" ------------
  autocmd FileType py set foldmethod=marker
" --- }}}

" bibtex files {{{
" ------------
  "function doi2bib(doi)
    "read !python ~/Dropbox/References/doi2bib.py doi
  "endfunction
  
"function! DoiToBib()
  "let curline = getline('.')
  "call inputsave()
  "let doi = input('Enter doi: ')
  "call inputrestore()
  ""call setline('.', curline . ' ' . name)
  "read !python ~/Dropbox/References/doi2bib.py . doi
"endfunction
" --- }}}


" =============================     plug-ins     ====================================
" vim-plug {{{
  if empty(glob('~/.config/nvim/autoload/plug.vim'))
    silent !curl -fLo ~/.config/nvim/autoload/plug.vim --create-dirs
      \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
    autocmd VimEnter * PlugInstall --sync
  endif

  call plug#begin('~/.config/nvim/plugged')"
" --- }}}

" nerd-tree {{{
  Plug 'scrooloose/nerdtree', { 'on': 'NERDTreeToggle' }
  map <C-n> :NERDTreeToggle<CR>
" --- }}}

" nerd-commenter {{{
  Plug 'scrooloose/nerdcommenter'
" --- }}}

" lightline {{{
  Plug 'itchyny/lightline.vim'
" --- }}}

" color-scheme {{{
  "
  if empty(glob('~/.config/nvim/pack/themes/opt/solarized8'))
    silent !git clone https://github.com/lifepillar/vim-solarized8.git
      \ ~/.config/nvim/pack/themes/opt/solarized8
  endif
  "
  Plug 'lifepillar/vim-solarized8'
  if exists('+termguicolors')
    let &t_8f = "\<Esc>[38;2;%lu;%lu;%lum"
    let &t_8b = "\<Esc>[48;2;%lu;%lu;%lum"
    set termguicolors
  endif
  set background=dark
  colorscheme solarized8_flat
" --- }}}

" deoplete {{{
  "Plug 'ervandew/supertab'
  Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }
  let g:deoplete#enable_at_startup = 1
" --- }}}

" ultisnips  {{{
  Plug 'SirVer/ultisnips'
  Plug 'honza/vim-snippets'
  let g:UltiSnipsEditSplit = 'tabdo'
  let g:ultisnips_python_style = 'google'
  let g:UltiSnipsExpandTrigger = '<tab>'
  let g:UltiSnipsJumpForwardTrigger = '<tab>'
  let g:UltiSnipsJumpBackwardTrigger = '<s-tab>'
  "let g:UltiSnipsSnippetDirectories=[$HOME.'/.config/nvim/snippets']

" --- }}}

" tabular {{{
  Plug 'godlygeek/tabular'
" --- }}}

" vimwiki {{{
  Plug 'vimwiki/vimwiki'
  let g:vimwiki_list = [{'path': '~/Dropbox/notes/',
                       \ 'syntax': 'markdown', 'ext': '.md'}]
  nmap <Leader>wcr <Plug>VimwikiDiaryGenerateLinks

" --- }}}

" vim-instant-markdown {{{
  Plug 'suan/vim-instant-markdown'
  let g:instant_markdown_slow = 0
  let g:instant_markdown_mathjax = 0
  let g:instant_markdown_autostart = 0
  map <leader>md :InstantMarkdownPreview<CR>
" --- }}}

" calendar {{{
  Plug 'itchyny/calendar.vim'
  let g:calendar_google_calendar = 1
" --- }}}

" vimtex {{{
  Plug 'lervag/vimtex'
  if has("mac")
    let g:vimtex_view_general_viewer
        \ = '/Applications/Skim.app/Contents/SharedSupport/displayline'
    let g:vimtex_view_general_options = '-r -g @line @pdf @tex'
    let g:vimtex_view_general_options_latexmk = '-r -g 1'
  else
    let g:vimtex_view_method = "zathura"
    let g:latex_view_general_viewer = "zathura"
  endif
  "
  let g:tex_conceal = ""
  let g:vimtex_compiler_latexmk = {
      \ 'background' : 1,
      \ 'callback' : 1,
      \ 'continuous' : 0,
      \ 'executable' : 'latexmk',
      \ 'options' : [
      \   '-lualatex',
      \   '-silent',
      \   '-synctex=1',
      \   '-interaction=nonstopmode',
      \ ]}
" --- }}}
 
" emmet {{{
  Plug 'mattn/emmet-vim'
" --- }}}

" all of your plugs must be added before the following line
  call plug#end()

" =============================   end of file   ====================================

