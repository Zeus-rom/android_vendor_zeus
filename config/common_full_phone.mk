# Inherit common ZEUS stuff
$(call inherit-product, vendor/zeus/config/common_full.mk)

# Required ZEUS packages
PRODUCT_PACKAGES += \
    LatinIME

# Include ZEUS LatinIME dictionaries
PRODUCT_PACKAGE_OVERLAYS += vendor/zeus/overlay/dictionaries

# Default notification/alarm sounds
PRODUCT_PROPERTY_OVERRIDES += \
    ro.config.notification_sound=Argon.ogg \
    ro.config.alarm_alert=Helium.ogg

ifeq ($(TARGET_SCREEN_WIDTH) $(TARGET_SCREEN_HEIGHT),$(space))
    PRODUCT_COPY_FILES += \
        vendor/zeus/prebuilt/common/bootanimation/480.zip:system/media/bootanimation.zip
endif

$(call inherit-product, vendor/zeus/config/telephony.mk)
