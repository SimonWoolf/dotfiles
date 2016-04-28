#!/bin/bash
. ~/.apikeys

NUM_UNREAD=`curl -X POST "https://getpocket.com/v3/get" -d consumer_key=$POCKET_CONSUMER_KEY -d access_token=$POCKET_ACCESS_TOKEN -d detailType=simple | jq '.list | reduce .[] as $item (0; . + 1)'`

if [[ $? -ne 0 ]]; then
  DISPLAY=:0 zenity --error --text "Pocket curl / jq failed"
  exit 1
fi

RESULT=`curl -X POST "https://www.beeminder.com/api/v1/users/coiley/goals/pocket/datapoints.json?auth_token=$BEEMINDER_TOKEN&value=$NUM_UNREAD&comment=cron-job-$(date +%H:%M)"`

if [[ $? -ne 0 ]]; then
  DISPLAY=:0 zenity --error --text "Beeminder curl failed"
elif [[ `echo $RESULT | jq '.status'` != *created* ]]; then
  DISPLAY=:0 zenity --error --text "Error submitting beeminder: $RESULT"
else
  notify-send "Pocket beemind submitted: $NUM_UNREAD"
fi
