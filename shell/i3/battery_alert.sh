#! /bin/bash
alert_battery_level=10
critical_battery_level=5
battery_level=`acpi -b | grep -P -o '[0-9]+(?=%)'`

if [ $battery_level -le $low_battery_level ]
then
  notify-send "Low Battery" "Battery level is ${battery_level}%!"
elif [ $battery_level -le $critical_battery_level ]
then
  i3-msg fullscreen disable && i3-nagbar -m "Low battery (${battery_level}%). The system will shutdown your stuff in no time, so, plug me in!"
fi
