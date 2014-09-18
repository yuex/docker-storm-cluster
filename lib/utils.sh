#!/usr/bin/env sh
if [ ${USERNAME} != 'root' ];then
    echo "docker needs root permission, quit..."
    exit -1
fi
