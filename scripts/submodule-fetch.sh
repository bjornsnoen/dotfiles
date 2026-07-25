#!/usr/bin/env bash

git -c url."https://github.com/".insteadOf="git@github.com:" \
    -c url."https://github.com/".insteadOf="ssh://git@github.com/" \
    submodule update --init --recursive
