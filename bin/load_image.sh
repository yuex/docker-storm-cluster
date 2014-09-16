#!/usr/bin/env sh
source conf/storm_cluster.conf

function docker_load {
    CMD="docker load < $1"
    echo -n "${CMD}..."
    eval ${CMD}
    echo "DONE"
}

function tag_newly_loaded_image {
    ID=`docker images|grep -e '^<none>\s\+<none>'|awk '{print $3}'`
    docker tag $ID $1
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
            echo "$FUNCNAME: " "$name already existed"
            exit -2
        fi
    done
    echo "PASS"
}

check_docker_image_none_none

check_name_sanity ${ZK_IMAGE_TAG} ${KAFKA_IMAGE_TAG} ${STORM_IMAGE_TAG}

docker_load ${ZK_TAR}
tag_newly_loaded_image ${ZK_IMAGE_TAG}

#docker_load ${KAFKA_TAR}
#tag_newly_loaded_image ${KAFKA_IMAGE_TAG}

docker_load ${STORM_TAR}
tag_newly_loaded_image ${STORM_IMAGE_TAG}
