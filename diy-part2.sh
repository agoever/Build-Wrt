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


svn_export() {
	# 参数1是分支名, 参数2是子目录, 参数3是目标目录, 参数4仓库地址
    # https://github.com/coolsnowwolf/lede/issues/11757
	trap 'rm -rf "$TMP_DIR"' 0 1 2 3
	TMP_DIR="$(mktemp -d)" || exit 1
	[ -d "$3" ] || mkdir -p "$3"
	TGT_DIR="$(cd "$3"; pwd)"
	cd "$TMP_DIR" && \
	git init >/dev/null 2>&1 && \
	git remote add -f origin "$4" >/dev/null 2>&1 && \
	git checkout "remotes/origin/$1" -- "$2" && \
	cd "$2" && cp -a . "$TGT_DIR/"
}

#svn_export "master" "target/linux/x86" "route" "https://github.com/coolsnowwolf/lede"


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

#svn co https://github.com/messense/aliyundrive-webdav/trunk/openwrt package/aliyundrive
svn_export "main" "openwrt" "package/aliyundrive" "https://github.com/messense/aliyundrive-webdav"
git clone https://github.com/kongfl888/luci-app-adguardhome.git package/luci-app-adguardhome

#bypass
#svn co https://github.com/HiJwm/op-ipkg/trunk/luci-lib-ipkg package/luci-lib-ipkg-null
#svn co https://github.com/fw876/helloworld/trunk/lua-neturl package/lua-neturl 
#svn co https://github.com/kiddin9/openwrt-packages/trunk/luci-app-bypass package/bypass-luci

svn_export "master" "luci-lib-ipkg" "package/luci-lib-ipkg-null" "https://github.com/HiJwm/op-ipkg.git"
svn_export "master" "lua-neturl" "package/lua-neturl" "https://github.com/fw876/helloworld.git"
svn_export "master" "luci-app-bypass" "package/bypass-luci" "https://github.com/kiddin9/openwrt-packages"

#svn co https://github.com/kiddin9/openwrt-packages/trunk/luci-app-ssr-plus package/luci-app-ssr-plus
svn_export "master" "luci-app-ssr-plus" "package/luci-app-ssr-plus" "https://github.com/kiddin9/openwrt-packages"

# ddnsto 3.0.2
#svn co https://github.com/linkease/nas-packages-luci/trunk/luci/luci-app-ddnsto package/luci-app-ddnsto
svn_export "main" "luci/luci-app-ddnsto" "package/luci/luci-app-ddnsto" "https://github.com/linkease/nas-packages-luci"
git clone https://github.com/linkease/nas-packages package/nas-packages
git clone https://github.com/souwei168/luci-app-store.git package/luci-app-store

git clone https://github.com/zzsj0928/luci-app-pushbot package/luci-app-pushbot

#alist
#svn co https://github.com/kiddin9/openwrt-packages/trunk/luci-app-alist package/luci-app-alist
#svn co https://github.com/kiddin9/openwrt-packages/trunk/alist package/alist
svn_export "master" "luci-app-alist package" "package/luci-app-alist package" "https://github.com/kiddin9/openwrt-packages"
svn_export "master" "alist" "package/alist" "https://github.com/kiddin9/openwrt-packages"

#webdav
#svn co https://github.com/kiddin9/openwrt-packages/trunk/luci-app-webdav package/luci-app-webdav
#svn co https://github.com/kiddin9/openwrt-packages/trunk/webdav2 package/webdav2
svn_export "master" "luci-app-webdav" "package/luci-app-webdav" "https://github.com/kiddin9/openwrt-packages"
svn_export "master" "webdav2" "package/webdav2" "https://github.com/kiddin9/openwrt-packages"

## 以下是替换的包##
git clone -b zhcn https://github.com/modelsun/luci-app-onliner.git package/luci-app-onliner
git clone https://github.com/modelsun/luci-app-usb3disable package/luci-app-usb3disable

git clone https://github.com/modelsun/luci-app-vnstat2.git package/luci-app-vnstat2
#svn co https://github.com/coolsnowwolf/packages/trunk/net/vnstat package/net/vnstat
#svn co https://github.com/coolsnowwolf/packages/trunk/net/vnstat2 package/net/vnstat2
svn_export "master" "net/vnstat" "package/net/vnstat" "git@github.com:coolsnowwolf/packages"
svn_export "master" "net/vnstat2" "package/net/vnstat2" "git@github.com:coolsnowwolf/packages"

#主题
git clone https://github.com/Leo-Jo-My/luci-theme-opentomcat.git package/luci-theme-opentomcat
#svn co https://github.com/haiibo/openwrt-packages/trunk/luci-theme-edge package/luci-theme-edge
svn_export "master" "luci-theme-edge" "package/luci-theme-edge" "https://github.com/haiibo/openwrt-packages"

./scripts/feeds update -a
./scripts/feeds install -a
#================================================================================================
