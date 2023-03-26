#
#!/bin/bash
# © 2021 GitHub, Inc.
#====================================================================
# Copyright (c) 2019-2021 iplcdn <https://iplcdn.com>
#
# This is free software, licensed under the MIT License.
# See /LICENSE for more information.
#
# https://github.com/MuaCat/Actions-OpenWrt
# File name: diy-part2.sh
# Description: OpenWrt DIY script part 2 (After Update feeds)
#====================================================================

# Modify default IP
sed -i 's/192.168.1.1/192.168.6.1/g' package/base-files/files/bin/config_generate

# Modify hostname
#sed -i 's/OpenWrt/OpenWrt/g' package/base-files/files/bin/config_generate

# Delete default password
#sed -i '/CYXluq4wUazHjmCDBCqXF/d' package/lean/default-settings/files/zzz-default-settings

# Modify the version number版本号里显示一个自己的名字（AutoBuild $(TZ=UTC-8 date "+%Y.%m.%d") @ 这些都是后增加的）
# sed -i 's/OpenWrt /SgeBuild $(TZ=UTC-8 date "+%Y.%m.%d") @ OpenWrt /g' package/lean/default-settings/files/zzz-default-settings

# 修改主机名字，把Xiaomi-R4A修改你喜欢的就行（不能纯数字或者使用中文）
#sed -i '/uci commit system/i\uci set system.@system[0].hostname='HiWifi HC5962'' package/lean/default-settings/files/zzz-default-settings

# 修改 argon 为默认主题,可根据你喜欢的修改成其他的（不选择那些会自动改变为默认主题的主题才有效果）
sed -i 's/luci-theme-bootstrap/luci-theme-argon/g' feeds/luci/collections/luci/Makefile

# 修改默认wifi名称ssid为100
# sed -i 's/ssid=OpenWrt/ssid=100/g' package/kernel/mac80211/files/lib/wifi/mac80211.sh

#开启MU-MIMO
#sed -i 's/mu_beamformer=0/mu_beamformer=1/g' package/kernel/mac80211/files/lib/wifi/mac80211.sh
#wifi加密方式，没有是none
#sed -i 's/encryption=none/encryption=psk2/g' package/kernel/mac80211/files/lib/wifi/mac80211.sh
#wifi密码
#sed -i 's/key=password/key=gds.2021/g' package/kernel/mac80211/files/lib/wifi/mac80211.sh

# 修复核心及添加温度显示
#sed -i 's|pcdata(boardinfo.system or "?")|luci.sys.exec("uname -m") or "?"|g' feeds/luci/modules/luci-mod-admin-full/luasrc/view/admin_status/index.htm
#sed -i 's/or "1"%>/or "1"%> ( <%=luci.sys.exec("expr `cat \/sys\/class\/thermal\/thermal_zone0\/temp` \/ 1000") or "?"%> \&#8451; ) /g' feeds/luci/modules/luci-mod-admin-full/luasrc/view/admin_status/index.htm

# Add kernel build user
#[ -z $(grep "CONFIG_KERNEL_BUILD_USER=" .config) ] &&
#    echo 'CONFIG_KERNEL_BUILD_USER="OpenWrt"' >>.config ||
#    sed -i 's@\(CONFIG_KERNEL_BUILD_USER=\).*@\1$"OpenWrt"@' .config

# Add kernel build domain
#[ -z $(grep "CONFIG_KERNEL_BUILD_DOMAIN=" .config) ] &&
#    echo 'CONFIG_KERNEL_BUILD_DOMAIN="GitHub Actions"' >>.config ||
#    sed -i 's@\(CONFIG_KERNEL_BUILD_DOMAIN=\).*@\1$"GitHub Actions"@' .config
#================================================================================================
#移除不用软件包    
rm -rf feeds/luci/applications/luci-app-dockerman
rm -rf feeds/luci/applications/luci-app-wrtbwmon
rm -rf feeds/luci/applications/luci-app-webrestriction
rm -rf feeds/luci/applications/luci-app-vssr
rm -rf feeds/luci/applications/luci-app-socat
rm -rf feeds/luci/applications/luci-app-adbyby
rm -rf feeds/packages/net/smartdns



#openwrt package
# https://github.com/kenzok8/openwrt-packages
# https://github.com/liuran001/openwrt-packages
# https://github.com/kiddin9/openwrt-packages
# https://github.com/kenzok8/small-package
# https://github.com/haiibo/openwrt-packages

#添加额外软件包
git clone https://github.com/destan19/OpenAppFilter.git package/OpenAppFilter

svn co https://github.com/padavanonly/immortalwrtmt7622/trunk/package/luci-app-adbyby-fix package/luci-app-adbyby-fix

git clone https://github.com/xiaorouji/openwrt-passwall.git package/Passwall
git clone -b luci https://github.com/xiaorouji/openwrt-passwall.git package/luci-app-passwall

svn co https://github.com/xiangfeidexiaohuo/op-ipkg/trunk/luci-lib-ipkg package/luci-lib-ipkg
svn co https://github.com/fw876/helloworld/trunk/lua-neturl package/lua-neturl 
git clone https://github.com/kiddin9/openwrt-bypass.git package/luci-bypass

# ddnsto 3.0.2
svn co https://github.com/linkease/nas-packages-luci/trunk/luci/luci-app-ddnsto package/luci-app-ddnsto
git clone https://github.com/linkease/nas-packages package/nas-packages
git clone https://github.com/souwei168/luci-app-store.git package/luci-app-store

git clone https://github.com/vernesong/OpenClash.git package/OpenClash
#git clone https://github.com/jerrykuku/luci-app-jd-dailybonus.git package/luci-app-jd-dailybonus
git clone https://github.com/jerrykuku/luci-app-vssr.git package/luci-app-vssr-jerrykuku
git clone https://github.com/jerrykuku/lua-maxminddb package/lua-maxminddb
git clone https://github.com/kongfl888/luci-app-adguardhome.git package/luci-app-adguardhome
git clone https://github.com/kiddin9/luci-app-dnsfilter package/luci-app-dnsfilter
git clone -b zhcn https://github.com/modelsun/luci-app-onliner.git package/luci-app-onliner
git clone https://github.com/modelsun/luci-app-usb3disable package/luci-app-usb3disable

svn co https://github.com/coolsnowwolf/packages/trunk/utils/ntfs-3g packages/utils/ntfs-3g

git clone -b moddb https://github.com/modelsun/luci-app-vnstat2.git package/luci-app-vnstat2
svn co https://github.com/coolsnowwolf/packages/trunk/net/vnstat package/net/vnstat
svn co https://github.com/coolsnowwolf/packages/trunk/net/vnstat2 package/net/vnstat2

svn co https://github.com/kiddin9/openwrt-packages/trunk/aria2 package/aria2
svn co https://github.com/kiddin9/openwrt-packages/trunk/ariang package/ariang
svn co https://github.com/kiddin9/openwrt-packages/trunk/luci-app-aria2 package/luci-app-aria2

git clone https://github.com/zzsj0928/luci-app-pushbot package/luci-app-pushbot

git clone https://github.com/pymumu/openwrt-smartdns package/smartdns
git clone -b lede https://github.com/pymumu/luci-app-smartdns.git package/luci-app-smartdns
svn co https://github.com/kenzok8/small-package/trunk/luci-app-socat package/luci-app-socat

#svn co https://github.com/kenzok8/small-package/trunk/rblibtorrent package/rblibtorrent

svn co https://github.com/kiddin9/openwrt-packages/trunk/wrtbwmon package/wrtbwmon
svn co https://github.com/kiddin9/openwrt-packages/trunk/luci-app-wrtbwmon package/luci-app-wrtbwmon
svn co https://github.com/kenzok8/small-package/trunk/luci-app-timecontrol package/luci-app-timecontrol
svn co https://github.com/kiddin9/openwrt-packages/trunk/luci-app-webrestriction package/luci-app-webrestriction
svn co https://github.com/modelsun/openwrt-packages/trunk/luci-app-fileassistant package/luci-app-fileassistant
svn co https://github.com/kenzok8/openwrt-packages/trunk/luci-app-eqos package/luci-app-eqos


#主题
#添加argon-config 使用 最新argon
git clone https://github.com/jerrykuku/luci-app-argon-config package/luci-app-argon-config
rm -rf feeds/luci/themes/luci-theme-argon
#git clone -b 18.06 https://github.com/jerrykuku/luci-theme-argon package/luci-theme-argon
#git clone https://github.com/Leo-Jo-My/luci-theme-opentomcat.git package/luci-theme-opentomcat
svn co https://github.com/haiibo/openwrt-packages/trunk/luci-theme-opentomcat package/luci-theme-opentomcat
svn co https://github.com/haiibo/openwrt-packages/trunk/luci-theme-argon package/luci-theme-argon


./scripts/feeds update -a
./scripts/feeds install -a
#================================================================================================
