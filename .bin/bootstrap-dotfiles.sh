#!/bin/bash
DOTFILESDIR=$(cd "$(dirname "$0")"; pwd)
export LC_ALL="en_US.UTF-8"

cd "$DOTFILESDIR"
git pull
git submodule init
git submodule update --remote

mkdir .zsh/completion
curl -L https://raw.githubusercontent.com/sdurrheimer/docker-compose-zsh-completion/master/_docker-compose > .zsh/completion/_docker-compose

cd "$HOME"
for F in $(ls -A "$DOTFILESDIR"); do
  rm -Irf "$F"
  ln -s "$DOTFILESDIR/$F"
done
rm .git .gitmodules bootstrap.sh

tmux source-file ~/.tmux.conf
