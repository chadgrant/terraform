#!/bin/bash

service_name="sns_notify"

if [ "$1" != "" ]; then
  entrypoint="--entrypoint $1"
fi

docker build -t vevo/lambda_${service_name} .

docker run -it --rm $entrypoint \
    -v $(pwd):/app/local \
    -e "notification_slack_hook=T0287AG68/B3QEXN2N8/bJDHfAUOankFrcHAFHRRokHN" \
    -e "notification_slack_channel=#cs-ops-dev" \
    -e "notification_slack_channel_debug=#slack-debug" \
    -e "service=${service}" \
    -e "environment=development"\
    -e "environment_short_name=dev" \
    vevo/lambda_${service_name}
