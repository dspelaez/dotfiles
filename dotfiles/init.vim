"==================================
"    Nombre:     $HOME/.config/nvim/init.vim
"    Autor:      Daniel Santiago
"    Github:     dspelaez/dotfiles
"    Fecha:      2015-05-05
"    Modificado: 2018-01-16
"==================================



" ============================= sintaxis y formato ===================================

" sincronizar rutas de nvim y python {{{
" ----------------------------------
  set runtimepath+=~/.vim,~/.vim/after
  set packpath+=~/.vim

  let g:loaded_python_provider = 1
  let g:python3_host_prog='/Users/danielsantiago/.miniconda/envs/neovim/bin/python'
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
  "let &colorcolumn=join(range(100,999),",")
  let &colorcolumn=join(range(100,100),",")
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
  set clipboard=unnamed
" --- }}}

" moverse entre buffers{{{
" -----------
  nnoremap <S-Tab> :bnext<CR>
" --- }}}

" mapear algunos comandos {{{
" -----------
  map <silent> <leader>m :w<CR>:make<CR><CR><CR>
  map <Esc><Esc> :w<CR>
  map Q mxgqip`x
" --- }}}

" folding methods {{{
" ---------------
  set foldmethod=marker
" --- }}}

"clear highlight in the last search {{{
  nnoremap <CR> :noh<CR><CR>
" --- }}}


" ============================= tipos de archivo ====================================
" text files {{{
" ----------
  filetype plugin on
  autocmd FileType markdown set spell spelllang=es
  autocmd FileType tex      set spell spelllang=es
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

" set the plugins path and initialize
  call plug#begin('~/.vim/plugged')

" NERDTree {{{
  Plug 'scrooloose/nerdtree', { 'on': 'NERDTreeToggle' }
  map <C-n> :NERDTreeToggle<CR>
" --- }}}

" NERDCommenter {{{
  Plug 'scrooloose/nerdcommenter'
" --- }}}

" Lightline {{{
  Plug 'itchyny/lightline.vim'
" --- }}}

" Color-scheme {{{
  Plug 'lifepillar/vim-solarized8'
  if exists('+termguicolors')
    let &t_8f = "\<Esc>[38;2;%lu;%lu;%lum"
    let &t_8b = "\<Esc>[48;2;%lu;%lu;%lum"
    set termguicolors
  endif
  set background=dark
  colorscheme solarized8_flat
" --- }}}

" vim-jupyternotebook {{{
  Plug 'szymonmaszke/vimpyter'
  "autocmd Filetype ipynb nmap <silent><Leader>b :VimpyterInsertPythonBlock<CR>
  "autocmd Filetype ipynb nmap <silent><Leader>j :VimpyterStartJupyter<CR>
  "autocmd Filetype ipynb nmap <silent><Leader>n :VimpyterStartNteract<CR>
" --- }}}

" supertab {{{
  Plug 'ervandew/supertab'
  let g:SuperTabDefaultCompletionType = "context"
" --- }}}

" deoplete {{{
  Plug 'ervandew/supertab'
  Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }
  let g:deoplete#enable_at_startup = 1
" --- }}}

" ultisnips  {{{
  Plug 'SirVer/ultisnips'
  Plug 'honza/vim-snippets'
  "let g:ycm_key_list_select_completion = ['<C-n>', '<Down>']
  "let g:ycm_key_list_previous_completion = ['<C-p>', '<Up>']
  let g:ultisnips_python_style = 'google'
  "let g:SuperTabDefaultCompletionType = '<C-n>'
  let g:UltiSnipsExpandTrigger='<tab>'
  let g:UltiSnipsJumpForwardTrigger='<tab>'
  let g:UltiSnipsJumpBackwardTrigger='<s-tab>'
" --- }}}

" Vim-Templates {{{
  Plug 'aperezdc/vim-template'
  let g:email = "dpelaez@cicese.edu.mx"
  let g:user = "Daniel Santiago"
  let g:license = "GNU/GPL"
" --- }}}

" Tabular {{{
  Plug 'godlygeek/tabular'
" --- }}}

" VimWiki {{{
  Plug 'vimwiki/vimwiki'
  Plug 'suan/vim-instant-markdown'
  let g:vimwiki_root = '$HOME/Data/notes'
  let g:vimwiki_ext2syntax = {'.md': 'markdown', '.markdown': 'markdown', '.mdown': 'markdown'}
  let g:instant_markdown_autostart = 0
  map <leader>md :InstantMarkdownPreview<CR>
" --- }}}

" Calendar {{{
  Plug 'itchyny/calendar.vim'
  let g:calendar_google_calendar = 1
" --- }}}

" Vimtex {{{
  Plug 'lervag/vimtex'
  let g:tex_conceal = ""
  let g:vimtex_view_general_viewer
      \ = '/Applications/Skim.app/Contents/SharedSupport/displayline'
  let g:vimtex_view_general_options = '-r -g @line @pdf @tex'
  let g:vimtex_view_general_options_latexmk = '-r -g 1'
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
 
" Emmet {{{
  Plug 'mattn/emmet-vim'
" --- }}}

" All of your Plugs must be added before the following line
  call plug#end()

" ============================= fin del archivo  ====================================

