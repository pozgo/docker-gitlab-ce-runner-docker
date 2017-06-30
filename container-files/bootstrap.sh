#!/bin/sh
set -eu
# User params
USER_PARAMS="${@}"
RUN_CMD="gitlab-runner register --non-interactive ${USER_PARAMS}"
log() {
  if [[ "$@" ]]; then echo "[`date +'%Y-%m-%d %T'`] $@";
  else echo; fi
}
register() {
  if [[ -z ${USER_PARAMS} ]]; then
    log "No registration provided. Runner Quitting"
    exit 1
  else
    log "Registering runner."
    log $RUN_CMD
    bash -c "${RUN_CMD}"
  fi

}
start_runner() {
  gitlab-runner run --user=gitlab-runner --working-directory=/home/gitlab-runner --syslog --config /etc/gitlab-runner/config.toml &
  log "GitLab Runner Started."
}
register
start_runner

# Verify is storage size was defined. (Shouldnt be defined if AUFS used.)
if [ ${DOCKER_STORAGE_SIZE} == "10" ]; then
  VOL_SIZE=""
else
  VOL_SIZE="--storage-opt dm.basesize=${DOCKER_STORAGE_SIZE}G"
fi

# Docker Daemon Start
log "Starting Docker Daemon on port: ${DOCKER_PORT}"
# Validate support for insecure-registry
if [[ ${DOCKER_INSECURE_REGISTRY} != "No-Insecure-Registry" ]]; then
  log "Insecure Registry: ${DOCKER_INSECURE_REGISTRY}"
  /usr/bin/dockerd -g /docker -H tcp://0.0.0.0:${DOCKER_PORT} -H unix:///var/run/docker.sock --insecure-registry ${DOCKER_INSECURE_REGISTRY} ${VOL_SIZE}
else
  log "No insecure registry defined, ignoring option --insecure-registry"
  /usr/bin/dockerd -g /docker -H tcp://0.0.0.0:${DOCKER_PORT} -H unix:///var/run/docker.sock ${VOL_SIZE}
fi
