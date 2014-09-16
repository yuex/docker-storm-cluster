# Intro

Bash scripts to deploy a storm cluster **LOCALLY**

# Config

Edit `conf/storm_cluster.conf`

* `SUPERVISOR_NUM` defines the number of storm supervisors.
* `*_TAR` defines the path to the saved images
* `*_IMAGE_TAG` defines the tag name after the images being loaded
* `*_CONTAINER_NAME` defines the name used for container after ran from imagaes

# Command

root permission needed

* `bin/load_image.sh` loads docker images from `*_TAR` defined in `conf/storm_cluster.conf`
* `bin/start.sh` starts all related containers. But the storm web ui may take a while to show up.
* `bin/kill.sh` stops and rm all related containers
* `bin/storm_container_start.sh` will be copied into nimbus and supervisor containers to be executed. Should not be executed manually

# Maintainer

yuecn41 [at] gmail [dot] com
