#!/bin/sh
set -eu
# User params
USER_PARAMS="--name=\"${RUNNER_NAME}\" --url=\"${RUNNER_URL}\" --registration-token=\"${RUNNER_REGISTRATION_TOKEN}\" --executor=\"${RUNNER_EXECUTOR}\" ${RUNNER_MULTI_PARAMS}"
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
register
