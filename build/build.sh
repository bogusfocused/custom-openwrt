#!/bin/bash

# Pass env var OPENWRT_VERSION=v21.02.2 ,  If unspecified,
# this script sets the value to latest openwrt release.

ALL_TARGETS=( \
    # apm821xx/nand \
    # apm821xx/sata \
    # arc770/generic \
    # archs38/generic \
    # armvirt/32 \
    # armvirt/64 \
    # at91/sam9x \
    # at91/sama5 \
    # ath79/generic \
    # ath79/mikrotik \
    # ath79/nand \
    # ath79/tiny \
    # bcm27xx/bcm2708 \
    # bcm27xx/bcm2709 \
    # bcm27xx/bcm2710 \
    bcm27xx/bcm2711 \
    # bcm47xx/generic \
    # bcm47xx/legacy \
    # bcm47xx/mips74k \
    # bcm4908/generic \
    # bcm53xx/generic \
    # bcm63xx/generic \
    # bcm63xx/smp \
    # ipq40xx/generic \
    # ipq40xx/mikrotik \
    # ipq806x/generic \
    # lantiq/ase \
    # lantiq/falcon \
    # lantiq/xrx200 \
    # lantiq/xway \
    # lantiq/xway_legacy \
    # layerscape/armv7 \
    # layerscape/armv8_64b \
    # malta/be \
    # malta/be64 \
    # malta/le \
    # malta/le64 \
    # mediatek/mt7622 \
    # mediatek/mt7623 \
    # mediatek/mt7629 \
    # mpc85xx/p1010 \
    # mpc85xx/p1020 \
    # mpc85xx/p2020 \
    # mvebu/cortexa53 \
    # mvebu/cortexa72 \
    # mvebu/cortexa9 \
    # oxnas/ox810se \
    # oxnas/ox820 \
    # ramips/mt7620 \
    # ramips/mt7621 \
    # ramips/mt76x8 \
    # ramips/rt288x \
    # ramips/rt305x \
    # ramips/rt3883 \
    # realtek/generic \
    # rockchip/armv8 \
    # sunxi/cortexa53 \
    # sunxi/cortexa7 \
    # sunxi/cortexa8 \
    x86/64 \
    # x86/generic \
    # x86/geode \
    # x86/legacy
)

TIMESTAMP=$(date -d "today" +"%Y%m%d%H%M%S")
BASE_DIR=$PWD
LOG_DIR="${BASE_DIR}/logs"
mkdir -p $LOG_DIR
BUILDLOG="${LOG_DIR}/build${TIMESTAMP}.log"
{
    if [ -z "$OPENWRT_VERSION" ] ; then
        echo "No openwrt version was specified. exiting"
        return 1
    fi
    if [ -z "$SOURCE_DIR" ] ; then
        echo "Error: No source directory specified. Set env var SOURCE_DIR to <path/src>. exiting.."
        return 1
    fi
    if [ ! -d "$SOURCE_DIR" ] ; then
        echo "Error:  Source dir ${SOURCE_DIR}  does not exist. exiting.."
        return 1
    fi
    
    mkdir -p $OPENWRT_VERSION
    cd $OPENWRT_VERSION
    WORK_DIR=$PWD
    PATH="$WORK_DIR/staging_dir/host/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin"
    PACKAGE_DIR="$SOURCE_DIR/packages"
    MODULE_DIR="$SOURCE_DIR/modules"
    BIN_DIR="${BASE_DIR}/artifacts/${TIMESTAMP}"
    ALL_MODULES=$(ls -C $MODULE_DIR)
    
    [ -z "$BUILD_TARGETS" ]  && BUILD_TARGETS="${ALL_TARGETS[*]}"
    [[  "ALL" = "$BUILD_TARGETS" ]]  && BUILD_TARGETS="${ALL_TARGETS[*]}"
    
    echo "
    BUILD_TARGETS: $BUILD_TARGETS
    ALL_MODULES: $ALL_MODULES
    BASE_DIR: $BASE_DIR
    BIN_DIR: $BIN_DIR
    BUILDLOG: ${BUILDLOG}
    MODULE_DIR: $MODULE_DIR
    OPENWRT_VERSION: $OPENWRT_VERSION
    PACKAGE_DIR: $PACKAGE_DIR
    PATH: ${PATH}
    SOURCE_DIR:  ${SOURCE_DIR}
    TIMESTAMP: $TIMESTAMP
    WORK_DIR: $WORK_DIR
    "
    
    if [ ! -d ".git" ] ; then
        echo -n "openwrt not found. checking out from github ..."
        git clone https://github.com/openwrt/openwrt.git .
        git fetch origin -f -t
        git checkout  "${OPENWRT_VERSION}"
        CLEAN_REPO="y"
        echo "done"
    fi
    git checkout --  package/kernel/linux/modules
    
    if [ ! -f feeds.conf ] ; then
        echo -n "generating feeds.conf"
        cat feeds.conf.default > feeds.conf
        echo "src-link local  $PACKAGE_DIR" >> feeds.conf
        echo "done"
    fi
    echo "======feeds.conf=========="
    cat feeds.conf
    echo "======feeds.conf=========="
    ./scripts/feeds update -a
    ALL_PACKAGES="$(./scripts/feeds list -r local | cut -d ' ' -f 1)"
    ./scripts/feeds uninstall $ALL_PACKAGES
    ./scripts/feeds install -f -a -p local
    for pkg in $ALL_MODULES
    do
        [ -f "$MODULE_DIR/$pkg/Makefile" ] || continue
        echo -n "Adding module $pkg to ${pkg%%-*}.mk  ..."
        cat "$MODULE_DIR/$pkg/Makefile"  >> "package/kernel/linux/modules/${pkg%%-*}.mk"
        echo "done"
    done
    file="./staging_dir/host/bin/usign"
    [ ! -f "./key-build" ] && [ -f "$file" ] &&  $file -G -s ./key-build -p ./key-build.pub -c "Local build key"
    
    
    for BUILD_TARGET in $BUILD_TARGETS
    do
        cd ${WORK_DIR}
        TARGET_NAME="${BUILD_TARGET//[\/]/_}"
        echo "
    BUILD_TARGET: $BUILD_TARGET
    TARGET_NAME: $TARGET_NAME
        "
        echo "Building .config"
        : >  .config
        echo "CONFIG_TARGET_${BUILD_TARGET%/*}=y" >> .config
        echo "CONFIG_TARGET_${TARGET_NAME}=y" >> .config
        echo "CONFIG_TARGET_MULTI_PROFILE=y"  >> .config
        for pkg in $ALL_PACKAGES
        do
            echo -n "installing package $pkg  ..."
            echo "CONFIG_PACKAGE_${pkg}=m" >> .config
            echo "done"
        done
        for pkg in $ALL_MODULES
        do
            [ -f "$MODULE_DIR/$pkg/Makefile" ] || continue
            echo -n "installing module $pkg ..."
            echo "CONFIG_PACKAGE_kmod-${pkg}=m" >> .config
            # touch file to ensure its made
            touch package/kernel/linux/Makefile
            echo "done"
        done
        make oldconfig CONFDEFAULT=n Config.in
        echo "done building .config"
        declare "$(grep '^CONFIG_TARGET_ARCH_PACKAGES='  .config)"
        CONFIG_TARGET_ARCH_PACKAGES=${CONFIG_TARGET_ARCH_PACKAGES//\"/}
        make -j8 V=s || true
        #copy files
        BIN_PKG="${BIN_DIR}/${CONFIG_TARGET_ARCH_PACKAGES}"
        mkdir -p $BIN_PKG
        BIN_MOD="${BIN_DIR}/$BUILD_TARGET"
        mkdir -p $BIN_MOD
        cp -Rf bin/packages/$CONFIG_TARGET_ARCH_PACKAGES/local/* $BIN_PKG
        ./scripts/diffconfig.sh > $BIN_MOD/diffconfig
        for module in $ALL_MODULES
        do
            find bin/targets/$BUILD_TARGET/packages -name "kmod-${module}*.ipk"  -exec  cp -Rf {}  "$BIN_MOD" \;
        done
        cd ${BIN_DIR}
        zip -r $TARGET_NAME.zip  "${CONFIG_TARGET_ARCH_PACKAGES}" $BUILD_TARGET
    done
    
} &> >(tee -a $BUILDLOG)
find $BIN_DIR -type f
