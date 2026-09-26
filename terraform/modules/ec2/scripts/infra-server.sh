#!/bin/bash
set -e

sudo apt update -y

sudo apt install -y \
    ansible \
    git \
    tree \
    bash-completion

if [ -f /etc/profile ]; then
    source /etc/profile
fi