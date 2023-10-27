ifdef KERNELRELEASE
	KERNELDIR := /lib/modules/$(KERNELRELEASE)
else
	KERNELDIR := /lib/modules/$(shell uname -r)
endif

KERNELBUILD := $(KERNELDIR)/build

all:
	make -C $(KERNELBUILD) M=$(shell pwd)/build/bluetooth modules

clean:
	make -C $(KERNELBUILD) M=$(shell pwd)/build/bluetooth clean

ifndef KERNELRELEASE
install:
	cp $(shell pwd)/build/bluetooth/hci_uart.ko /lib/modules/$(shell uname -r)/updates
	depmod -a
endif
