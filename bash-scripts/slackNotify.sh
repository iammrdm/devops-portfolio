#!/bin/bash

type=${1}
slackMessage=${2}
slackChannelWebHook=${3}
serverType=${4}


sendInstanceNotif() {
    curl -X POST -H 'Content-type: application/text' \
    -d '{"text": "'${serverType}' Instance state is '${slackMessage}'"}' \
    ${slackChannelWebHook}
}

sendPublicIPNotif() {
    curl -X POST -H 'Content-type: application/text' \
    -d '{"text": "'${serverType}'Instance Public IP is '${slackMessage}'"}' \
    ${slackChannelWebHook}
}

posUrl() {
    curl -X POST -H 'Content-type: application/text' \
    -d '{"text": "'${serverType}' POS can be accessed at '${slackMessage}'"}' \
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