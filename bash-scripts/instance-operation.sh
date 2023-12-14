#!/bin/bash
set -e


instanceID=$1
instanceOperation=$2
slackChannelWebHook=$3

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
    getPublicIPv4=`aws ec2 describe-instance-status --instance-id ${instanceID} --query 'Reservations[*].Instances[*].PublicIpAddress' --output text`
    echo -e "[INFO]: Getting public ip of ${instanceID}"
}

case ${instanceOperation} in
    start)
        instanceState=$(checkInstance)
        getPublicIP=$(getPublicIP)
            if [[ ${instanceState} == "running"  ]]
                then
                    echo -e "[INFO] Instance is already ${instanceState}."
                        bash ./bash-scripts/slackNotify.sh instance ${instanceState} ${slackChannelWebHook}
                    echo -e "[INFO] Instance Public IP is ${getPublicIP}."
                        bash ./bash-scripts/slackNotify.sh publicip ${getPublicIP} ${slackChannelWebHook}
                else
                    startInstance           
                        bash ./bash-scripts/slackNotify.sh instance ${getPublicIP} ${slackChannelWebHook}
                    echo -e "[INFO] Instance Public IP is ${getPublicIP}."
                        bash ./bash-scripts/slackNotify.sh publicip ${getPublicIP} ${slackChannelWebHook}
            fi          
    ;;

    stop)
        instanceState=$(checkInstance)
            if [[ ${instanceState} == "running"  ]]
                then
                    stopInstance
                        bash  ./bash-scripts/slackNotify.sh instance ${instanceState} ${slackChannelWebHook}
                else
                    echo -e "[INFO] Instance is already stopped."
                        bash ./bash-scripts/slackNotify.sh instance stopped ${slackChannelWebHook}
            fi
        
    ;;

    getIP)
        getPublicIP=$(getPublicIP)
            echo -e "[INFO] Instance Public IP is ${getPublicIP}."
                bash ./bash-scripts/slackNotify.sh publicip ${getPublicIP} ${slackChannelWebHook}
    ;;
    
    *)
        echo -e "[INFO] Usage: ./instance-operations.sh <instance_id> <operation>"
        echo -e "[INFO] Usage: ./instance-operations.sh i-awsdf9879879 start"
    ;;
esac


