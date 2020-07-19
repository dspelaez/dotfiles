"========================================
" @file:    $HOME/.config/nvim/init.vim
" @author:  Daniel Santiago
" @github:  dspelaez/dotfiles
" @created: 2015-05-05
" @updated: 2019-08-26
"=========================================

" ========================== sintaxis y formato ================================
" sincronizar rutas de nvim y python {{{
" ----------------------------------
  "set runtimepath+=~/.vim,~/.vim/after
  "set packpath+=~/.config/nvim/plugged

  let g:loaded_python_provider = 1
  let g:python3_host_prog=expand('~/.miniconda/envs/neovim/bin/python')
" --- }}}

" habilitar sintaxis y numeros de lineas {{{
" ---------------------------------------
  syntax enable
  set relativenumber
  set number
  set noshowmode
  set laststatus=2
  set showtabline=2
  set guioptions-=e
  set noswapfile
" --- }}}

" configurar indentado {{{
" --------------------
  set expandtab
  set shiftwidth=2
  set softtabstop=2
" --- }}}

" configurar columnas {{{
" -------------------
  set signcolumn=yes
  set textwidth=80
  let &colorcolumn=join(range(85,85),",")
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

" mapear algunos comandos {{{
" -----------
  let mapleader = ","
  let maplocalleader = ','
  map <Esc><Esc> :w<CR>
  map Q mxgqip`x
" --- }}}


" ========================== tipos de archivo =================================
" text files {{{
" ----------
  filetype plugin on
  autocmd FileType markdown set spell spelllang=en,es
  autocmd FileType tex      set spell spelllang=en,es
" --- }}}

" python files {{{
" ------------
  autocmd FileType py set foldmethod=marker shiftwidth=2 softtabstop=2
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


" ==========================     plug-ins     =================================
" vim-plug {{{
  if empty(glob('~/.config/nvim/autoload/plug.vim'))
    silent !curl -fLo ~/.config/nvim/autoload/plug.vim --create-dirs
      \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
    autocmd VimEnter * PlugInstall --sync
  endif

  call plug#begin('~/.config/nvim/plugged')"

  Plug 'lifepillar/vim-solarized8'
  Plug 'scrooloose/nerdcommenter'
  Plug 'scrooloose/nerdtree', { 'on': 'NERDTreeToggle' }
  Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }
  Plug 'itchyny/lightline.vim'
  Plug 'honza/vim-snippets'
  Plug 'aperezdc/vim-template'
  Plug 'ervandew/supertab'
  Plug 'SirVer/ultisnips'
  Plug 'godlygeek/tabular'
  Plug 'junegunn/goyo.vim'
  Plug 'ledger/vim-ledger'
  Plug 'vimwiki/vimwiki'
  Plug 'plasticboy/vim-markdown'
  Plug 'iamcco/markdown-preview.nvim', { 'do': { -> mkdp#util#install() } }
  Plug 'itchyny/calendar.vim'
  Plug 'lervag/vimtex'
  Plug 'mattn/emmet-vim'

" all of your plugs must be added before the following line
  call plug#end()
" --- }}}

" color-scheme {{{
  if empty(glob('~/.config/nvim/pack/themes/opt/solarized8'))
    silent !git clone https://github.com/lifepillar/vim-solarized8.git
      \ ~/.config/nvim/pack/themes/opt/solarized8
  endif
  
  if exists('+termguicolors')
    let &t_8f = "\<Esc>[38;2;%lu;%lu;%lum"
    let &t_8b = "\<Esc>[48;2;%lu;%lu;%lum"
    set termguicolors
  endif
  set background=dark
  colorscheme solarized8_flat
" --- }}}

" nerd-tree {{{
  map <C-n> :NERDTreeToggle<CR>
" --- }}}

" vim-templates {{{
  let g:templates_no_builtin_templates = 1
  let g:templates_directory = "~/.config/nvim/templates"
  let g:username = "Daniel Santiago"
  let g:email = "http://github.com/dspelaez"
  let g:license = "GNU/GPL 3.0"
" --- }}}

" supertab {{{
  let g:SuperTabDefaultCompletionType = "<c-n>"
  let g:SuperTabContextDefaultCompletionType = "<c-n>"
" --- }}}

" deoplete {{{
  let g:deoplete#enable_at_startup = 1
" --- }}}

" ultisnips  {{{
  let g:UltiSnipsEditSplit = 'tabdo'
  let g:ultisnips_python_style = 'google'
  let g:UltiSnipsExpandTrigger = '<tab>'
  let g:UltiSnipsJumpForwardTrigger = '<tab>'
  let g:UltiSnipsJumpBackwardTrigger = '<s-tab>'
  "let g:UltiSnipsSnippetDirectories=[$HOME.'/.config/nvim/ultisnips']

" --- }}}

" vimwiki {{{
  let g:vimwiki_list = [{'path': '~/Dropbox/notes/',
                       \ 'syntax': 'markdown', 'ext': '.md'}]
  nmap <Leader>wgl <Plug>VimwikiDiaryGenerateLinks
  let g:vimwiki_table_mappings = 0
  let g:vimwiki_global_ext = 0
  nmap <c-k> <Plug>VimwikiNextLink
  nmap <c-j> <Plug>VimwikiPrevLink

" --- }}}

" markdown-preview {{{
  map <leader>md <Plug>MarkdownPreview
  let g:mkdp_refresh_slow = 0
  let g:mkdp_page_title = '${name}'
" --- }}}

" vim-markdown {{{
  let g:vim_markdown_math = 1
  let g:vim_markdown_frontmatter = 1
  let g:vim_markdown_folding_disabled = 1
  let g:vim_markdown_auto_insert_bullets = 0
  let g:vim_markdown_new_list_item_indent = 0
"--- }}}

" vimtex {{{
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
  let g:tex_comment_nospell = 1
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

" hledger {{{
  au BufNewFile,BufRead *.journal.md,*.ledger setf ledger | comp ledger
  let g:ledger_maxwidth = 60
  let g:ledger_fold_blanks = 1
" }}}

" ==========================   end of file   =================================
