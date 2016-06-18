# Inherit common ZEUS stuff
$(call inherit-product, vendor/zeus/config/common.mk)

PRODUCT_SIZE := mini

# Include ZEUS audio files
include vendor/zeus/config/zeus_audio.mk

# Default notification/alarm sounds
PRODUCT_PROPERTY_OVERRIDES += \
    ro.config.notification_sound=Argon.ogg \
    ro.config.alarm_alert=Helium.ogg
