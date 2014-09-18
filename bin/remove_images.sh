#!/usr/bin/env sh
source lib/utils.sh
source conf/storm_cluster.conf

CMD=bin/load_images.sh

function remove_image {
    local tag_name=$1
    local grep_pattern=`echo ${tag_name} |sed 's/^/^/' |sed 's/:/\\\\s\\\\+/'`
    if `docker images |grep -e ${grep_pattern} >/dev/null`; then
        docker rmi ${tag_name} > /dev/null
    fi
    echo "removing image ${tag_name}...DONE" 
}

for name in \
    ${STORM_IMAGE_TAG} \
    ${KAFKA_IMAGE_TAG} \
    ${ZK_IMAGE_TAG} \
; do
    remove_image ${name} &
done
wait
