# Intro

Bash scripts to deploy a storm cluster **LOCALLY**

# Config

Edit `bin/conf.conf`

* `SUPERVISOR_NUM` defines the number of storm supervisors.
* `*_TAR` defines the path to the saved images
* `*_IMAGE_TAG` defines the tag name after the images being loaded
* `*_CONTAINER_NAME` defines the name used for container after ran from imagaes

# Command

* `bin/load_image.sh` loads docker images from `*_TAR` defined in `conf.conf`
* `bin/kill.sh` stops and rm all related containers
* `bin/start.sh` starts all related containers. But the storm web ui may take a while to show up.
* `bin/start_storm_container.sh` will be copied into nimbus and supervisor containers to configure the corresponding container environments and exec storm cmds. Should not be executed manually

# Maintainer

yuecn41 [at] gmail [dot] com
