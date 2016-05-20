FROM java:8-jdk


ARG VERSION_SBT="0.13.9"
ARG VERSION_MONGO="3.2.1"
ARG VERSION_NODE="4.x"


# Install sbt, mongo, node, chromium & build-essentials
RUN \
  VERSION_MONGO_SHORT=$(echo "$VERSION_MONGO" | cut -f1-2 -d".") \
  && wget -q "https://dl.bintray.com/sbt/debian/sbt-${VERSION_SBT}.deb" \
  && dpkg -i "sbt-${VERSION_SBT}.deb" \
  && rm "sbt-${VERSION_SBT}.deb" \
  && curl -sL "https://deb.nodesource.com/setup_${VERSION_NODE}" | bash - \
  && apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv EA312927 \
  && echo "deb http://repo.mongodb.org/apt/debian wheezy/mongodb-org/$VERSION_MONGO_SHORT main" | \
      tee /etc/apt/sources.list.d/mongodb-org-3.2.list \
  && apt-get update \
  && apt-get install -y \
      build-essential \
      chromium \
      mongodb-org-shell="${VERSION_MONGO}" \
      mongodb-org-tools="${VERSION_MONGO}" \
      nodejs \
      xvfb \
  && apt-get clean \
  && ln -s /usr/bin/chromium /usr/bin/google-chrome


# Init-Script for xvfb
COPY init.d/xvfb /etc/init.d/xvfb


# Mount your sbt project at /project
COPY entrypoint.sh /entrypoint.sh
RUN \
  mkdir -p /project \
  && chmod +x /entrypoint.sh \
  && chmod +x /etc/init.d/xvfb
WORKDIR /project
ENTRYPOINT [ "/entrypoint.sh" ]
