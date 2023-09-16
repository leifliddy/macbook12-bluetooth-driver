#!/bin/bash

path="$(pwd)"
echo "Current path is: $path"

UNAME_V=$(uname -v)
UNAME_R=$1 # From DKMS

kernel_version=$(echo -n $UNAME_R | cut -d '-' -f1)  #ie 5.2.7

echo "Kernel version $kernel_version (from '$UNAME_R'; '$UNAME_V') on $(uname -r)"

major_version=$(echo $kernel_version | cut -d '.' -f1)
minor_version=$(echo $kernel_version | cut -d '.' -f2)
kernel_short_version="$major_version.$minor_version" #ie 5.2

build_dir='build'
update_dir="/lib/modules/$(uname -r)/updates"

patch_dir='patch_bluetooth'
bluetooth_dir="$build_dir/bluetooth-$kernel_version"

[[ ! -d $update_dir ]] && mkdir $update_dir
[[ ! -d $build_dir ]] && mkdir $build_dir
[[ -d $bluetooth_dir ]] && rm -rf $bluetooth_dir

# attempt to download linux-x.x.x.tar.xz kernel
wget -c https://cdn.kernel.org/pub/linux/kernel/v$major_version.x/linux-$kernel_version.tar.xz -P $build_dir

if [[ $? -ne 0 ]]; then
   # if first attempt fails, attempt to download linux-x.x.tar.xz kernel
   kernel_version=$kernel_short_version
   wget -c https://cdn.kernel.org/pub/linux/kernel/v$major_version.x/linux-$kernel_version.tar.xz -P $build_dir
fi

[[ $? -ne 0 ]] && echo "kernel could not be downloaded...exiting" && exit

echo "tar --strip-components=2 -xvf $build_dir/linux-$kernel_version.tar.xz linux-$kernel_version/drivers/bluetooth --directory=build/"
tar --strip-components=2 -xvf $build_dir/linux-$kernel_version.tar.xz linux-$kernel_version/drivers/bluetooth --directory=build/
mv bluetooth $bluetooth_dir
mv $bluetooth_dir/Makefile $bluetooth_dir/Makefile.orig
cp -p $bluetooth_dir/hci_bcm.c $bluetooth_dir/hci_bcm.c.orig
cp $patch_dir/Makefile $bluetooth_dir/
[[ $(echo "$kernel_short_version" | grep '^5\.[0-1]$') ]] && cp $patch_dir/hci_bcm.kernel_5.0_5.1.c $bluetooth_dir/hci_bcm.c
cd $bluetooth_dir

########################################### patch hci_bcm.c ###############################################
#patch hci_bcm.c according to
#https://github.com/christophgysin/linux/commit/ddf622a0a19697af473051c8019fffc1eb66efe7


#hci_bcm.c 
#remove the following (consecutive) lines

#       err = dev->set_device_wakeup(dev, powered);
#       if (err)
#               goto err_revert_shutdown;
#

sed -i '/err = dev->set_device_wakeup(dev, powered);/,+3 d' hci_bcm.c

#err_revert_shutdown:
#       dev->set_shutdown(dev, !powered);

sed -i '/^err_revert_shutdown:$/,+1 d' hci_bcm.c
###########################################################################################################

make
cp $path/$bluetooth_dir/hci_uart.ko $path

