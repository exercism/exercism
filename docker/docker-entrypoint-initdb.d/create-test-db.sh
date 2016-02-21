#! /bin/sh

psql --username postgres <<EOF
  CREATE DATABASE "exercism_test" ;
EOF
