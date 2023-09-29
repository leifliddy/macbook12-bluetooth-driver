ifneq ($(KERNELRELEASE),)
	KERNELDIR ?= /lib/modules/$(KERNELRELEASE)/build
else
	## KERNELRELEASE not set.
	KERNELDIR ?= /lib/modules/$(shell uname -r)/build
endif

all:
	make -C $(KERNELDIR) M=$(shell pwd)/build/bluetooth modules
clean:
	make -C $(KERNELDIR) M=$(shell pwd)/build/bluetooth clean

ifeq ($(KERNELRELEASE),)
install:
	cp $(shell pwd)/build/bluetooth/hci_uart.ko /lib/modules/$(shell uname -r)/updates
	depmod -a
endif
