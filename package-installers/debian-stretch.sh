#!/usr/bin/env bash

#
# provides a downgraded zlib1g, stretch has the right version
# of gfortran also
#

echo "deb http://archive.debian.org/debian stretch main contrib non-free" > /etc/apt/sources.list
apt-get update
apt-get install -y build-essential checkinstall
apt-get install -y libssl-dev libexpat1-dev
apt-get install -y gfortran wget curl vim screen htop tmux git sudo bc
apt-get install -y zip flex gawk procps
apt-get install -y --allow-downgrades zlib1g=1:1.2.8.dfsg-5
apt-get install -y zlib1g-dev
