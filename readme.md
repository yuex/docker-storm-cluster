# Intro

Bash scripts to deploy a storm cluster **LOCALLY** using docker container.

# Config

Edit `conf/storm_cluster.conf`

* `SUPERVISOR_NUM` defines the number of storm supervisors.
* `NIMBUS_WEB_UI_PORT` defines which port the storm web ui to be binded to
* `*_TAR` defines the path to the saved images
* `*_IMAGE_TAG` defines the tag name after the images being loaded
* `*_CONTAINER_NAME` defines the name used for container after ran from imagaes
* `*_TEMPLATE` defines the template config yaml in `conf/` for storm nimbus or supervisor

# Command

Because of docker, root permission is needed.

* `bin/load_image.sh` loads docker images from paths defined by `*_TAR`
* `bin/remove_image.sh` removes images loaded from paths defined by `*_TAR`
* `bin/start.sh` starts all related containers. But the storm web ui may take a while to show up.
* `bin/kill.sh` stops and rm all related containers
* `lib/storm_container_start.sh` will be copied into nimbus and supervisor containers to be executed. Should not be executed manually

# Code Snippet Highlight

Here is a code snippet that you may have interest with.

Sometimes, we want to create a configuration file dynamically, e.g., filling in some information such as ip address assigned by DHCP which can only be known at run time. One way is to use `sed` and regular expression to match and replace what we want to edit. It's straightforward, but will be tedious and a nightmare for maintainance when there are too much to edit.

Here I use bash as a engine to render a template config file. If you have some experience with any template language such as jinja2, the idea is similar.

```bash
cat ${template} |
awk '$0 !~ /^\s*#.*$/' |
sed 's/[ "]/\\&/g' |
while read -r line;do
    eval echo ${line}
done >${dst}
```

`awk '$0 !~ /^\s*#.*$/'` ignores the comments start with `#`. `sed 's/[ "]/\\&/g'` escapes double quote and space to preserve their literal meaning from `eval`. In my template there are only double quote and space need escaping.
The while loop will read the template file line by line, eval it (in bash), and finally write the result to the desired location.

Here's the conf snippet from the template file `conf/storm_nimbus.yaml`

```yaml
storm.zookeeper.servers:
    - "${ZK_IP}"
```

After the rendering, the `${ZK_IP}` will be replaced by the enivronment varialbe `${ZK_IP}`

```yaml
storm.zookeeper.servers:
    - "172.16.0.1"
```

# Maintainer

yuecn41 [at] gmail [dot] com
