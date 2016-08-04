PRODUCT_BRAND ?= zeus

#check device aspect ratio (tablet or phone) to import full screen bootanimation where appropriate
ifdef SCREEN_RATIO_PROPORTIONATE
ifeq ($(SCREEN_RATIO_PROPORTIONATE),true)
# Set bootanimation size to width to differentiate between tablet and phone devices for aspect ratio
TARGET_BOOTANIMATION_SIZE := $(TARGET_SCREEN_WIDTH)
endif
else
# determine the smaller dimension
TARGET_BOOTANIMATION_SIZE := $(shell \
	if [ $(TARGET_SCREEN_WIDTH) -lt $(TARGET_SCREEN_HEIGHT) ]; then \
    echo $(TARGET_SCREEN_WIDTH); \
  else \
    echo $(TARGET_SCREEN_HEIGHT); \
  fi )
endif

TARGET_BOOTANIMATION_NAME := $(TARGET_BOOTANIMATION_SIZE)

ifdef SCREEN_RATIO_PROPORTIONATE
ifeq ($(SCREEN_RATIO_PROPORTIONATE),true)
PRODUCT_BOOTANIMATION := vendor/zeus/prebuilt/common/bootanimation/$(TARGET_SCREEN_ASPECT_RATIO)/$(TARGET_BOOTANIMATION_NAME).zip
endif
else
PRODUCT_BOOTANIMATION := vendor/zeus/prebuilt/common/bootanimation/$(TARGET_BOOTANIMATION_NAME).zip
endif
ifeq ($(TARGET_BOOTANIMATION_HALF_RES),true)
PRODUCT_BOOTANIMATION := vendor/zeus/prebuilt/common/bootanimation/halfres/$(TARGET_BOOTANIMATION_NAME).zip
endif

PRODUCT_BUILD_PROP_OVERRIDES += BUILD_UTC_DATE=0

ifeq ($(PRODUCT_GMS_CLIENTID_BASE),)
PRODUCT_PROPERTY_OVERRIDES += \
    ro.com.google.clientidbase=android-google
else
PRODUCT_PROPERTY_OVERRIDES += \
    ro.com.google.clientidbase=$(PRODUCT_GMS_CLIENTID_BASE)
endif

PRODUCT_PROPERTY_OVERRIDES += \
    keyguard.no_require_sim=true \
    ro.url.legal=http://www.google.com/intl/%s/mobile/android/basic/phone-legal.html \
    ro.url.legal.android_privacy=http://www.google.com/intl/%s/mobile/android/basic/privacy.html \
    ro.com.android.wifi-watchlist=GoogleGuest \
    ro.setupwizard.enterprise_mode=1 \
    ro.com.android.dateformat=MM-dd-yyyy \
    ro.com.android.dataroaming=false

PRODUCT_PROPERTY_OVERRIDES += \
    ro.build.selinux=1

ifneq ($(TARGET_BUILD_VARIANT),user)
# Thank you, please drive thru!
PRODUCT_PROPERTY_OVERRIDES += persist.sys.dun.override=0
endif

ifneq ($(TARGET_BUILD_VARIANT),eng)
# Enable ADB authentication
ADDITIONAL_DEFAULT_PROPERTIES += ro.adb.secure=1
endif

# Copy over the changelog to the device
PRODUCT_COPY_FILES += \
    vendor/zeus/CHANGELOG.mkdn:system/etc/CHANGELOG-ZEUS.txt

# Backup Tool
ifeq ($(WITH_GMS),true)
PRODUCT_COPY_FILES += \
    vendor/zeus/prebuilt/common/bin/backuptool.sh:install/bin/backuptool.sh \
    vendor/zeus/prebuilt/common/bin/backuptool.functions:install/bin/backuptool.functions \
    vendor/zeus/prebuilt/common/bin/50-cm.sh:system/addon.d/50-cm.sh \
    vendor/zeus/prebuilt/common/bin/blacklist:system/addon.d/blacklist
endif

# Backup Services whitelist
PRODUCT_COPY_FILES += \
    vendor/zeus/config/permissions/backup.xml:system/etc/sysconfig/backup.xml

# Signature compatibility validation
PRODUCT_COPY_FILES += \
    vendor/zeus/prebuilt/common/bin/otasigcheck.sh:install/bin/otasigcheck.sh

# LCD density backup
PRODUCT_COPY_FILES += \
    vendor/zeus/prebuilt/common/bin/97-backup.sh:system/addon.d/97-backup.sh \
    vendor/zeus/prebuilt/common/etc/backup.conf:system/etc/backup.conf 

# init.d support
PRODUCT_COPY_FILES += \
    vendor/zeus/prebuilt/common/etc/init.d/00banner:system/etc/init.d/00banner \
    vendor/zeus/prebuilt/common/etc/init.d/85roguegms:system/etc/init.d/85roguegms \
    vendor/zeus/prebuilt/common/bin/sysinit:system/bin/sysinit

ifneq ($(TARGET_BUILD_VARIANT),user)
# userinit support
PRODUCT_COPY_FILES += \
    vendor/zeus/prebuilt/common/etc/init.d/90userinit:system/etc/init.d/90userinit
endif

# ZEUS-specific init file
PRODUCT_COPY_FILES += \
    vendor/zeus/prebuilt/common/etc/init.local.rc:root/init.zeus.rc

# Copy over added mimetype supported in libcore.net.MimeUtils
PRODUCT_COPY_FILES += \
    vendor/zeus/prebuilt/common/lib/content-types.properties:system/lib/content-types.properties

# Enable SIP+VoIP on all targets
PRODUCT_COPY_FILES += \
    frameworks/native/data/etc/android.software.sip.voip.xml:system/etc/permissions/android.software.sip.voip.xml

# Enable wireless Xbox 360 controller support
PRODUCT_COPY_FILES += \
    frameworks/base/data/keyboards/Vendor_045e_Product_028e.kl:system/usr/keylayout/Vendor_045e_Product_0719.kl

# Viper4Android
PRODUCT_COPY_FILES += \
   vendor/zeus/prebuilt/common/bin/audio_policy.sh:system/audio_policy.sh \
   vendor/zeus/prebuilt/common/addon.d/95-LolliViPER.sh:system/addon.d/95-LolliViPER.sh \
   vendor/zeus/prebuilt/common/su.d/50viper.sh:system/su.d/50viper.sh \
   vendor/zeus/prebuilt/common/app/Viper4Android/Viper4Android.apk:system/priv-app/Viper4Android/Viper4Android.apk 

# Zeus Controls
PRODUCT_COPY_FILES += vendor/zeus/prebuilt/common/app/ZeusControls/ZeusControls.apk:system/priv-app/ZeusControls/ZeusControls.apk

# This is ZEUS!
PRODUCT_COPY_FILES += \
    vendor/zeus/config/permissions/com.cyanogenmod.android.xml:system/etc/permissions/com.cyanogenmod.android.xml

# Theme engine
include vendor/zeus/config/themes_common.mk

# CMSDK
include vendor/zeus/config/cmsdk_common.mk

# Required CM packages
PRODUCT_PACKAGES += \
    CMAudioService \
    Development \
    BluetoothExt \
    Profiles \
    ThemeManagerService

# Optional ZEUS packages
PRODUCT_PACKAGES += \
    libemoji \
    Terminal

# Include librsjni explicitly to workaround GMS issue
PRODUCT_PACKAGES += \
    librsjni

# Omni Apps
PRODUCT_PACKAGES += \
    OmniSwitch
 
# Custom ZEUS packages
PRODUCT_PACKAGES += \
    Launcher3 \
    Trebuchet \
    AudioFX \
    CMWallpapers \
    CMFileManager \
    Eleven \
    LockClock \
    CMSettingsProvider \
    ExactCalculator \
    LiveLockScreenService \
    DataUsageProvider

# DU Utils Library
PRODUCT_PACKAGES += \
    org.dirtyunicorns.utils

PRODUCT_BOOT_JARS += \
    org.dirtyunicorns.utils

# Exchange support
PRODUCT_PACKAGES += \
    Exchange2

# Extra tools in ZEUS
PRODUCT_PACKAGES += \
    libsepol \
    mke2fs \
    tune2fs \
    nano \
    htop \
    mkfs.ntfs \
    fsck.ntfs \
    mount.ntfs \
    gdbserver \
    micro_bench \
    oprofiled \
    sqlite3 \
    strace \
    pigz

WITH_EXFAT ?= true
ifeq ($(WITH_EXFAT),true)
TARGET_USES_EXFAT := true
PRODUCT_PACKAGES += \
    mount.exfat \
    fsck.exfat \
    mkfs.exfat
endif

# Openssh
PRODUCT_PACKAGES += \
    scp \
    sftp \
    ssh \
    sshd \
    sshd_config \
    ssh-keygen \
    start-ssh

# rsync
PRODUCT_PACKAGES += \
    rsync

# Stagefright FFMPEG plugin
PRODUCT_PACKAGES += \
    libffmpeg_extractor \
    libffmpeg_omx \
    media_codecs_ffmpeg.xml

PRODUCT_PROPERTY_OVERRIDES += \
    media.sf.omx-plugin=libffmpeg_omx.so \
    media.sf.extractor-plugin=libffmpeg_extractor.so

# These packages are excluded from user builds
ifneq ($(TARGET_BUILD_VARIANT),user)
PRODUCT_PACKAGES += \
    procmem \
    procrank \
    su
endif

PRODUCT_PROPERTY_OVERRIDES += \
    persist.sys.root_access=0

DEVICE_PACKAGE_OVERLAYS += vendor/zeus/overlay/common

PRODUCT_VERSION_MAJOR = 13
PRODUCT_VERSION_MINOR = 0
PRODUCT_VERSION_MAINTENANCE = 0-RC0

# Set CM_BUILDTYPE from the env RELEASE_TYPE, for jenkins compat

PRODUCT_VERSION = 6.0.1
    ZEUS_VERSION := Zeus-Marshmallow-v$(PRODUCT_VERSION)-$(shell date -u +%Y%m%d)-$(ZEUS_BUILD)

PRODUCT_PROPERTY_OVERRIDES += \
  ro.zeus.version=$(ZEUS_VERSION) \
  ro.zeus.releasetype=$(ZEUS_BUILDTYPE) \
  ro.modversion=$(ZEUS_VERSION) \
  ro.cmlegal.url=https://cyngn.com/legal/privacy-policy

-include vendor/cm-priv/keys/keys.mk

ZEUS_DISPLAY_VERSION := $(ZEUS_VERSION)

ifneq ($(PRODUCT_DEFAULT_DEV_CERTIFICATE),)
ifneq ($(PRODUCT_DEFAULT_DEV_CERTIFICATE),build/target/product/security/testkey)
  ifneq ($(ZEUS_BUILDTYPE), UNOFFICIAL)
    ifndef TARGET_VENDOR_RELEASE_BUILD_ID
      ifneq ($(ZEUS_EXTRAVERSION),)
        # Remove leading dash from ZEUS_EXTRAVERSION
        ZEUS_EXTRAVERSION := $(shell echo $(ZEUS_EXTRAVERSION) | sed 's/-//')
        TARGET_VENDOR_RELEASE_BUILD_ID := $(ZEUS_EXTRAVERSION)
      else
        TARGET_VENDOR_RELEASE_BUILD_ID := $(shell date -u +%Y%m%d)
      endif
    else
      TARGET_VENDOR_RELEASE_BUILD_ID := $(TARGET_VENDOR_RELEASE_BUILD_ID)
    endif
    ZEUS_DISPLAY_VERSION=$(PRODUCT_VERSION_MAJOR).$(PRODUCT_VERSION_MINOR)-$(TARGET_VENDOR_RELEASE_BUILD_ID)
  endif
endif
endif

PRODUCT_PROPERTY_OVERRIDES += \
  ro.zeus.display.version=$(ZEUS_DISPLAY_VERSION)

-include $(WORKSPACE)/build_env/image-auto-bits.mk

-include vendor/cyngn/product.mk

$(call prepend-product-if-exists, vendor/extra/product.mk)
