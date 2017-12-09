#!/usr/bin/env bash

set -e

DEPLOY_DIST_DIR=deploy/dist

build () {
  set -x
  rm -rf $DEPLOY_DIST_DIR/
  mkdir -p $DEPLOY_DIST_DIR/client/
  yarn build
  cp -R client/dist/. $DEPLOY_DIST_DIR/client/
  cp -R server/. $DEPLOY_DIST_DIR/
  rm -rf $DEPLOY_DIST_DIR/*.test.js $DEPLOY_DIST_DIR/**/*.test.js
}

start () {
  set -x
  pushd deploy/
    docker-compose stop
    docker-compose rm -vf
    docker-compose pull
    docker-compose up -d db
    docker-compose exec db mongoimport --db admin --collection users --file /seedData/users.json
    docker-compose exec db mongoimport --db admin --collection opportunities --file /seedData/opportunities.json
    docker-compose up -d app
  popd
}

stop () {
  set -x
  pushd deploy/
    docker-compose stop
    docker-compose rm -vf
  popd
}

ci_deploy_to_test () {
  build
  docker build -t blueberrymozart/test-c2c -f deploy/Dockerfile .
  docker login -u "$DOCKER_USERNAME" -p "$DOCKER_PASSWORD"
  docker push blueberrymozart/test-c2c
ssh test-c2c <<EOF
  cd ~/workspace/calltocode.org &&
  git checkout . &&
  git checkout master &&
  git pull origin master &&
  ./deploy/run.sh start
EOF
}

info () {
cat <<EOF
  Usage: ./deploy/run.sh <target>
  Targets:
    build - bundles the client and server into a single distribution
    start - start the database and app with docker
    stop - stop the database and app
EOF
}

case $1 in
  build)                build               ;;
  start)                start               ;;
  stop)                 stop                ;;
  ci_deploy_to_test)    ci_deploy_to_test   ;;
  *)                    info                ;;
esac
