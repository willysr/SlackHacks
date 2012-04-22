#! /bin/bash

error()
{
	echo "$*. Exiting"
	exit
}

fpatch=`pwd`/vmware-7.1.3-2.6.36-generic.patch
basedir=/usr/lib/vmware/modules
ptoken="$basedir/source/.patched"
bdate=`date "+%F-%H:%M:%S"` || error "date utility didn't quite work. Hm"

[ "$UID" != "0" ] && error "You must be root to run this script"
[ -f "$ptoken" ] && error "$ptoken found. You have already patched your sources"
[ ! -d "$basedir/source" ] && error "You have forgotten to install VMWare :)"
[ ! -f "$fpatch" ] && error "$fpatch not found. Please, copy it to the current directory"
[ -z "`vmware-installer -l 2>&1 | grep 7\.1\.3`" ] && error "This patch is only for VMWare WorkStation 7.1.3"

tmpdir=`mktemp -d` || exit 1

cp -an "$basedir/source" "$basedir/source-backup-$bdate" || exit 2
echo "Modules sources have been backed up to '$basedir/source-backup-$bdate' directory"

cd "$tmpdir" || exit 3
find "$basedir/source" -name "*.tar" -exec tar xf '{}' \; || exit 4
patch -p1 < "$fpatch" || exit 7
tar cf vmmon.tar vmmon-only || exit 9
tar cf vsock.tar vsock-only || exit 10
cp -a *.tar "$basedir/source" || exit 11

touch "$ptoken"

vmware-modconfig --console --install-all

echo "All done"
echo "You can now safely delete $tmpdir directory"
