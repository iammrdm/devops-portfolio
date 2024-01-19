#!/bin/bash
set -e

serverType=$1
instanceID=$2
instanceOperation=$3
slackChannelWebHook=$4


checkInstance() {
    instanceState=`aws ec2 describe-instance-status --instance-id ${instanceID} | grep -o running`
    echo "${instanceState}"
}

startInstance() {
    echo -e "[INFO]: Starting ${instanceID}"
        aws ec2 start-instances --instance-ids ${instanceID}
}

stopInstance() {
    echo -e "[INFO]: Stopping ${instanceID}"
    aws ec2 stop-instances --instance-ids ${instanceID}
}

getPublicIP() {
    getPublicIPv4=`aws --region ap-southeast-1 ec2 describe-instances --filters "Name=instance-state-name,Values=running" "Name=instance-id,Values=${instanceID}" --query 'Reservations[*].Instances[*].[PublicIpAddress]' --output text`
    echo -e "${getPublicIPv4}"
}

case ${instanceOperation} in
    start)
        instanceState=$(checkInstance)
        getPublicIP=$(getPublicIP)
            if [[ ${instanceState} == "running"  ]]
                then
                    echo -e "[INFO] Instance is already ${instanceState}."
                        bash ./bash-scripts/slackNotify.sh ${serverType} instance ${instanceState} ${slackChannelWebHook}
                    echo -e "[INFO] Instance Public IP is ${getPublicIP}."
                        bash ./bash-scripts/slackNotify.sh ${serverType} publicip ${getPublicIP} ${slackChannelWebHook}
                else
                    startInstance           
                        bash ./bash-scripts/slackNotify.sh ${serverType} instance ${instanceState} ${slackChannelWebHook}
                    echo -e "[INFO] Instance Public IP is ${getPublicIP}."
                        bash ./bash-scripts/slackNotify.sh ${serverType} publicip ${getPublicIP} ${slackChannelWebHook}
            fi          
    ;;

    stop)
        instanceState=$(checkInstance)
            if [[ ${instanceState} == "running"  ]]
                then
                    stopInstance
                        bash  ./bash-scripts/slackNotify.sh ${serverType} instance stopped ${slackChannelWebHook}
                else
                    echo -e "[INFO] Instance is already stopped."
                        bash ./bash-scripts/slackNotify.sh ${serverType} instance stopped ${slackChannelWebHook}
            fi
        
    ;;

    getIP)
        getPublicIP=$(getPublicIP)
            echo -e "[INFO] Instance Public IP is ${getPublicIP}."
                bash ./bash-scripts/slackNotify.sh publicip ${getPublicIP} ${slackChannelWebHook} ${serverType}
    ;;
    
    *)
        echo -e "[INFO] Usage: ./instance-operations.sh <instance_id> <operation>"
        echo -e "[INFO] Usage: ./instance-operations.sh i-awsdf9879879 start|stop|getIP"
    ;;
esac


