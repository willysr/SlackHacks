#!/bin/bash
# Copyright 2013 Willy Sudiarto Raharjo <willysr@slackware-id.org>
# All rights reserved.
#
# Redistribution and use of this script, with or without modification, is
# permitted provided that the following conditions are met:
#
# 1. Redistributions of this script must retain the above copyright
# notice, this list of conditions and the following disclaimer.
#
# THIS SOFTWARE IS PROVIDED BY THE AUTHOR "AS IS" AND ANY EXPRESS OR IMPLIED
# WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF
# MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO
# EVENT SHALL THE AUTHOR BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
# SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO,
# PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS;
# OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY,
# WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR
# OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF
# ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

# Put the directory where you place the SlackBuild Git Repository
SBOPATH="/home/willysr/slackbuilds/"

# Put the name of the maintainer you want to search for
# By default it's empty, so it will search for everyone
# To override it, call the script with MAINTAINER=someone ./list-maintainer.sh
MAINTAINER="${MAINTAINER:-}"

TEMP=/tmp/list-maintainer.tmp
rm -rf $TEMP

L=`find $SBOPATH -mindepth 1 -maxdepth 3 -name "*.info" -exec grep -l "$MAINTAINER" {} +`
for list in $L 
do
  MAINTAINER=$(cat $list | grep "MAINTAINER" | sed 's/MAINTAINER="//' | sed 's/"//')
  EMAIL=$(cat $list | grep "EMAIL" | sed 's/EMAIL="//' | sed 's/"//')
  # Replace [AT] or [at] with "@"
  EMAIL=$(echo $EMAIL | sed 's/\[AT\]/\@/gi')
  # Replace [ AT ] or [ at ] with "@"
  EMAIL=$(echo $EMAIL | sed 's/\[\sAT\s\]/\@/gi')
  # Replace {at} with "@"
  EMAIL=$(echo $EMAIL | sed 's/{AT}/\@/gi')
  # Replace <at> with "@"
  EMAIL=$(echo $EMAIL | sed 's/<AT>/\@/gi')
  # Replace <space>@<space> with "@"
  EMAIL=$(echo $EMAIL | sed 's/\s@\s/\@/gi')
  # Replace <space>at<space> with "@"
  EMAIL=$(echo $EMAIL | sed 's/\sat\s/\@/gi')
  # Replace [t] with "@"
  EMAIL=$(echo $EMAIL | sed 's/\[T\]/\@/gi')
  # Replace [underscore] with _
  EMAIL=$(echo $EMAIL | sed 's/\[underscore\]/\_/gi')
  # Replace [dot] with "."
  EMAIL=$(echo $EMAIL | sed 's/\[dot\]/\./gi')
  # Replace [ dot ] with "."
  EMAIL=$(echo $EMAIL | sed 's/\[\sdot\s\]/\./gi')
  # Replace {dot} with "."
  EMAIL=$(echo $EMAIL | sed 's/{dot}/\./gi')
  # Replace <space>.<space> with "."
  EMAIL=$(echo $EMAIL | sed 's/\s.\s/\./gi')
  # Replace <space>dot<space> with "."
  EMAIL=$(echo $EMAIL | sed 's/\sdot\s/\./gi')
  echo $MAINTAINER - $EMAIL >> $TEMP
done

cat $TEMP | sort -u

