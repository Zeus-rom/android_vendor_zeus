for device in $(cat vendor/zeus/zeus-devices)
do
    add_lunch_combo zeus_$device-userdebug
done
