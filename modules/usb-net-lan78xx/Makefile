define KernelPackage/usb-net-lan78xx
  TITLE:=USB-To-Ethernet Microchip LAN78XX convertors
  DEPENDS:= @!TARGET_x86 +kmod-fixed-phy +kmod-phy-microchip +PACKAGE_kmod-of-mdio:kmod-of-mdio 
  KCONFIG:=CONFIG_USB_LAN78XX=m
  FILES:=$(LINUX_DIR)/drivers/$(USBNET_DIR)/lan78xx.ko
  AUTOLOAD:=$(call AutoProbe,lan78xx)
  $(call AddDepends/usb-net)
endef

define KernelPackage/usb-net-lan78xx/description
 Kernel module for Microchip LAN78XX based USB 2 & USB 3
 10/100/1000 Ethernet adapters.
endef

$(eval $(call KernelPackage,usb-net-lan78xx))
