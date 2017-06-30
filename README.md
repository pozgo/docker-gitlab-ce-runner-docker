# GitLab Runner in a Docker with docker in docker support

[![CircleCI Build Status](https://img.shields.io/circleci/project/pozgo/docker-gitlab-ce-runner-docker/master.svg)](https://circleci.com/gh/pozgo/docker-gitlab-ce-runner-docker/tree/master)
[![GitHub Open Issues](https://img.shields.io/github/issues/pozgo/docker-gitlab-ce-runner-docker.svg)](https://github.com/pozgo/docker-gitlab-ce-runner-docker/issues)
[![GitHub Stars](https://img.shields.io/github/stars/pozgo/docker-gitlab-ce-runner-docker.svg)](https://github.com/pozgo/docker-gitlab-ce-runner-docker)
[![GitHub Forks](https://img.shields.io/github/forks/pozgo/docker-gitlab-ce-runner-docker.svg)](https://github.com/pozgo/docker-gitlab-ce-runner-docker-docker)  
[![Stars on Docker Hub](https://img.shields.io/docker/stars/polinux/gitlab-ce-runner-docker.svg)](https://hub.docker.com/r/polinux/gitlab-ce-runner-docker)
[![Pulls on Docker Hub](https://img.shields.io/docker/pulls/polinux/gitlab-ce-runner-docker.svg)](https://hub.docker.com/r/polinux/gitlab-ce-runner-docker)  
[![](https://images.microbadger.com/badges/image/polinux/gitlab-ce-runner-docker.svg)](http://microbadger.com/images/polinux/gitlab-ce-runner-docker)  


This [Image]() was created for use with GitLab and deploying GitLabCI on local machine without all configuration hell that comes with it. Inside of the container there is fully working docker daemon which is listening on port `2375`(Docker in Docker).

### Basic usage

    docker run \
      --name gitlab-runner \
      -d \
      --privileged \
      -e DOCKER_INSECURE_REGISTRY="my-registry:port"
      polinux/gitlab-ce-runner-docker --name="My-Runner" --url="http://my-gitlab.com" --registration-token="my-token" --executor="shell"

Image requires arguments to be passed as command.


### Environmental Variables
`DOCKER_INSECURE_REGISTRY` - specify `insecure-registry` to which you want to push buildt images.  
`DOCKER_STORAGE_SIZE` - Docker storage size in gigabytes. Default set to 10GB

**If AUFS filesystem is used do not sepcify `DOCKER_STORAGE_SIZE`**

**Image need to be run with `--privileged` flag for docker in docker support**

Docker troubleshooting
======================

Use docker command to see if all required containers are up and running:
```
$ docker ps
```

Check logs of docker container:
```
$ docker logs gitlab-runner
```

Sometimes you might just want to review how things are deployed inside a running
 container, you can do this by executing a _bash shell_ through _docker's
 exec_ command:
```
docker exec -ti gitlab-runner /bin/bash
```

History of an image and size of layers:
```
docker history --no-trunc=true polinux/gitlab-ce-runner-docker | tr -s ' ' | tail -n+2 | awk -F " ago " '{print $2}'
```

## Author

Author: Przemyslaw Ozgo (<linux@ozgo.info>)
