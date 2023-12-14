#!/bin/bash

type=${1}
slackMessage=${2}
slackChannelWebHook=${3}


sendInstanceNotif() {
    curl -X POST -H 'Content-type: application/text' \
    -d '{"text": "Instance state is '${slackMessage}'"}' \
    ${slackChannelWebHook}
}

sendPublicIPNotif() {
    curl -X POST -H 'Content-type: application/text' \
    -d '{"text": "Instance Public IP is '${slackMessage}'"}' \
    ${slackChannelWebHook}
}

posUrl() {
    curl -X POST -H 'Content-type: application/text' \
    -d '{"text": "POS can be accessed at '${slackMessage}'"}' \
    ${slackChannelWebHook}
}

case ${type} in
    instance)
        sendInstanceNotif
    ;;

    publicip)
        sendPublicIPNotif
    ;;

    pos)
        posUrl
    ;;

esac