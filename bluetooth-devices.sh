# Bluetooth audio device table, sourced by .bashrc (which generates the
# per-device aliases from it) and by bin/bt-hfp-reconnect.
#
# These dotfiles are shared between machines and the devices are not: an entry
# here is not expected to be paired on every host.

declare -A BT_AUDIO_DEVICES=(
  [sony]=94:DB:56:A3:35:9D
  [air]=20:74:CF:3F:73:25
  [shoks]=A8:F5:E1:5E:D9:63
  [anker]=9C:0C:35:AE:C6:B0
  [bose]=78:2B:64:CD:11:EE
  [ugreen]=00:02:5B:02:52:BE
)

# PipeWire names a bluez card after the uppercased MAC with underscores.
bt_card_name() {
  local mac=${1^^}
  printf 'bluez_card.%s' "${mac//:/_}"
}
