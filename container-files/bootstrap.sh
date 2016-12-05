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

if [ ${GITLAB_CE_COORDINATOR} != "localhost" ]; then
  register
  start_runner
else
  log "GitLab CI Link not defined. Rolling into docker in docker mode only"
fi
# Docker Daemon Start
log "Starting Docker Daemon on port: ${DOCKER_PORT}"
/usr/bin/docker daemon -H tcp://0.0.0.0:${DOCKER_PORT} -H unix:///var/run/docker.sock