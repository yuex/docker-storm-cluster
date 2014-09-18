#!/usr/bin/env sh
STORM_PATH=/opt/apache-storm-0.9.2-incubating
STORM_YAML_PATH=${STORM_PATH}/conf/storm.yaml
STORM_CMD=${STORM_PATH}/bin/storm
#STORM_YAML_PATH=./storm.yaml
STORM_STALL_CMD=/bin/bash

NIMBUS_LOG_PATH=/var/log/nimbus.log
NIMBUS_WEB_UI_LOG_PATH=/var/log/nimbus_web_ui.log
SUPERVISOR_LOG_PATH=/var/log/supervisor.log

CMD_NAME=`basename $0`

HELP_MESSAGE="CMD:
    ${CMD_NAME} - config and start a storm container
USAGE:
    ${CMD_NAME} nimbus {ZK_IP}
    ${CMD_NAME} supervisor {ZK_IP} {NIMBUS_IP}
"

function start_as_nimbus {
    ZK_IP=$1

    # update storm.yaml
    cat ${STORM_YAML_PATH} |\
        sed "s/^     - \".*\"$/     - \"${ZK_IP}\"/" \
        > /tmp/storm.yaml && \
        cp /tmp/storm.yaml ${STORM_YAML_PATH}

    ${STORM_CMD} nimbus &> ${NIMBUS_LOG_PATH} &
    ${STORM_CMD} ui &> ${NIMBUS_WEB_UI_LOG_PATH} &

    ${STORM_STALL_CMD}
}

function start_as_supervisor {
    ZK_IP=$1
    NIMBUS_IP=$2
    LOCAL_IP=`ip addr show eth0 |\
        awk '/^ *inet / { print $2 }' |\
        sed 's?/[0-9]\+??' \
        `

    # update storm.yaml
    cat ${STORM_YAML_PATH} |\
        sed "s/^     - \".*\"$/     - \"${ZK_IP}\"/" |\
        sed "s/^ nimbus.host: \".*\"$/ nimbus.host: \"${NIMBUS_IP}\"\n storm.local.hostname: \"${LOCAL_IP}\"/" \
        > /tmp/storm.yaml &&\
        cp /tmp/storm.yaml ${STORM_YAML_PATH}

    ${STORM_CMD} supervisor &> ${SUPERVISOR_LOG_PATH} &

    ${STORM_STALL_CMD}
}

function help_and_exit {
    echo -e "$HELP_MESSAGE"
    exit $1
}

if [ $# -lt 1 ]; then
    help_and_exit -1
fi

TYPE=$1

if [ ${TYPE} = 'nimbus' ]; then
    if [ $# -lt 2 ]; then
        help_and_exit -2
    fi
    start_as_nimbus $2
elif [ ${TYPE} = 'supervisor' ]; then
    if [ $# -lt 3 ]; then
        help_and_exit -3
    fi
    start_as_supervisor $2 $3
elif [ ${TYPE} = 'debug' ]; then
    ZK_IP=172.17.0.2
    NIMBUS_IP=172.17.0.3
    LOCAL_IP=`ip addr show eth0 |\
        awk '/^ *inet / { print $2 }' |\
        sed 's?/[0-9]\+??' \
        `
    cat ${STORM_YAML_PATH} |\
        sed "s/^     - \".*\"$/     - \"${ZK_IP}\"/" |\
        sed "s/^ nimbus.host: \".*\"$/ nimbus.host: \"${NIMBUS_IP}\"\n storm.local.hostname: \"${LOCAL_IP}\"/" \
        > /tmp/storm.yaml &&\
        cp /tmp/storm.yaml ${STORM_YAML_PATH}
else
    echo "$0: unknown storm role ${TYPE}"
    exit -1
fi
