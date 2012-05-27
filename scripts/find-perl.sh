#!/bin/bash
# This script generates a list of packages need to be rebuilt due to Perl 5.16 changes
# Source taken from http://git.server-speed.net/bin/plain/find-broken-perl-packages.sh
# Thanks to ArchLinux user, Florian Pritz
# Modified by Willy Sudiarto Raharjo, willysr@slackware-id.org
# Changelog
# May, 27 : Modified the script for Slackware by utilizing slackpkg instead of pacman
#           just show unique packages instead of duplicated packages
# 
perllibpath="/usr/lib/perl5/vendor_perl/auto/"

# Remove previous search
rm -rf /tmp/find-broken-perl-package*

tmpdir=$(mktemp -d /tmp/find-broken-perl-package.XXXXXXXX)
touch $tmpdir/{raw,slack}.txt
find "$perllibpath" -name "*.so" |
	while read file; do
		module=$(echo $file | sed \
				 -e "s|$perllibpath||" \
				 -e 's|/|::|g' \
				 -e 's|.so$||' \
				 -e 's|\(.*\)::.*$|\1|')
		output=$(perl -M$module -e1 2>&1)
		if grep -q "perl: symbol lookup error:" <<< $output; then
			sed -n 's|perl: symbol lookup error: \(.*\): undefined symbol: .*|\1|p' <<< $output >> $tmpdir/raw.txt			
		elif grep -q "Perl API version .* of .* does not match .*" <<< $output; then
			echo $file >> $tmpdir/raw.txt			
		fi
	done

content=`cat $tmpdir/raw.txt`
for package in $content 
do
  query=`echo "$package" | cut -d "/" -f8`
  # If detailed information is needed, remove the grep part
  slackpkg file-search "$query" | grep -E "upgrade|installed|uninstalled" >> $tmpdir/slack.txt; 
done

echo "List of packages need to be rebuilt due to Perl 5.16 changes:"
# Just show unique packages
cat $tmpdir/slack.txt | sort | uniq