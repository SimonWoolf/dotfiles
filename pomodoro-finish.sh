#!/bin/bash
. ~/.apikeys

mplayer ~/dev/dotfiles/pomodoro-finish.wav

zenity --question --text "Submit pomodoro to beeminder?"

case $? in
  0)
    RESULT=`curl -X POST "https://www.beeminder.com/api/v1/users/coiley/goals/work/datapoints.json?auth_token=$BEEMINDER_TOKEN&value=1&comment=xfce4-timer"`
    if [[ $? -ne 0 ]]; then
      zenity --error --text "Curl failed"
    elif [[ `echo $RESULT | jq '.status'` != *created* ]]; then
      zenity --error --text "Error submitting beeminder: $RESULT"
    else
      notify-send "Pomodoro submitted"
    fi
    ;;
  1)
    break
    ;;
esac
