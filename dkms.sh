#!/bin/bash

src_dir='/usr/src/macbook12-bluetooth-0.1'
dkms_name='macbook12-bluetooth/0.1'
var_dkms_dir='/var/lib/dkms/macbook12-bluetooth'
cur_dir=$(cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd)

# specify uninstall with the -r or -u argument
while getopts :ru arg
do
    case "${arg}" in
        r) dkms_remove=true;;
        u) dkms_remove=true;;
    esac
done

if [[ $dkms_remove = true ]]; then
    [[ -e $var_dkms_dir ]] && rm -rf $var_dkms_dir && echo "removed $var_dkms_dir"
    [[ -e $src_dir ]] && rm -f $src_dir && echo "removed $src_dir"
    exit 0
fi

pushd $cur_dir > /dev/null

[[ ! -e $src_dir ]] && ln -sfn $cur_dir $src_dir
echo "dkms install -c dkms.conf --force -m $dkms_name"
dkms install -c dkms.conf --force -m $dkms_name

popd > /dev/null
