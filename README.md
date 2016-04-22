# Dockerized SBT, Node & Mongo

[![CircleCI Status](https://circleci.com/gh/scalableminds/docker-sbt-node-mongo.svg?&style=shield&circle-token=f5f66df37a41fa2c6890148718608ec99a7a135c)](https://circleci.com/gh/scalableminds/docker-sbt-node-mongo)

The images are available on the [Docker Hub](https://hub.docker.com/r/scalableminds/sbt/), and based on [OpenJDK 8](https://github.com/docker-library/openjdk/tree/master/8-jdk).

# Usage

First pull the sbt image with your favorite tag:

```
 docker pull scalableminds/sbt:sbt-0.13.9_mongo-3.2.1_node-4.x_jdk-8
```

Then you can run the default `sbt` command like this:

```
 docker run  --volume="$HOME/yourproject:/project" --volume="$HOME/.sbt:/root/.sbt" --volume="$HOME/.m2:/root/.m2" --volume="$HOME/.ivy2:/root/.ivy2" scalableminds/sbt:sbt-0.13.9_mongo-3.2.1_node-4.x_jdk-8
```

This image is configured with a workdir `/project`, so to build your project you have to mount a volume for your sources. Also you probably want to use the caches, so it is useful to mount them at `/root/.ivy2`, `/root/.sbt`, etc, as shown above.
The default entrypoint is sbt itself, so you can directly append any sbt command. We also suggest to abstract from the volumes via [docker-compose](https://docs.docker.com/compose), so running sbt for your project might just look like:

```
 docker-compose run sbt clean compile
```

# Supported tags

- `sbt-0.13.9_mongo-3.2.1_node-4.x_jdk-8`

# Builds

The Docker images are built by [CircleCI]](https://circleci.com/gh/scalableminds/docker-sbt-node-mongo)
