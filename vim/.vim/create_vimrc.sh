#!/bin/bash
cat > ~/.vimrc <<DELIM
function! MySys()
    return "unix"
endfunction

" Enable loading of plugins
let g:enable_all_plugins = 1

source ~/.vim/vimrc
DELIM
