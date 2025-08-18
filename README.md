Patch/Compile/Install bluetooth driver for:

############## MY PERSONAL REMARKS ########################

I customized the installation script in order to support any linux kernel, for example the 'linux-mainline' as well as the 'linux-libre' with the possibility for the user to provide the website link to download the tar file of his custom linux kernel. For further information, check the comments of my customized script which explains in details the changes and enhancement.

To use it, only need to run the custom script with sudo from this repo.

For the moment, it works (successfully tested) with :
- Arch Linux

############## REMARKS FROM THE OFFICIAL DIR ##############

Macbook Pro models: 13,1 and 14,1
Macbook 12 inch models (2015 and later): 8,1 + 9,1 + 10,1

**Kernels supported**:
\>= 5.0

**Patch info**:  (changes made by ```install.bluetooth.sh``` are based off this patch)
https://github.com/christophgysin/linux/commit/ddf622a0a19697af473051c8019fffc1eb66efe7

**Discussion of Macbook bluetooth issue:**
https://github.com/Dunedan/mbp-2016-linux/issues/29

**Installation Instructions**
-------------

**prerequisites**
Enure the necessary packages are installed:


**fedora package install**
```
dnf install dkms gcc kernel-devel make wget
```
**ubuntu package install**
```
 apt install dkms gcc make linux-headers-generic wget
```
**arch package install**
```
pacman -S dkms gcc make linux-headers wget
```
1. **build and install dkms module** (experimental feature)  
this will build the module for the current/active kernel  
and will auto-compile this module whenever you install a newer kernel  
```
git clone https://github.com/leifliddy/macbook12-bluetooth-driver.git
cd macbook12-bluetooth-driver/
# run the following command as root or with sudo
./install.bluetooth.sh -i

# to uninstall the dkms feature run:
./install.bluetooth.sh -u
```

2. (backup method if dkms didn't work) **manually build and install module for current kernel**
```
git clone https://github.com/leifliddy/macbook12-bluetooth-driver.git
cd macbook12-bluetooth-driver/
# run the following command as root or with sudo
./install.bluetooth.sh
reboot
```

```install.bluetooth.sh``` will auto-patch the ```hci_bcm.c``` source file and then compile and install the ```hci_uart``` module
