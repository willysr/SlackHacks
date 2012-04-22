#! /bin/bash
# VMWare Workstation/Player _host kernel modules_ patcher v0.6.2 by ©2010 Artem S. Tashkinov
# Use at your own risk.

fpatch=vmware-7.1.3-2.6.37-2-generic.patch
vmreqver=7.1.3
plreqver=3.1.3

error()
{
	echo "$*. Exiting"
	exit
}

curdir=`pwd`
bdate=`date "+%F-%H:%M:%S"` || error "date utility didn't quite work. Hm"
vmver=`vmware-installer -l 2>/dev/null | awk '/vmware-/{print $1substr($2,1,5)}'`
vmver="${vmver#vmware-}"
basedir=/usr/lib/vmware/modules/source
ptoken="$basedir/.patched"
bkupdir="$basedir-$vmver-$bdate-backup"

unset product
[ -z "$vmver" ] && error "VMWare is not installed (properly) on this PC"
[ "$vmver" == "workstation$vmreqver" ] && product="VMWare WorkStation"
[ "$vmver" == "player$plreqver" ] && product="VMWare Player"
[ -z "$product" ] && error "Sorry, this script is only for VMWare WorkStation $vmreqver or VMWare Player $plreqver"

[ "`id -u`" != "0" ] && error "You must be root to run this script"
[ -f "$ptoken" ] && error "$ptoken found. You have already patched your sources"
[ ! -d "$basedir" ] && error "Source '$basedir' directory not found, reinstall $product"
[ ! -f "$fpatch" ] && error "'$fpatch' not found. Please, copy it to the current '$curdir' directory"

tmpdir=`mktemp -d` || exit 1
cp -an "$basedir" "$bkupdir" || exit 2

cd "$tmpdir" || exit 3
find "$basedir" -name "*.tar" -exec tar xf '{}' \; || exit 4

patch -p1 < "$curdir/$fpatch" || exit 5
tar cf  vmci.tar  vmci-only || exit 6
tar cf vsock.tar vsock-only || exit 7
tar cf vmnet.tar vmnet-only || exit 8
tar cf vmmon.tar vmmon-only || exit 9

cp -a *.tar "$basedir" || exit 10
rm -rf "$tmpdir" || exit 11
touch "$ptoken" || exit 12
cd "$curdir" || exit 13

vmware-modconfig --console --install-all

echo -e "\n"
echo "All done, you can now run $product."
echo "Modules sources backup can be found in the '$bkupdir' directory"
