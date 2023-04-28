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

#rm -rf target/linux/ramips
#svn co https://github.com/padavanonly/immortalwrt/trunk/target/linux/ramips target/linux/ramips


#删除HC5962 多余lan口0，否则交换机中会多一个
sed -i '35,37s/"0:lan" //g' target/linux/ramips/mt7621/base-files/etc/board.d/02_network
sed -i 's/llllw/lllw/g' target/linux/ramips/dts/mt7621_hiwifi_hc5962.dts

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
#sed -i 's/luci-theme-bootstrap/luci-theme-argon/g' feeds/luci/collections/luci/Makefile

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
rm -rf feeds/luci/applications/luci-app-adbyby


#openwrt package
# https://github.com/kenzok8/openwrt-packages
# https://github.com/liuran001/openwrt-packages
# https://github.com/kiddin9/openwrt-packages
# https://github.com/kenzok8/small-package
# https://github.com/haiibo/openwrt-packages


#添加额外软件包
#git clone https://github.com/kiddin9/openwrt-packages package/kiddin9-package

#以下是 immortalwrt没有的插件，kiddin9中有的
#CONFIG_PACKAGE_luci-app-aliyundrive-webdav=y
#CONFIG_PACKAGE_aliyundrive-webdav=y
#CONFIG_PACKAGE_luci-app-adguardhome=y
#CONFIG_PACKAGE_luci-app-bypass=y
#CONFIG_PACKAGE_luci-app-ddnsto=y
#CONFIG_PACKAGE_luci-app-easymesh=y 没加
#CONFIG_PACKAGE_luci-app-onliner=y
#CONFIG_PACKAGE_luci-app-pushbot=y
#CONFIG_PACKAGE_luci-app-turboacc=y 没包，看看编完有没有
#CONFIG_PACKAGE_luci-app-wireless-regdb=y 好像没有了

#下边是都没有的
#CONFIG_PACKAGE_luci-theme-opentomcat=y

######################################### 添加没有的包 #########################################################

svn co https://github.com/messense/aliyundrive-webdav/trunk/openwrt package/aliyundrive
git clone https://github.com/kongfl888/luci-app-adguardhome.git package/luci-app-adguardhome

#bypass
svn co https://github.com/xiangfeidexiaohuo/op-ipkg/trunk/luci-lib-ipkg package/bypass-luci-lib-ipkg
svn co https://github.com/fw876/helloworld/trunk/lua-neturl package/lua-neturl 
svn co https://github.com/kiddin9/openwrt-packages/trunk/luci-app-bypass package/bypass-luci

# ddnsto 3.0.2
svn co https://github.com/linkease/nas-packages-luci/trunk/luci/luci-app-ddnsto package/luci-app-ddnsto
git clone https://github.com/linkease/nas-packages package/nas-packages
git clone https://github.com/souwei168/luci-app-store.git package/luci-app-store

git clone https://github.com/zzsj0928/luci-app-pushbot package/luci-app-pushbot

#alist
svn co https://github.com/kiddin9/openwrt-packages/trunk/luci-app-alist package/luci-app-alist
svn co https://github.com/kiddin9/openwrt-packages/trunk/alist package/alist

#webdav
svn co https://github.com/kiddin9/openwrt-packages/trunk/luci-app-webdav package/luci-app-webdav
svn co https://github.com/kiddin9/openwrt-packages/trunk/webdav2 package/webdav2

## 以下是替换的包##
git clone -b zhcn https://github.com/modelsun/luci-app-onliner.git package/luci-app-onliner
git clone https://github.com/modelsun/luci-app-usb3disable package/luci-app-usb3disable

git clone https://github.com/modelsun/luci-app-vnstat2.git package/luci-app-vnstat2
svn co https://github.com/coolsnowwolf/packages/trunk/net/vnstat package/net/vnstat
svn co https://github.com/coolsnowwolf/packages/trunk/net/vnstat2 package/net/vnstat2

#update zetotire
rm -rf feeds/luci/applications/luci-app-zerotier
rm -rf feeds/packages/net/zerotier
svn co https://github.com/kiddin9/openwrt-packages/trunk/luci-app-zerotier package/luci-app-zerotier


rm -rf feeds/luci/applications/luci-app-turboacc
svn co https://github.com/coolsnowwolf/luci/trunk/applications/luci-app-turboacc feeds/luci/applications/luci-app-turboacc
svn co https://github.com/coolsnowwolf/lede/trunk/package/lean/shortcut-fe package/lean/shortcut-fe

#主题
git clone https://github.com/Leo-Jo-My/luci-theme-opentomcat.git package/luci-theme-opentomcat
svn co https://github.com/haiibo/openwrt-packages/trunk/luci-theme-edge package/luci-theme-edge


./scripts/feeds update -a
./scripts/feeds install -a
#================================================================================================
