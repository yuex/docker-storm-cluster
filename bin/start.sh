#!/usr/bin/env sh
source lib/utils.sh
source conf/storm_cluster.conf

STORM_EXEC_SH=storm_container_start.sh
UTILS_PATH=/opt/utils

function it_may_take_a_while {
    echo "the nimbus web ui may take a while to show up..."
    echo "try to refresh it for 10 secs..."
    echo "nimbus web UI URL http://localhost:${NIMBUS_WEB_UI_PORT}"
}

echo -n "starting ${ZK_CONTAINER_NAME}..."
ZK_CONTAINER_ID=`docker run \
    -it -d --name ${ZK_CONTAINER_NAME} \
    ${ZK_IMAGE_TAG}`
ZK_IP=`docker inspect \
    --format='{{.NetworkSettings.IPAddress}}' \
    ${ZK_CONTAINER_ID}`
echo "${ZK_IP}...DONE"

#ZK_IP=172.17.0.2
echo -n "starting ${NIMBUS_CONTAINER_NAME}..."
NIMBUS_CONTAINER_ID=`docker run \
    -it -d -p ${NIMBUS_WEB_UI_PORT}:8080 \
    --name ${NIMBUS_CONTAINER_NAME} \
    -v $PWD/lib:${UTILS_PATH}/lib \
    -v $PWD/conf:${UTILS_PATH}/conf \
    -v $PWD/jars:/opt/jars \
    --entrypoint='/bin/bash' \
    ${STORM_IMAGE_TAG} \
    ${UTILS_PATH}/lib/${STORM_EXEC_SH} nimbus ${ZK_IP}`
NIMBUS_IP=`docker inspect \
    --format='{{.NetworkSettings.IPAddress}}' \
    ${NIMBUS_CONTAINER_ID}`
echo "${NIMBUS_IP}...DONE"

#NIMBUS_IP=172.17.0.3
function start_supervisor {
    local name=$1
    SUPERVISOR_CONTAINER_ID=`docker run \
        -it -d --name ${name} \
        -v $PWD/lib:${UTILS_PATH}/lib \
        -v $PWD/conf:${UTILS_PATH}/conf \
        --entrypoint='/bin/bash' \
        ${STORM_IMAGE_TAG} \
        ${UTILS_PATH}/lib/${STORM_EXEC_SH} supervisor ${ZK_IP} ${NIMBUS_IP}`
    SUPERVISOR_IP=`docker inspect \
        --format='{{.NetworkSettings.IPAddress}}' \
        ${SUPERVISOR_CONTAINER_ID}`
    echo "starting ${name}...${SUPERVISOR_IP}...DONE"
}

for num in `seq $SUPERVISOR_NUM`;do
    name="${SUPERVISOR_CONTAINER_NAME_PREFIX}_${num}"
    start_supervisor ${name} &
done
wait

it_may_take_a_while
