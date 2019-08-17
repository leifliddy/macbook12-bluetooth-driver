obj-m 	+= hci_uart.o

hci_uart-y	:= hci_ldisc.o
hci_uart-m 	+= hci_serdev.o
hci_uart-m 	+= hci_h4.o
hci_uart-m	+= hci_bcsp.o
hci_uart-m	+= hci_ll.o
hci_uart-m	+= hci_ath.o
hci_uart-m	+= hci_h5.o
hci_uart-m	+= hci_intel.o
hci_uart-m	+= hci_bcm.o
hci_uart-m	+= hci_qca.o
hci_uart-m	+= hci_ag6xx.o
hci_uart-m	+= hci_mrvl.o
hci_uart-objs	:= $(hci_uart-y)

#all:
#	make -C /lib/modules/$(shell uname -r)/build M=$(PWD) modules

#clean:
#	make -C /lib/modules/$(shell uname -r)/build M=$(PWD) clean

#build for latest installed kernel
all:
	make -C /lib/modules/$(shell rpm -qa | grep kernel-headers | sed 's/kernel-headers-//')/build M=$(PWD) modules

clean:
	make -C /lib/modules/$(shell rpm -qa | grep kernel-headers | sed 's/kernel-headers-//')/build M=$(PWD) clean

install:
	xz hci_uart.ko
	cp hci_uart.ko.xz /lib/modules/$(shell rpm -qa | grep kernel-headers | sed 's/kernel-headers-//')/updates
	depmod -a

