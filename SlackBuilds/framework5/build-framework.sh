#!/bin/sh

# Copyright 2012  Patrick J. Volkerding, Sebeka, Minnesota, USA
# All rights reserved.
#
# Copyright 2016 Willy Sudiarto Raharjo <willysr@slackware-id.org>
# All rights reserved.
#
# Based on the xfce-build-all.sh script by Patrick J. Volkerding
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

# Set to 1 if you'd like to install/upgrade package as they are built.
# This is recommended.
INST=1

# This is where all the compilation and final results will be placed
TMP=${TMP:-/tmp/}
OUTPUT=${OUTPUT:-/tmp}

# This is the original directory where you started this script
F5ROOT=$(pwd)

# Loop for all base packages
for dir in \
tier1/extra-cmake-modules \
tier1/attica-qt5 \
tier1/kitemviews \
tier1/threadweaver \
tier1/kcodecs \
tier1/kguiaddons \
tier1/kidletime \
tier1/kwidgetsaddons \
tier1/sonnet \
tier1/kconfig \
tier1/kwindowsystem \
tier1/solid \
tier1/karchive \
tier1/kdbusaddons \
tier1/kcoreaddons \
tier1/ki18n \
tier2/kauth \
tier2/kcrash \
tier2/kglobalaccel \
tier2/kjobwidgets \
tier2/kcompletion \
tier2/kdoctools \
tier2/kfilemetadata5 \
tier3/kconfigwidgets \
tier3/kservice \
tier3/kiconthemes \
tier3/ktextwidgets \
tier3/kxmlgui \
tier3/kbookmarks \
tier3/kio \
  ; do
  # Get the package name
  package=$(echo $dir | cut -f2- -d /)

  # Change to package directory
  cd $F5ROOT/$dir || exit 1
  . ./${package}.info
  wget $DOWNLOAD

  # Get the version
  version=$(cat ${package}.SlackBuild | grep "VERSION:" | head -n1 | cut -d "-" -f2 | rev | cut -c 2- | rev)

  # Get the build
  build=$(cat ${package}.SlackBuild | grep "BUILD:" | cut -d "-" -f2 | rev | cut -c 2- | rev)

  # The real build starts here
  TMP=$TMP OUTPUT=$OUTPUT sh ${package}.SlackBuild || exit 1
  if [ "$INST" = "1" ]; then
    PACKAGE=$(ls $OUTPUT/${package}-${version}-*-${build}*.txz 2>/dev/null)
    if [ -f "$PACKAGE" ]; then
      upgradepkg --install-new --reinstall "$PACKAGE"
    else
      echo "Error:  package to upgrade "$PACKAGE" not found in $OUTPUT"
      exit 1
    fi
  fi

  # back to original directory
  cd $F5ROOT
done
