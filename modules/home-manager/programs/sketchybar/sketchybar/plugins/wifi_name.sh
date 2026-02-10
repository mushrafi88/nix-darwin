#!/bin/zsh
####################################################################################################
#
# ABOUT
#
#   A Jamf Pro Extension Attribute which determines the Mac's currently selected SSID.
#
####################################################################################################
#
# HISTORY
#
#   Version 3.0.1, 11-Sep-2025, Dan K. Snelson (@dan-snelson)
#       Updated for macOS 15.7 (and later); thanks, ZP!
#
####################################################################################################

export PATH=/usr/bin:/bin:/usr/sbin:/sbin:/usr/local/bin/
scriptVersion="3.0.1"

wirelessInterface=$( networksetup -listnetworkserviceorder | sed -En 's/^\(Hardware Port: (Wi-Fi|AirPort), Device: (en.)\)$/\2/p' )
ipconfig setverbose 1
result=$( ipconfig getsummary "${wirelessInterface}" | awk -F ' SSID : ' '/ SSID : / {print $2}')
ipconfig setverbose 0

echo "${result}"

