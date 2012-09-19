#!/bin/bash
# Put the directory where you place the SlackBuild Git Repository
SBOPATH="/home/willysr/slackbuilds"

# Put the name of the maintainer you want to search for
MAINTAINER="Willy Sudiarto Raharjo"

# list all directory in SlackBuild GIT repository
for L in `ls $SBOPATH`; do
  # only continue if it's a directory
  if [ -d "$SBOPATH/$L" ]; then
    # list all files within this directory
    for D in `ls $SBOPATH/$L`; do
      # test for maintainer's name in PACKAGE.info file
      cat "/home/willysr/slackbuilds/$L/$D/$D.info" | grep "$MAINTAINER" 1> /dev/null
      if [ $? -eq 0 ]; then
	echo "$L/$D";
      fi
    done
  fi
done
