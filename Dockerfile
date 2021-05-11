FROM adoptopenjdk/openjdk8:debian-slim

RUN apt-get update \
  && apt-get upgrade -y \
  && apt-get install -y gpg unzip \
  && rm -rf /var/lib/apt/lists/*

# Use tini as subreaper in Docker container to adopt zombie processes
ARG TINI_VERSION=v0.16.1
COPY tini_pub.gpg /tmp/tini_pub.gpg
RUN curl -fsSL https://github.com/krallin/tini/releases/download/${TINI_VERSION}/tini-static-$(dpkg --print-architecture) -o /sbin/tini \
  && curl -fsSL https://github.com/krallin/tini/releases/download/${TINI_VERSION}/tini-static-$(dpkg --print-architecture).asc -o /sbin/tini.asc \
  && gpg --no-tty --import /tmp/tini_pub.gpg \
  && gpg --verify /sbin/tini.asc \
  && rm -rf /sbin/tini.asc /root/.gnupg \
  && chmod +x /sbin/tini

RUN mkdir -p /opt/workspace/yc
WORKDIR /opt/workspace/yc

RUN curl -fsSL https://tier1app.com/dist/ycrash/yc-latest.zip -o yc-latest.zip && unzip yc-latest.zip && rm yc-latest.zip

EXPOSE 8080

ENTRYPOINT ["/sbin/tini", "--", "java", "-Xms2g", "-Xmx4g", "-Dapp=yc", "-DlogDir=.", "-DuploadDir=.", "-jar", "webapp-runner-8.0.33.4.jar", "-AconnectionTimeout=3600000", "--port", "8080", "yc.war"]


