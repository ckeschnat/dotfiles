On Windows, rename 'vimfiles' to '.vim' (rename it to '.vim.',
windows explorer will remove the trailing dot).
Create a vimrc with the following content (on linux 'create_vimrc.sh' can be used):

    function! MySys()
        return "windows"
    endfunction
    " Uncomment to disable loading of plugins
    " let g:disable_all_plugins = 1

    source ~/.vim/vimrc

Plugins are managed with [NeoBundle](https://github.com/Shougo/neobundle.vim),
which is installed automatically upon first usage.

Using Unite as CtrlP replacement on windows requires mingw (see vimproc README)
and a search tool, e.g.
http://blog.kowalczyk.info/software/the-silver-searcher-for-windows.html
Also, on windows vimproc doesn't get compiled automatically. Run

    mingw32-make -f make_mingw32.mak

once in .vim/bundle/vimproc
