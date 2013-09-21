#!/bin/bash
# This installs a Haskell platform to PREFIX=/opt/hp-2013.2.0.0
set -x
set -e
HP_VER=2013.2.0.0
HP_URL=https://github.com/etrepum/travis-haskell/releases/download/${HP_VER}/hp-${HP_VER}.tar.bz2
PREFIX=/opt/hp-${HP_VER}
sudo apt-get -y install git gcc make autoconf libtool zlib1g-dev \
  libncurses-dev libgmp-dev
if [ ! -e "/usr/lib/libgmp.so.3" ]; then
  sudo ln -s /usr/lib/x86_64-linux-gnu/libgmp.so.10 /usr/lib/libgmp.so.3
fi
if [ ! -e "/usr/lib/libgmp.so" ]; then
  sudo ln -s /usr/lib/x86_64-linux-gnu/libgmp.so.10 /usr/lib/libgmp.so
fi
if [ ! -e "${PREFIX}" ]; then
  ( cd /
    curl -L "${HP_URL}" | sudo tar jxf - )
fi
sudo chmod ugo+rX -R "${PREFIX}"
