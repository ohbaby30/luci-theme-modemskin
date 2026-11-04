#
# luci-theme-modemskin - 光猫/家庭网关风格 LuCI 主题
#
# 放置于 OpenWrt/LuCI 源码树的 feeds/luci/themes/ 下即可编译。
#
include $(TOPDIR)/rules.mk

LUCI_TITLE:=LuCI theme - ModemSkin
LUCI_DESCRIPTION:=Three switchable carrier-style LuCI layouts with shared navigation and widgets.
LUCI_PKGARCH:=all
LUCI_DEPENDS:=+luci-base

PKG_VERSION:=1.1.0
PKG_RELEASE:=1

PKG_LICENSE:=MIT
PKG_MAINTAINER:=Ohbaby

define Package/luci-theme-modemskin/conffiles
/etc/config/modemskin
endef

define Package/luci-theme-modemskin/postrm
#!/bin/sh
[ -n "$$IPKG_INSTROOT" ] && exit 0
[ "$${IPKG_NO_SCRIPT:-0}" = 1 ] && exit 0
for rpcd_pid in $$(pidof rpcd 2>/dev/null); do
  kill -HUP "$$rpcd_pid" 2>/dev/null || true
done
endef

include $(TOPDIR)/feeds/luci/luci.mk

# call BuildPackage - OpenWrt buildroot signature
