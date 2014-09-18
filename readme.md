# Intro

Bash scripts to deploy a storm cluster **LOCALLY**

# Config

Edit `conf/storm_cluster.conf`

* `SUPERVISOR_NUM` defines the number of storm supervisors.
* `NIMBUS_WEB_UI_PORT` defines which port the storm web ui to be binded to
* `*_TAR` defines the path to the saved images
* `*_IMAGE_TAG` defines the tag name after the images being loaded
* `*_CONTAINER_NAME` defines the name used for container after ran from imagaes
* `*_TEMPLATE` defines the template config yaml in `conf/` for storm nimbus or supervisor

# Command

Root permission needed because of docker.

* `bin/load_image.sh` loads docker images from paths defined by `*_TAR`
* `bin/remove_image.sh` removes images loaded from paths defined by `*_TAR`
* `bin/start.sh` starts all related containers. But the storm web ui may take a while to show up.
* `bin/kill.sh` stops and rm all related containers
* `lib/storm_container_start.sh` will be copied into nimbus and supervisor containers to be executed. Should not be executed manually

# Maintainer

yuecn41 [at] gmail [dot] com
