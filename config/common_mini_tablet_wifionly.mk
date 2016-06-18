# Inherit common ZEUS stuff
$(call inherit-product, vendor/zeus/config/common_mini.mk)

# Required ZEUS packages
PRODUCT_PACKAGES += \
    LatinIME

ifeq ($(TARGET_SCREEN_WIDTH) $(TARGET_SCREEN_HEIGHT),$(space))
    PRODUCT_COPY_FILES += \
        vendor/zeus/prebuilt/common/bootanimation/800.zip:system/media/bootanimation.zip
endif
