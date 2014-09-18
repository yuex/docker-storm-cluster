#!/usr/bin/env sh
source lib/utils.sh
source conf/storm_cluster.conf

function docker_load {
    CMD="docker load < $1"
    echo "${CMD}...LOADING"
    eval ${CMD}
    echo "${CMD}...DONE"
}

function tag_newly_loaded_image {
    ID=`docker images|grep -e '^<none>\s\+<none>'|awk '{print $3}'`
    docker tag $ID $1
}

function load_and_tag_image {
    image_name=$1
    tag_name=$2
    if [ ! -e ${image_name} ]; then
        echo "${image_name} not found...EXIT"
        exit -1
    fi
    docker_load ${image_name}
    tag_newly_loaded_image ${tag_name}
}

function check_docker_image_none_none {
    echo -n "checking <none> <none> entry requirement..."
    if `docker images |grep '<none>' >/dev/null`;then
        echo "$FUNCNAME: "'make sure there is no ' \
            '<none> <none> entry in `docker images`'
        exit -1
    fi
    echo "PASS"
}

function check_name_sanity {
    echo -n 'checking name sanity...'
    for name in $*;do
        PATTERN='^'"`echo $name|sed 's/:/\\\s\\\+/g'`"
        if `docker images | grep -e $PATTERN >/dev/null`; then
            echo "FAILED"
            echo "    $name already existed"
            exit -2
        fi
    done
    echo "PASS"
}

check_docker_image_none_none

check_name_sanity ${ZK_IMAGE_TAG} ${KAFKA_IMAGE_TAG} ${STORM_IMAGE_TAG}

for args in \
    "${ZK_TAR} ${ZK_IMAGE_TAG}" \
    "${STORM_TAR} ${STORM_IMAGE_TAG}" \
    #"${KAFKA_TAR} ${KAFKA_IMAGE_TAG}" \
do
    eval load_and_tag_image "${args}"
done
wait
