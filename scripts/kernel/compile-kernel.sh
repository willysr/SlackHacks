#!/bin/bash
#
# Script to automate kernel compilation
#
# Place this script in /usr/src, chmod +x it to make it executable
# This script must be run as root
#
# Initial script by Robby Workman <http://rlworkman.net/>
# Slightly modified by Willy Sudiarto Raharjo <willysr@gmail.com>
#
VERSION='3.9.3' # change to reflect actual kernel version
CWD='/usr/src' # /usr/src directory
cd $CWD
#
# Remove /usr/src/linux symlink
rm -f /usr/src/linux
#
# Symlink /usr/src/linux-$VERSION to /usr/src/linux
ln -s /usr/src/linux-$VERSION /usr/src/linux
#
# Switch to the kernel source directory
cd $CWD/linux-$VERSION
#
# Copy the old configuration from /boot
cp /boot/config ./.config
#
# Make the kernel image, Compile, and Install The Modules
make oldconfig && make bzImage && make modules && make modules_install
#
# Make symlink to fix some problems on NVidia/VMWare compilation
ln -s /usr/src/linux-$VERSION/include/generated/uapi/linux/version.h /usr/src/linux-$VERSION/include/linux/version.h
#
# Remove old symlinks, copy new files into /boot, and make new symlinks
cd /boot
rm -f vmlinuz System.map config
cp $CWD/linux-$VERSION/.config config-$VERSION
cp $CWD/linux-$VERSION/System.map /boot/System.map-$VERSION
cp $CWD/linux-$VERSION/arch/x86/boot/bzImage /boot/vmlinuz-$VERSION
ln -s vmlinuz-$VERSION vmlinuz
ln -s System.map-$VERSION System.map
ln -s config-$VERSION config
#
# The last line above placed a copy of your kernel config file in /boot
# (just in case)
#
# All you need to do now is update /etc/lilo.conf (explicitly add your
# old kernel to the bottom of the file - use the ones already there to
# establish the pattern required for correct syntax) and then run
# /sbin/lilo -v
#
# You might try /sbin/lilo -c if you want to speed up boot times, but
# there's no guarantee that it will work with your system
#
# After you've verified that the kernel boots and works properly, you
# can safely delete the /boot-old directory created by this script
# (do rm -R /boot-old) --don't make a typo here, though! :-)
#
# Good luck!
