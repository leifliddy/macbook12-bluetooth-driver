Patch/Compile/Install bluetooth driver for:

Macbook Pro models: 13,1 and 14,1  
Macbook 12 inch models (2015 and later): 8,1 + 9,1 + 10,1  

**Kernels supported**:  
5.0 to 5.9

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
dnf install wget make gcc kernel-devel
```
**ubuntu package install**
```
apt install wget make gcc linux-headers-generic
```
**arch package install**
```
pacman -S wget symlinks make gcc linux-headers
```
**build and install driver**
```
git clone https://github.com/leifliddy/macbook12-bluetooth-driver.git
cd macbook12-bluetooth-driver/
./install.bluetooth.driver.sh
reboot
```


```install.bluetooth.sh``` will auto-patch the ```hci_bcm.c``` source file and then compile and install the ```hci_uart``` module


```install.bluetooth.sh``` is designed to be run on the Macbook itself (running Linux obviously).  
It will compile the ```hci_uart``` module for the currently running/active kernel (based on the ```uname -r``` output)  
However, this script can be easily modified to suit any number of use-case scenarios. 
