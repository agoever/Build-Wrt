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
sed -i 's/ImmortalWrt/HiWrt/g' package/base-files/files/bin/config_generate

# 修改主机名 OP
# sed -i 's/ImmortalWrt/ImmortalWrt $(TZ=UTC-8 date "+%y%m%d")/g'  package/base-files/files/bin/config_generate
sed -i 's/ImmortalWrt/ImmortalWrt(250305)/g'  package/base-files/files/bin/config_generate


#================================================================================================
#移除不用软件包    
rm -rf feeds/luci/applications/luci-app-dockerman
rm -rf feeds/luci/applications/luci-app-adbyby
rm -rf feeds/luci/applications/luci-app-natmap



#openwrt package
# https://github.com/kenzok8/openwrt-packages
# https://github.com/liuran001/openwrt-packages
# https://github.com/kiddin9/kwrt-packages
# https://github.com/kenzok8/small-package
# https://github.com/haiibo/openwrt-packages

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

git clone https://github.com/messense/aliyundrive-webdav aliyundrive-webdav
cp -rf aliyundrive-webdav/openwrt package/luci-app-aliyundrive-webdav
rm -rf aliyundrive-webdav

git clone https://github.com/kongfl888/luci-app-adguardhome.git package/luci-app-adguardhome


git clone https://github.com/HiJwm/op-ipkg.git opipkg
cp -rf opipkg/luci-lib-ipkg package/luci-lib-ipkg-null
rm -rf opipkg


git clone https://github.com/fw876/helloworld.git neturl
cp -rf neturl/lua-neturl package/lua-neturl
rm -rf neturl


# ddnsto 3.0.2
git clone https://github.com/linkease/nas-packages-luci package/nas-packages-luci
git clone https://github.com/linkease/nas-packages package/nas-packages
git clone https://github.com/souwei168/luci-app-store.git package/luci-app-store

git clone https://github.com/zzsj0928/luci-app-pushbot package/luci-app-pushbot

#********************kiddin9大佬的仓库***************************
git clone https://github.com/kiddin9/kwrt-packages kiddin9

cp -rf kiddin9/luci-app-alist package/luci-app-alist
cp -rf kiddin9/alist package/alist

#cp -rf kiddin9/luci-app-tailscale package/luci-app-tailscale
#cp -rf kiddin9/tailscale package/tailscale

cp -rf kiddin9/luci-app-webdav package/luci-app-webdav
cp -rf kiddin9/webdav2 package/webdav2

git clone https://github.com/sbwml/luci-app-mosdns -b v5 package/mosdns
git clone https://github.com/sbwml/v2ray-geodata package/v2ray-geodata


#golang版本问题：
rm -rf feeds/packages/lang/golang
git clone https://github.com/sbwml/packages_lang_golang -b 20.x feeds/packages/lang/golang


cp -rf kiddin9/luci-app-autotimeset package/luci-app-autotimeset


# cp -rf kiddin9/luci-app-ssr-plus package/luci-app-ssr-plus
# cp -rf kiddin9/luci-app-bypass package/luci-app-bypass
rm -rf kiddin9

#********************kenzok8大佬的仓库***************************
git clone https://github.com/kenzok8/small-package kenzok8

cp -rf kenzok8/ipt2socks package/ipt2socks

# # cp -rf kenzok8/luci-app-mosdns package/luci-app-mosdns
# cp -rf kenzok8/luci-lib-taskd package/luci-lib-taskd
# cp -rf kenzok8/luci-lib-xterm package/luci-lib-xterm
# cp -rf kenzok8/taskd package/taskd
# cp -rf kenzok8/v2dat package/v2dat

cp -rf kenzok8/v2ray-core package/v2ray-core
cp -rf kenzok8/v2ray-geodata package/v2ray-geodata
cp -rf kenzok8/v2ray-geoview package/v2ray-geoview
cp -rf kenzok8/v2ray-plugin package/v2ray-plugin
cp -rf kenzok8/v2raya package/v2raya

rm -rf kenzok8

git clone -b 18.06 https://github.com/zxlhhyccc/luci-app-v2raya.git package/luci-app-v2raya

#********************hexsen929 大佬的仓库***************************
# git clone https://github.com/hexsen929/openwrt_packages hexsen929
# cp -rf hexsen929/luci-app-samba4 package/luci-app-samba4
# rm -rf hexsen929


#********************immortalwrt packages ***************************
git clone https://github.com/muink/luci-app-natmapt.git package/luci-app-natmapt
git clone https://github.com/muink/openwrt-natmapt.git package/natmapt
git clone https://github.com/muink/openwrt-stuntman.git package/openwrt-stuntman


#********************immortalwrt packages ***************************
git clone https://github.com/immortalwrt/packages immortalwrt_packages
cp -rf immortalwrt_packages/libs/libjwt package/libs/libjwt

rm -rf immortalwrt_packages

sed -i 's#GO_PKG_TARGET_VARS.*# #g' feeds/packages/utils/v2dat/Makefile


# add bmx6
git clone https://github.com/bmx-routing/bmx6.git bmxrouting
cp -rf bmxrouting/bmx6 routing/bmx6

rm -rf bmxrouting

## 以下是替换的包##
git clone -b zhcn https://github.com/modelsun/luci-app-onliner.git package/luci-app-onliner
git clone https://github.com/modelsun/luci-app-usb3disable package/luci-app-usb3disable

git clone https://github.com/modelsun/luci-app-vnstat2.git package/luci-app-vnstat2
git clone https://github.com/coolsnowwolf/packages.git vnstatcnw
cp -rf vnstatcnw/net/vnstat package/vnstat
cp -rf vnstatcnw/net/vnstat2 package/vnstat2
rm -rf vnstatcnw

#主题
git clone https://github.com/Leo-Jo-My/luci-theme-opentomcat.git package/luci-theme-opentomcat

./scripts/feeds update -a
./scripts/feeds install -a
#================================================================================================
