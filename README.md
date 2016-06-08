# Dockerized SBT, Node & Mongo

[![CircleCI Status](https://circleci.com/gh/scalableminds/docker-sbt-node-mongo.svg?&style=shield&circle-token=f5f66df37a41fa2c6890148718608ec99a7a135c)](https://circleci.com/gh/scalableminds/docker-sbt-node-mongo)

The images are available on the [Docker Hub](https://hub.docker.com/r/scalableminds/sbt/), and based on [OpenJDK 8](https://github.com/docker-library/openjdk/tree/master/8-jdk).

# Usage

First pull the sbt image with your favorite tag:

```
 docker pull scalableminds/sbt:sbt-0.13.9_mongo-3.2.1_node-4.x_jdk-8
```

Then run the default `sbt` command like this:

```
 docker run  \
   --volume="$HOME/yourproject:/project" \
   --volume="$HOME/.sbt:/root/.sbt" \
   --volume="$HOME/.m2:/root/.m2" \
   --volume="$HOME/.ivy2:/root/.ivy2" \
   scalableminds/sbt:sbt-0.13.9_mongo-3.2.1_node-4.x_jdk-8
```

This will mount your project to `/project` inside the container, which is the container's working directory. Further, your local sbt, maven, and ivy2 caches are mounted into the container. As the default entrypoint is `sbt`, you can directly append any sbt command like this:

```
 docker run  \
   --volume="$HOME/yourproject:/project" \
   --volume="$HOME/.sbt:/root/.sbt" \
   --volume="$HOME/.m2:/root/.m2" \
   --volume="$HOME/.ivy2:/root/.ivy2" \
   scalableminds/sbt:sbt-0.13.9_mongo-3.2.1_node-4.x_jdk-8 clean compile
```

It is possible to handle the volumes via [docker-compose](https://docs.docker.com/compose), so running your project inside docker becomes:

```
 export VERSION_TAG=sbt-0.13.9_mongo-3.2.1_node-4.x_jdk-8
 docker-compose run example
```

You can also use the normal sbt commands or link other containers:

```
 export VERSION_TAG=sbt-0.13.9_mongo-3.2.1_node-4.x_jdk-8
 docker-compose run example-sbt         # interactive sbt console
 docker-compose run example-sbt compile
 docker-compose run example-mongo       # connecting to another mongo container
```

For more details, see the [example docker-compose file](docker-compose.yml).

# Supported tags

- `sbt-0.13.9_mongo-3.2.1_node-4.x_jdk-8`

See also [here](https://hub.docker.com/r/scalableminds/sbt/tags/).

# Builds

The Docker images are built by [CircleCI](https://circleci.com/gh/scalableminds/docker-sbt-node-mongo).
