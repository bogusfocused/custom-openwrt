# SPDX-Identifier-License: GPL-3.0-or-later
#
# Copyright (C) 2019 Elon Huang <elonhhuang@gmail.com>
# Copyright (C) 2021 ImmortalWrt.org
# Copyright (C) 2022 Rohit Lodha <bogusfocused@gmail.com>

include $(TOPDIR)/rules.mk

PKG_NAME:=rclone
PKG_VERSION:=1.58.0
PKG_RELEASE:=$(AUTORELEASE)

PKG_SOURCE:=$(PKG_NAME)-$(PKG_VERSION).tar.gz
PKG_SOURCE_URL:=https://codeload.github.com/rclone/rclone/tar.gz/v$(PKG_VERSION)?
PKG_HASH:=b3f953a282964d6d73a7278ccb2bb836d9aca855e9dc5fb6f4bc986b0e5656fa

PKG_LICENSE:=MIT
PKG_LICENSE_FILE:=LICENSE
PKG_MAINTAINER:=Rohit Lodha <bogusfocused@gmail.com>

PKG_BUILD_DEPENDS:=golang/host
PKG_BUILD_PARALLEL:=1
PKG_USE_MIPS16:=0

GO_PKG:=github.com/rclone/rclone
GO_PKG_EXCLUDES:=test
GO_PKG_LDFLAGS_X:= \
	github.com/rclone/rclone/fs.Version=v$(PKG_VERSION) \
	main.Version=v$(PKG_VERSION) \
	main.BuildUser=openwrt \
	main.BuildHost=openwrt

include $(INCLUDE_DIR)/package.mk
include $(TOPDIR)/feeds/packages/lang/golang/golang-package.mk

define Package/rclone/Default
  SECTION:=net
  CATEGORY:=Network
  SUBMENU:=File Transfer
  TITLE:=RClone rcd
  URL:=https://rclone.org
endef

define Package/rclone/description
  Rclone is a command line program to sync
  files and directories to and from different cloud storage providers. 
  This package runs rclone in deamon mode and can be remotely controlled.
endef

define Package/rclone-bin
  $(call Package/rclone/Default)
  DEPENDS:=$(GO_ARCH_DEPENDS) +ca-bundle +fuse-utils
  PROVIDES:=rclone
  CONFLICTS:=rclone
endef

define Package/rclone-bin/description
  $(call Package/rclone/description)
endef

define Package/rclone-server
  $(call Package/rclone/Default)
  DEPENDS:=+rclone-bin +libuci-lua
  PKGARCH:=all
endef

define Package/rclone-server/description
  $(call Package/rclone/description)
endef

define Package/rclone-ubus
  $(call Package/rclone/Default)
  TITLE+= (Ubus)
  DEPENDS:= +rclone-server +libubus-lua +libubox-lua +lua-cjson +linotify
  PKGARCH:=all
endef

define Package/rclone-server/conffiles
/etc/config/rclone
endef

define Package/rclone-bin/install
	$(call GoPackage/Package/Install/Bin,$(PKG_INSTALL_DIR))
	$(INSTALL_DIR) $(1)/usr/sbin/
	$(INSTALL_BIN) $(PKG_INSTALL_DIR)/usr/bin/rclone $(1)/usr/sbin/
endef

define Package/rclone-server/install
	$(INSTALL_DIR) $(1)/etc/config/
	$(INSTALL_CONF) ./files/rclone.conf $(1)/etc/config/rclone
	$(INSTALL_DIR) $(1)/etc/init.d/
	$(INSTALL_BIN) ./files/rclone.init $(1)/etc/init.d/rclone
	$(INSTALL_DIR) $(1)/usr/libexec/rclone
	$(INSTALL_BIN) ./files/dump.lua $(1)/usr/libexec/rclone/dump
endef

define Package/rclone-ubus/install
	$(INSTALL_DIR) $(1)/usr/libexec/rclone
	$(INSTALL_BIN) ./files/ubus.lua $(1)/usr/libexec/rclone/ubus
endef

$(eval $(call GoBinPackage,rclone-bin))
$(eval $(call BuildPackage,rclone-bin))
$(eval $(call BuildPackage,rclone-server))
$(eval $(call BuildPackage,rclone-ubus))
