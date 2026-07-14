#!/bin/bash

WIFI=$(nmcli -t -f active,ssid,signal dev wifi | grep '^yes')
ETH=$(nmcli -t -f TYPE,STATE dev status | grep '^ethernet:connected')

if [ -n "$ETH" ]; then
  echo "🖧  $ETH"
  exit 0
fi

if [ -n "$WIFI" ]; then
  IFS=":" read -r ACTIVE SSID SIGNAL <<< "$WIFI"
  echo "  $SSID ($SIGNAL%)"
  exit 0
fi


echo "  ⚠"
