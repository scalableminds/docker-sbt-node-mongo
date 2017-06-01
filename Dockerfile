FROM openjdk:8-jdk


ARG VERSION_SBT="0.13.15"
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
  && curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add - \
  && echo "deb https://dl.yarnpkg.com/debian/ stable main" > /etc/apt/sources.list.d/yarn.list \
  && curl -sS https://mozilla.debian.net/archive.asc | apt-key add - \
  && echo "deb http://mozilla.debian.net/ jessie-backports firefox-release" > /etc/apt/sources.list.d/mozilla.list \
  && apt-get update \
  && apt-get install -y \
      build-essential \
      chromium \
      mongodb-org-shell="${VERSION_MONGO}" \
      mongodb-org-tools="${VERSION_MONGO}" \
      nodejs \
      xvfb \
      yarn \
  && apt-get install -y -t jessie-backports firefox \
  && apt-get clean \
  && ln -s /usr/bin/chromium /usr/bin/google-chrome \
  && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*


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
