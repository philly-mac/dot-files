#!/bin/bash

sudo apt-get install -y vim exuberant-ctags

if [[ -d ~/.vim ]] && [[ ! -L ~/.vim ]]; then
  mv ~/.vim ~/.vim.old
fi

[[ ! -L ~/.vim ]] && ln -s ~/.bash/vim ~/.vim


if [[ -e ~/.vimrc ]] && [[ ! -L ~/.vimrc ]]; then
  mv ~/.vimrc ~/.vimrc.old
fi

[[ ! -L ~/.vimrc ]] && ln -s ~/.bash/vim/vimrc ~/.vimrc

#[[ -f ~/.bash/include ]] && source ~/.bash/include
