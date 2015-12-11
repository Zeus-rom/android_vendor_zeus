# Inherit common ZEUS stuff
$(call inherit-product, vendor/zeus/config/common.mk)

# Include ZEUS audio files
include vendor/zeus/config/zeus_audio.mk

# Default notification/alarm sounds
PRODUCT_PROPERTY_OVERRIDES += \
    ro.config.notification_sound=Argon.ogg \
    ro.config.alarm_alert=Helium.ogg

ifeq ($(TARGET_SCREEN_WIDTH) $(TARGET_SCREEN_HEIGHT),$(space))
    PRODUCT_COPY_FILES += \
        vendor/zeus/prebuilt/common/bootanimation/800.zip:system/media/bootanimation.zip
endif
