obj-$(CONFIG_BT_HCIUART)             += hci_uart.o

hci_uart-y                           := hci_ldisc.o
hci_uart-$(CONFIG_BT_HCIUART_SERDEV) += hci_serdev.o
hci_uart-$(CONFIG_BT_HCIUART_H4)	 += hci_h4.o
hci_uart-$(CONFIG_BT_HCIUART_BCSP)	 += hci_bcsp.o
hci_uart-$(CONFIG_BT_HCIUART_LL)	 += hci_ll.o
hci_uart-$(CONFIG_BT_HCIUART_ATH3K)	 += hci_ath.o
hci_uart-$(CONFIG_BT_HCIUART_3WIRE)	 += hci_h5.o
hci_uart-$(CONFIG_BT_HCIUART_INTEL)	 += hci_intel.o
hci_uart-$(CONFIG_BT_HCIUART_BCM)	 += hci_bcm.o
hci_uart-$(CONFIG_BT_HCIUART_QCA)	 += hci_qca.o
hci_uart-$(CONFIG_BT_HCIUART_AG6XX)	 += hci_ag6xx.o
hci_uart-$(CONFIG_BT_HCIUART_MRVL)	 += hci_mrvl.o
hci_uart-objs                        := $(hci_uart-y)
