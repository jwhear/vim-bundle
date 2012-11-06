Install pathogen in ~/.vim/autoload:
```sh
mkdir -p ~/.vim/autoload
curl -so ~/.vim/autoload/pathogen.vim https://raw.github.com/tpope/vim-pathogen/master/autoload/pathogen.vim
```

Clone into .vim:
```sh
git clone http://github.com/jwhear/vim-bundle.git bundle
```

Grab the submodules:
```sh
git submodule update --init
```

Create symlinks in $HOME:
```sh
  ln -s .vimrc ~/.vimrc
  ln -s .gvimrc ~/.gvimrc
```
