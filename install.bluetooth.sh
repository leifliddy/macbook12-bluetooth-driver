#!/bin/bash

kernel_version=$(uname -r | cut -d '-' -f1)  #ie 5.2.8
major_version=$(echo $kernel_version | cut -d '.' -f1)
minor_version=$(echo $kernel_version | cut -d '.' -f2)
build_dir='build'
update_dir="/lib/modules/$(uname -r)/updates"

patch_dir='patch_bluetooth'
bluetooth_dir="$build_dir/bluetooth-$kernel_version"

[[ ! -d $build_dir ]] && mkdir $build_dir
[[ -d $bluetooth_dir ]] && rm/ -rf $bluetooth_dir

# attempt to download linux-x.x.x.tar.xz kernel
wget -c https://cdn.kernel.org/pub/linux/kernel/v$major_version.x/linux-$kernel_version.tar.xz -P $build_dir

if [[ $? -ne 0 ]]; then
   # if first attempt fails, attempt to download linux-x.x.tar.xz kernel
   kernel_version=$major_version.$minor_version
   wget -c https://cdn.kernel.org/pub/linux/kernel/v$major_version.x/linux-$kernel_version.tar.xz -P $build_dir
fi

[[ $? -ne 0 ]] && echo "kernel could not be downloaded...exiting" && exit

echo "tar --strip-components=2 -xvf $build_dir/linux-$kernel_version.tar.xz linux-$kernel_version/drivers/bluetooth --directory=build/"
tar --strip-components=2 -xvf $build_dir/linux-$kernel_version.tar.xz linux-$kernel_version/drivers/bluetooth --directory=build/
mv bluetooth $bluetooth_dir
mv $bluetooth_dir/Makefile $bluetooth_dir/Makefile.orig
mv $bluetooth_dir/hci_bcm.c $bluetooth_dir/hci_bcm.c.orig
cp $patch_dir/Makefile $patch_dir/hci_bcm.c $bluetooth_dir/
cd $bluetooth_dir
make
make install

echo -e "\ncontents of $update_dir"
ls -lA $update_dir
