#!/bin/bash

if [ "$1" = 'web' ]; then
  rake db:migrate
  foreman s
fi