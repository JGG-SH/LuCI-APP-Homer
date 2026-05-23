include $(TOPDIR)/rules.mk
include $(INCLUDE_DIR)/package.mk

PKG_NAME:=luci-app-homer
PKG_VERSION:=$(shell date +%Y%m%d)
PKG_RELEASE:=1

# 不定义任何 PKG_SOURCE_*，避免编译阶段下载

PKG_LICENSE:=Apache-2.0

define Package/luci-app-homer
  SECTION:=luci
  CATEGORY:=LuCI
  SUBMENU:=3. Applications
  TITLE:=Homer - A dead simple static homepage
  URL:=https://github.com/bastienwirtz/homer
  DEPENDS:=+uhttpd +luci-base
  HOST_BUILD_DEPENDS:=zip/host unzip/host
endef

define Package/luci-app-homer/description
  A dead simple static HOMepage for your servER to keep your services on hand, from a simple yaml configuration file.
  This package integrates Homer into OpenWrt's LuCI interface.
endef

# 空构建步骤，无任何操作
define Build/Prepare
endef

define Build/Configure
endef

define Build/Compile
endef

define Package/luci-app-homer/install
	$(INSTALL_DIR) $(1)/www/homer
	$(INSTALL_DIR) $(1)/etc/config
	$(CP) ./files/etc/config/homer-uhttpd $(1)/etc/config/homer-uhttpd
	$(INSTALL_DIR) $(1)/usr/lib/lua/luci/controller
	$(CP) ./files/usr/lib/lua/luci/controller/homer.lua $(1)/usr/lib/lua/luci/controller/
	$(INSTALL_DIR) $(1)/usr/lib/lua/luci/view/homer
	$(CP) ./files/usr/lib/lua/luci/view/homer/homer_manager $(1)/usr/lib/lua/luci/view/homer/
endef

$(eval $(call BuildPackage,luci-app-homer))
