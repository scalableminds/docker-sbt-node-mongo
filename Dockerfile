FROM openjdk:8-jdk


ARG VERSION_SBT="0.13.15"
ARG VERSION_MONGO="3.2.17"
ARG VERSION_NODE="8.x"


ENV DEBIAN_FRONTEND noninteractive


# Install sbt, mongo, node, chromium & build-essentials
RUN \
  VERSION_MONGO_SHORT=$(echo "$VERSION_MONGO" | cut -f1-2 -d".") \
  && wget -q "https://dl.bintray.com/sbt/debian/sbt-${VERSION_SBT}.deb" \
  && dpkg -i "sbt-${VERSION_SBT}.deb" \
  && rm "sbt-${VERSION_SBT}.deb" \
  && curl -sL "https://deb.nodesource.com/setup_${VERSION_NODE}" | bash - \
  && apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv EA312927 \
  && echo "deb http://repo.mongodb.org/apt/debian jessie/mongodb-org/$VERSION_MONGO_SHORT main" | \
      tee /etc/apt/sources.list.d/mongodb-org-3.2.list \
  && LIB_SSL_PACKAGE="libssl1.0.0_1.0.1t-1+deb8u6_amd64.deb" \
  && wget -q "http://ftp.de.debian.org/debian/pool/main/o/openssl/$LIB_SSL_PACKAGE" \
  && dpkg -i "$LIB_SSL_PACKAGE" \
  && rm "$LIB_SSL_PACKAGE" \
  && curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add - \
  && echo "deb https://dl.yarnpkg.com/debian/ stable main" > /etc/apt/sources.list.d/yarn.list \
  && apt-get update \
  && apt-get install -y \
      build-essential \
      chromium \
      firefox-esr \
      gosu \
      mongodb-org-shell="${VERSION_MONGO}" \
      mongodb-org-tools="${VERSION_MONGO}" \
      nodejs \
      xvfb \
      yarn \
  && apt-get clean \
  && ln -s /usr/bin/chromium /usr/bin/google-chrome \
  && wget https://download-installer.cdn.mozilla.net/pub/firefox/releases/54.0/linux-x86_64/en-US/firefox-54.0.tar.bz2 \
  && tar xvf firefox-54.0.tar.bz2 \
  && mv $(which firefox) $(which firefox)-old \
  && ln -s $(pwd)/firefox/firefox /usr/bin/firefox \
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
