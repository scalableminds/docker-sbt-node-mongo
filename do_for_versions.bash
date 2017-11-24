#!/usr/bin/env bash
set -Eeuo pipefail

tail -n +2 versions.txt | while read line; do
    VERSION_SBT=$(echo $line | awk '{printf $1}');
    VERSION_MONGO=$(echo $line | awk '{printf $2}');
    VERSION_NODE=$(echo $line | awk '{printf $3}');
    VERSION_TAG="sbt-${VERSION_SBT}_mongo-${VERSION_MONGO}_node-${VERSION_NODE}_jdk-8"
    echo "Execute for $VERSION_TAG"
    eval $@
done;
