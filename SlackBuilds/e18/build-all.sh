#!/bin/sh

# Copyright 2013 Willy Sudiarto Raharjo <willysr@slackware-id.org>
# All rights reserved.
#
# Redistribution and use of this script, with or without modification, is
# permitted provided that the following conditions are met:
#
# 1. Redistributions of this script must retain the above copyright
#    notice, this list of conditions and the following disclaimer.
#
#  THIS SOFTWARE IS PROVIDED BY THE AUTHOR ``AS IS'' AND ANY EXPRESS OR IMPLIED
#  WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF
#  MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED.  IN NO
#  EVENT SHALL THE AUTHOR BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
#  SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO,
#  PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS;
#  OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY,
#  WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR
#  OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF
#  ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

# This is where all the compilation and final results will be placed
TMP=${TMP:-/tmp}

# This is the original directory where you started this script
ROOT=$(pwd)

# Loop for all packages
for dir in \
  EFL \
  e_dbus \
  elementary \
  evas-generic-loaders \
  emotion-generic-players \
  terminology \
  python-EFL \
  connman \
  econnman \
  enlightenment \
  ; do
  # Get the package name
  package=$(echo $dir | cut -f2- -d /) 
  
  # Change to package directory
  cd $ROOT/$dir || exit 1 

  # Get the version
  version=$(cat ${package}.SlackBuild | grep "VERSION:" | cut -d "-" -f2 | rev | cut -c 2- | rev)

  # The real build starts here
  sh ${package}.SlackBuild || exit 1
  PACKAGE="${package}-$version-*.txz"
  if [ -f $TMP/$PACKAGE ]; then
    upgradepkg --install-new --reinstall $TMP/$PACKAGE
  else
    echo "Error:  package to upgrade "$PACKAGE" not found in $TMP"
    exit 1
  fi
  
  # back to original directory
  cd $ROOT
done
