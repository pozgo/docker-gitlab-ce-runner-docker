FROM centos:7
MAINTAINER Przemyslaw Ozgo linux@ozgo.info

ENV DOCKER_PORT=2375 \
    DOCKER_COMPOSE_VERSION=1.9.0 \
    GITLAB_CE_COORDINATOR=localhost \
    GITLAB_CE_REGISTRATION_TOKEN=token \
    GITLAB_CE_NAME="my-runner" \
    GITLAB_CE_EXECUTORS="docker" \
    GITLAB_CE_TAG_LIST="test,build,deploy" \
    DOCKER_INSECURE_REGISTRY="No-Insecure-Registry"

COPY container-files /

RUN \
  rpm --rebuilddb && yum clean all && \
  yum install -y docker-engine git wget sudo && \
  yum clean all && \
  curl -L https://github.com/docker/compose/releases/download/${DOCKER_COMPOSE_VERSION}/docker-compose-`uname -s`-`uname -m` > /usr/local/bin/docker-compose && \
  chmod +x /usr/local/bin/docker-compose && \
  curl -L https://gitlab-ci-multi-runner-downloads.s3.amazonaws.com/latest/binaries/gitlab-ci-multi-runner-linux-amd64 > /bin/gitlab-runner && \
  chmod +x /bin/gitlab-runner && \
  useradd --comment 'GitLab Runner' --create-home gitlab-runner --shell /bin/bash && \
  gpasswd -a gitlab-runner docker

EXPOSE 2375

ENTRYPOINT ["/bootstrap.sh"]
