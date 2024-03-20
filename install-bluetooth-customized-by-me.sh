#!/bin/bash

while [ $# -gt 0 ]
do
    case $1 in
    -i|--install) dkms_action='install';;
    -k|--kernel) dkms_kernel=$2; [[ -z $dkms_kernel ]] && echo '-k|--kernel must be followed by a kernel version' && exit 1;;
    -r|--remove) dkms_action='remove';;
    -u|--uninstall) dkms_action='remove';;
    (-*) echo "$0: error - unrecognized option $1" 1>&2; exit 1;;
    (*) break;;
    esac
    shift
done

if [[ $dkms_action == 'install' ]]; then
    bash dkms.sh
    exit
elif [[ $dkms_action == 'remove' ]]; then
    bash dkms.sh -r
    exit
fi

[[ -n $dkms_kernel ]] && uname_r=$dkms_kernel || uname_r=$(uname -r)
kernel_version=$(echo $uname_r | cut -d '-' -f1) #ie 6.4.15

major_version=$(echo $kernel_version | cut -d '.' -f1)
minor_version=$(echo $kernel_version | cut -d '.' -f2)
major_minor=${major_version}${minor_version}
kernel_short_version="$major_version.$minor_version" #ie 5.2

build_dir="build"
patch_dir='patch_bluetooth'
bluetooth_dir="$build_dir/bluetooth"

[[ -d $bluetooth_dir ]] && rm -rf $bluetooth_dir
[[ ! -d $build_dir ]] && mkdir $build_dir

# attempt to download linux-x.x.x.tar.xz kernel
KERNEL_DOWNLOAD_TAR_URL="https://cdn.kernel.org/pub/linux/kernel/v$major_version.x/linux-$kernel_version.tar.xz"
wget -c "$KERNEL_DOWNLOAD_TAR_URL" -P $build_dir

if [[ $? -ne 0 ]]; then
   # if first attempt fails, attempt to download linux-x.x.tar.xz kernel
   kernel_version=$kernel_short_version
   KERNEL_DOWNLOAD_TAR_URL="https://cdn.kernel.org/pub/linux/kernel/v$major_version.x/linux-$kernel_version.tar.xz"
   wget -c "$KERNEL_DOWNLOAD_TAR_URL" -P $build_dir
fi

# if second attemps fails, attemp to download kernel from url provided by the script user
[[ $? -ne 0 ]] &&
{ echo "kernel could not be downloaded... Retry by manually writing the url of the kernel tar file." && read -p "IMPORTANT:

So far, the download of the tar file failed... But : 

If you are using a custom kernel (as for example the 'mainline'),
please carefully copy/paste the link to the tarball (format tar.xz or tar.gz) file here and then type 'enter'.

Be cautious, this is custom script adaptation without further checks...
" KERNEL_DOWNLOAD_TAR_URL && wget -c "$KERNEL_DOWNLOAD_TAR_URL" -P $build_dir && FLAG_URL_PROVIDED_BY_USER="true"
# Test is the third attempt to 'wget' returned an error and exit if so
[[ $? -ne 0 ]] && echo "the custom kernel could not be downloaded...exiting" && exit
}

# Get the extension of tar file (+'tar.') : so tar.xz or tar.gz
END_OF_TAR_FILE="${KERNEL_DOWNLOAD_TAR_URL%/}" # remove eventual ending slash
BEGINNING_OF_URL_WITHOUT_END="${END_OF_TAR_FILE%tar.*}"
END_OF_TAR_FILE="${END_OF_TAR_FILE##$BEGINNING_OF_URL_WITHOUT_END}"

# Get the kernel version if it is special kernel or if provided manually
if [ "$FLAG_URL_PROVIDED_BY_USER" = "true" ]
then
    kernel_version="${BEGINNING_OF_URL_WITHOUT_END##*/}"
    kernel_version="${kernel_version##linux-}" # removing the 'linux-'
    kernel_version="${kernel_version%.}" # removing any eventual ending dot
fi

# remove old kernel tar.xz archives
find build/ -type f | grep -E linux.*.${END_OF_TAR_FILE} | grep -v $kernel_version.${END_OF_TAR_FILE} | xargs rm -f

tar --strip-components=2 -xvf $build_dir/linux-$kernel_version.${END_OF_TAR_FILE} --directory=build/ linux-$kernel_version/drivers/bluetooth

mv $bluetooth_dir/Makefile $bluetooth_dir/Makefile.orig
cp -p $bluetooth_dir/hci_bcm.c $bluetooth_dir/hci_bcm.c.orig
cp $patch_dir/Makefile $bluetooth_dir/
[[ $(echo "$kernel_short_version" | grep '^5\.[0-1]$') ]] && cp $patch_dir/hci_bcm.kernel_5.0_5.1.c $bluetooth_dir/hci_bcm.c
pushd $bluetooth_dir > /dev/null

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
popd > /dev/null

update_dir="/lib/modules/$(uname -r)/updates"
[[ ! -d $update_dir ]] && mkdir $update_dir
make
make install
echo -e "\ncontents of $update_dir" && ls -lA $update_dir
exit 0
