Patch/Compile/Install bluetooth driver for

Macbook Pro models: 13,1 and 14,1

Macbook 12 inch models (2015 and later): 8,1 + 9,1 + 10,1


**Patch info**:

https://github.com/christophgysin/linux/commit/ddf622a0a19697af473051c8019fffc1eb66efe7



*Installation Instructions*
-------------

*prerequisites* 
Enure the necessary packages are installed:
 

**fedora package install**
```
dnf install wget make gcc kernel-devel
```
**ubuntu package install**
```
apt install wget make gcc linux-headers-generic
```


**build and install driver**
```
git clone https://github.com/leifliddy/macbook12-bluetooth-driver.git
cd macbook12-bluetooth-driver/
./install.bluetooth.driver.sh
reboot
```


```install.bluetooth.sh``` will auto-patch the hci_bcm.c source file and then compile and install the *hci_uart* module


```install.bluetooth.sh``` is designed to be run on the Macbook itself (running Linux obviously). It will compile *hci_uart* for the currently running/active kernel (based on the ```uname -r``` output)
However, this script can be easily modified to suit any number of use-case scenarios. 
