FROM polinux/centos-supervisor
MAINTAINER Przemyslaw Ozgo linux@ozgo.info

# DOCKER_STORAGE_SIZE is using Gigabytes as value.
ENV DOCKER_STORAGE_SIZE=10 \
    DOCKER_PORT=2375 \
    DOCKER_COMPOSE_VERSION=1.14.0 \
    DOCKER_VERSION=17.05.0.ce-1 \
    GITLAB_CE_RUNNER_VERSION=9.3.0 \
    DOCKER_INSECURE_REGISTRY="No-Insecure-Registry" \
    DOCKER_REGISTRY_USER=username \
    DOCKER_REGISTRY_PASS=mypass \
    RUNNER_NAME=name \
    RUNNER_URL="http://my-gitlab.com" \
    RUNNER_REGISTRATION_TOKEN=token \
    RUNNER_EXECUTOR=shell \
    RUNNER_MULTI_PARAMS=""

COPY docker.repo /etc/yum.repos.d/docker.repo

RUN \
  rpm --rebuilddb && yum clean all && yum update -y && \
  yum install -y docker-engine-${DOCKER_VERSION}.el7.centos.x86_64 git wget sudo && \
  yum clean all && \
  curl -L https://github.com/docker/compose/releases/download/${DOCKER_COMPOSE_VERSION}/docker-compose-`uname -s`-`uname -m` > /usr/local/bin/docker-compose && \
  chmod +x /usr/local/bin/docker-compose && \
  curl -L https://gitlab-ci-multi-runner-downloads.s3.amazonaws.com/v${GITLAB_CE_RUNNER_VERSION}/binaries/gitlab-ci-multi-runner-linux-amd64 > /bin/gitlab-runner && \
  chmod +x /bin/gitlab-runner && \
  useradd --comment 'GitLab Runner' --create-home gitlab-runner --shell /bin/bash && \
  gpasswd -a gitlab-runner docker

COPY container-files /

EXPOSE 2375
