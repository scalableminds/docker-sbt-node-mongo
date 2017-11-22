# Dockerized SBT, Node & Mongo

[![CircleCI Status](https://circleci.com/gh/scalableminds/docker-sbt-node-mongo.svg?&style=shield&circle-token=f5f66df37a41fa2c6890148718608ec99a7a135c)](https://circleci.com/gh/scalableminds/docker-sbt-node-mongo)

The images are available on the [Docker Hub](https://hub.docker.com/r/scalableminds/sbt/), and based on [OpenJDK 8](https://github.com/docker-library/openjdk/tree/master/8-jdk).

# Usage

Run the sbt image with your favorite tag:

```
# gives you a bash:
docker run scalableminds/sbt:sbt-0.13.15_mongo-3.2.1_node-8.x_jdk-8
# interactive sbt:
docker run scalableminds/sbt:sbt-0.13.15_mongo-3.2.1_node-8.x_jdk-8 sbt
# run a specific command:
docker run scalableminds/sbt:sbt-0.13.15_mongo-3.2.1_node-8.x_jdk-8 yarn install
```

## Hints:

Besides your project, you might want to mount caches, like
* `/home/$USER/.m2`
* `/home/$USER/.ivy2`
* `/home/$USER/.sbt`
* `/usr/local/share/.cache/yarn`

Also, you can specify the user with those environment variables:
* `USER_UID`
* `USER_GID`
* `USER_NAME`

The timezone can be set specifying `TZ`.

# Supported tags

Check which tags are available on [Docker Hub](https://hub.docker.com/r/scalableminds/sbt/tags/). Older tags might behave differently, currently updated versions are specified in the [versions.txt](versions.txt).

# Builds

The Docker images are built by [CircleCI](https://circleci.com/gh/scalableminds/docker-sbt-node-mongo).

# License

[MIT 2016 scalable minds](LICENSE.txt)
