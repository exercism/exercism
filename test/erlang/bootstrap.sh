#!/bin/bash
# This installs Erlang R16B02 for Travis-CI
# https://www.erlang-solutions.com/downloads/download-erlang-otp
set -x
set -e
(
    cd /tmp && \
    wget http://packages.erlang-solutions.com/erlang-solutions_1.0_all.deb && \
    sudo dpkg -i erlang-solutions_1.0_all.deb \
)
sudo apt-get update
sudo apt-get -y install erlang