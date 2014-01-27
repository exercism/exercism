#!/bin/bash
# This installs PHP 5 for Travis
set -x
set -e
sudo apt-get install python-software-properties
yes | sudo add-apt-repository ppa:ondrej/php5
sudo apt-get update
yes | sudo apt-get install php5
