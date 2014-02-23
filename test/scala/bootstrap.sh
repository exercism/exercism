#!/bin/bash
# This installs Scala for Travis
set -x
set -e
wget http://apt.typesafe.com/repo-deb-build-0002.deb
sudo dpkg -i repo-deb-build-0002.deb
sudo apt-get update
sudo apt-get install scala sbt
