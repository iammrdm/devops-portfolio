#!/bin/bash

slackMessage=${1}
slackChannelWebHook=${2}

 curl -X POST -H 'Content-type: application/text' \
  -d '{"text": "Instance state is '${slackMessage}'"}' \
  ${slackChannelWebHook}