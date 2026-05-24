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
  DEPENDS:=+uhttpd +luci-base +p7zip +unzip
endef

define Package/luci-app-homer/description
  A dead simple static HOMepage for your servER.
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
	$(CP) ./files/usr/lib/lua/luci/view/homer/homer_manager.htm $(1)/usr/lib/lua/luci/view/homer/

	# 安装 homer_restore CGI 脚本（处理文件上传恢复）
	$(INSTALL_DIR) $(1)/www/cgi-bin
	$(INSTALL_BIN) ./files/www/cgi-bin/homer_restore $(1)/www/cgi-bin/

	# 安装通用脚本 setup.sh（物理文件，复杂逻辑在这里）
	$(INSTALL_DIR) $(1)/usr/lib/homer
	$(INSTALL_BIN) ./files/usr/lib/homer/setup.sh $(1)/usr/lib/homer/

	# 生成 init.d 脚本（统一入口：刷机后开机 + apk/opkg 安装后开机均通过此路径）
	$(INSTALL_DIR) $(1)/etc/init.d
	echo '#!/bin/sh /etc/rc.common' > $(1)/etc/init.d/homer-autosetup
	echo '' >> $(1)/etc/init.d/homer-autosetup
	echo 'START=95' >> $(1)/etc/init.d/homer-autosetup
	echo 'STOP=15' >> $(1)/etc/init.d/homer-autosetup
	echo 'USE_PROCD=0' >> $(1)/etc/init.d/homer-autosetup
	echo '' >> $(1)/etc/init.d/homer-autosetup
	echo 'start() {' >> $(1)/etc/init.d/homer-autosetup
	echo '    /usr/lib/homer/setup.sh' >> $(1)/etc/init.d/homer-autosetup
	echo '}' >> $(1)/etc/init.d/homer-autosetup
	chmod 755 $(1)/etc/init.d/homer-autosetup
	$(INSTALL_DIR) $(1)/etc/rc.d
	$(LN) ../init.d/homer-autosetup $(1)/etc/rc.d/S95homer-autosetup
endef

$(eval $(call BuildPackage,luci-app-homer))
