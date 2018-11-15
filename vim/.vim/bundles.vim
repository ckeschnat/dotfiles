" Put bundles here
if has('python')
    NeoBundle 'SirVer/ultisnips'
    NeoBundle 'honza/vim-snippets'
    NeoBundle 'Trevoke/ultisnips-rspec'
endif
NeoBundle 'tomtom/tcomment_vim'
NeoBundle 'matchit.zip'
NeoBundle 'scrooloose/syntastic'
NeoBundle 'itchyny/lightline.vim'
NeoBundle 'cocopon/lightline-hybrid.vim'
NeoBundleLazy 'tpope/vim-rails'
autocmd FileType ruby NeoBundleSource vim-rails
NeoBundle 'tpope/vim-bundler'
NeoBundleLazy 'vim-ruby/vim-ruby'
autocmd FileType ruby NeoBundleSource vim-ruby
NeoBundle 'tpope/vim-surround'
NeoBundle 'tpope/vim-repeat'
NeoBundle 'tpope/vim-abolish.git'
NeoBundle 'tpope/vim-fugitive'
NeoBundle 'tpope/vim-unimpaired'
NeoBundle 'tpope/vim-haml'
NeoBundle 'docunext/closetag.vim'
NeoBundle 'rhysd/clever-f.vim'
NeoBundle 'benmills/vimux'
NeoBundle 'cakebaker/scss-syntax.vim'
NeoBundle 'Keithbsmiley/rspec.vim'
NeoBundle 'airblade/vim-rooter'
NeoBundle 'kana/vim-textobj-user'
NeoBundleLazy 'nelstrom/vim-textobj-rubyblock'
autocmd FileType ruby NeoBundleSource vim-textobj-rubyblock
NeoBundle 'tpope/vim-endwise'
NeoBundle 'justinmk/vim-sneak'
NeoBundle 'kien/rainbow_parentheses.vim'
NeoBundle 'terryma/vim-expand-region'
NeoBundle 'wellle/targets.vim'
NeoBundle 'christoomey/vim-tmux-navigator'
NeoBundle 'vim-scripts/gitignore'
NeoBundle 'airblade/vim-gitgutter'
NeoBundle 'Raimondi/delimitMate'
if has('lua')
    NeoBundle 'Shougo/neocomplete.vim'
endif
NeoBundle 'slim-template/vim-slim'
NeoBundle 'Shougo/unite.vim'
NeoBundle 'Shougo/vimproc', {
      \ 'build' : {
      \     'windows' : 'mingw32-make -f make_mingw32.mak',
      \     'cygwin' : 'make -f make_cygwin.mak',
      \     'mac' : 'make -f make_mac.mak',
      \     'unix' : 'make -f make_unix.mak',
      \    },
      \ }
NeoBundle 'junegunn/vim-pseudocl'
NeoBundle 'junegunn/vim-oblique'
NeoBundle 'wesQ3/vim-windowswap'
NeoBundle 'ConradIrwin/vim-bracketed-paste'
NeoBundle 'machakann/vim-textobj-delimited'
NeoBundle 'thoughtbot/vim-rspec'
NeoBundle 'tpope/vim-dispatch'
NeoBundle 'tommcdo/vim-exchange'
NeoBundle 'rodjek/vim-puppet.git'
NeoBundle 'godlygeek/tabular'
NeoBundle 'saltstack/salt-vim'
NeoBundle 'Z1MM32M4N/vim-superman'
NeoBundle 'vim-scripts/diffchar.vim'
NeoBundle 'vim-scripts/ReplaceWithRegister'
NeoBundle 'lepture/vim-velocity'
NeoBundle 'ap/vim-css-color'
NeoBundle 'robbles/logstash.vim'
