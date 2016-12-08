#!/bin/sh
set -eu
log() {
  if [[ "$@" ]]; then echo "[`date +'%Y-%m-%d %T'`] $@";
  else echo; fi
}

register() {
  gitlab-runner register \
    --non-interactive \
    --name="${GITLAB_CE_NAME}" \
    --url="${GITLAB_CE_COORDINATOR}" \
    --registration-token="${GITLAB_CE_REGISTRATION_TOKEN}" \
    --executor="${GITLAB_CE_EXECUTORS}" \
    --tag-list="${GITLAB_CE_TAG_LIST}"
}
start_runner() {
  gitlab-runner run --user=gitlab-runner --working-directory=/home/gitlab-runner --syslog --config /etc/gitlab-runner/config.toml &
  log "GitLab Runner Started."
  log "Name:  ${GITLAB_CE_NAME}"
  log "Token: ${GITLAB_CE_REGISTRATION_TOKEN}"
}

set_devicemapper_size() {
  mkdir -p /docker/devicemapper/devicemapper
  dd if=/dev/zero of=/docker/devicemapper/devicemapper/data bs=1G count=0 seek=${DOCKER_STORAGE_SIZE}
  log "Docker Storage set to: ${DOCKER_STORAGE_SIZE} GB"
}

if [ ${GITLAB_CE_COORDINATOR} != "localhost" ]; then
  register
  start_runner
else
  log "GitLab CI Link not defined. Rolling into docker in docker mode only"
fi
# Docker Daemon Start
log "Starting Docker Daemon on port: ${DOCKER_PORT}"
set_devicemapper_size
# Validate support for insecure-registry
if [[ ${DOCKER_INSECURE_REGISTRY} != "No-Insecure-Registry" ]]; then
  log "Insecure Registry: ${DOCKER_INSECURE_REGISTRY}"
  /usr/bin/docker daemon -g /docker -H tcp://0.0.0.0:${DOCKER_PORT} -H unix:///var/run/docker.sock --insecure-registry ${DOCKER_INSECURE_REGISTRY} --storage-opt dm.basesize=${DOCKER_STORAGE_SIZE}G
else
  log "No insecure registry defined, ignoring option --insecure-registry"
  /usr/bin/docker daemon -g /docker -H tcp://0.0.0.0:${DOCKER_PORT} -H unix:///var/run/docker.sock  --storage-opt dm.basesize=${DOCKER_STORAGE_SIZE}G
  fi
