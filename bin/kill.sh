#!/usr/bin/env sh
source conf/storm_cluster.conf

function remove {
    name=$1
    echo -n "removing ${name}..."
    docker ps -a | grep ${name} >/dev/null && \
        docker rm ${name} >/dev/null
    echo "DONE"
}

function stopit {
    name=$1
    echo -n "stopping ${name}..."
    docker ps | grep ${name} >/dev/null && \
        docker stop ${name} >/dev/null
    echo "DONE"
}

function iter_over_all {
    cmd=$1
    for num in `seq ${SUPERVISOR_NUM}`;do
        name="${SUPERVISOR_CONTAINER_NAME_PREFIX}_${num}"
        $cmd ${name}
    done

    for name in \
        ${NIMBUS_CONTAINER_NAME} \
        ${ZK_CONTAINER_NAME} \
        ${KAFKA_CONTAINER_NAME} \
    ;do
        $cmd ${name}
    done
}

iter_over_all stopit
iter_over_all remove
