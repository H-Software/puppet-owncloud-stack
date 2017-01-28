#!/bin/bash

source /etc/bashrc;

puppet apply $1 --test;
retval=$?;

if [[ $retval -eq 2 ]]; then
  exit 0;
else
  exit $retval;
fi;
