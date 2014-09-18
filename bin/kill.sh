#!/usr/bin/env sh
source lib/utils.sh
source conf/storm_cluster.conf

function remove_force {
    local name=$1
    docker ps -a | grep ${name} >/dev/null && \
        docker rm -f ${name} >/dev/null
    echo "removing ${name}...DONE"
}

function iter_over_all {
    local cmd=$1
    for num in `seq ${SUPERVISOR_NUM}`;do
        local name="${SUPERVISOR_CONTAINER_NAME_PREFIX}_${num}"
        $cmd ${name} &
    done

    # TODO: make the iter a list defined in the conf/conf
    for name in \
        ${NIMBUS_CONTAINER_NAME} \
        ${ZK_CONTAINER_NAME} \
        #${KAFKA_CONTAINER_NAME} \

    do
        $cmd ${name} &
    done
    wait
}

iter_over_all remove_force
