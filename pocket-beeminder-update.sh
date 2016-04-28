#!/bin/bash
. ~/.apikeys

NUM_UNREAD=`curl -X POST "https://getpocket.com/v3/get" -d consumer_key=$POCKET_CONSUMER_KEY -d access_token=$POCKET_ACCESS_TOKEN -d detailType=simple | jq '.list | reduce .[] as $item (0; . + 1)'`

RESULT=`curl -X POST "https://www.beeminder.com/api/v1/users/coiley/goals/pocket/datapoints.json?auth_token=$BEEMINDER_TOKEN&value=$NUM_UNREAD&comment=cron-job-$(date +%H:%M)"`

if [[ $? -ne 0 ]]; then
  zenity --error --text "Curl failed"
elif [[ `echo $RESULT | jq '.status'` != *created* ]]; then
  zenity --error --text "Error submitting beeminder: $RESULT"
else
  notify-send "Pocket beemind submitted: $NUM_UNREAD"
fi
