#!/bin/bash
echo "******CREATING DATABASE******"
gosu postgres postgres --single <<- EOSQL
   CREATE DATABASE exercism_development;
EOSQL
echo ""
echo "******DATABASE CREATED*******"