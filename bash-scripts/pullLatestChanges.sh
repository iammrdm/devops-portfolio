#!/bin/bash

cmd=${1}
gitSshUrl=${2}
folderPath=${3}

cloneRepo() {
    echo -e "[INFO]"
}

pullLatest() {
    echo -e "[INFO]"
}


case ${cmd} in

    clone)

    ;;

    update)

    ;;

    *)
        echo -e "[INFO] Usage"
    ;;
esac