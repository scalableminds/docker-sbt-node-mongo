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
  && apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv 0C49F3730359A14518585931BC711F9BA15703C6 \
  && apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv 2930ADAE8CAF5059EE73BB4B58712A2291FA4AD5 \
  && echo "deb http://repo.mongodb.org/apt/debian jessie/mongodb-org/$VERSION_MONGO_SHORT main" | \
      tee /etc/apt/sources.list.d/mongodb-org.list \
  && LIB_SSL_PACKAGE="libssl1.0.0_1.0.1t-1+deb8u7_amd64.deb" \
  && wget -q "http://ftp.de.debian.org/debian/pool/main/o/openssl/$LIB_SSL_PACKAGE" \
  && dpkg -i "$LIB_SSL_PACKAGE" \
  && rm "$LIB_SSL_PACKAGE" \
  && curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add - \
  && echo "deb https://dl.yarnpkg.com/debian/ stable main" > /etc/apt/sources.list.d/yarn.list \
  && apt-get update \
  && apt-get install -y \
      build-essential \
      gosu \
      mongodb-org-shell="${VERSION_MONGO}" \
      mongodb-org-tools="${VERSION_MONGO}" \
      nodejs \
      postgresql-client \
      yarn \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*


# Mount your sbt project at /project
COPY entrypoint.sh /entrypoint.sh
RUN \
  mkdir -p /project \
  && chmod +x /entrypoint.sh
WORKDIR /
ENTRYPOINT [ "/entrypoint.sh" ]
CMD ["bash"]
