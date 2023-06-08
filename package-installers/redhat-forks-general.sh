#!/usr/bin/env bash

# !ok CentOS (tested on 7.??)
#  ok Rocky Linux (tested on Green Obsidian)
#  ok Oracle Linux (tested on 8)

yum update -y
yum groupinstall -y 'Development Tools'
yum install -y gcc-gfortran openssl-devel.x86_64 tmux vim
