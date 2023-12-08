FROM ghcr.io/linuxserver/baseimage-kasmvnc:alpine318

# set version label
ARG BUILD_DATE
ARG VERSION
ARG INKSCAPE_VERSION
LABEL build_version="Linuxserver.io version:- ${VERSION} Build-date:- ${BUILD_DATE}"
LABEL maintainer="thelamer"

# title
ENV TITLE=Inkscape

RUN \
  echo "**** install packages ****" && \
  if [ -z ${INKSCAPE_VERSION+x} ]; then \
    INKSPACE_VERSION=$(curl -sL "http://dl-cdn.alpinelinux.org/alpine/v3.18/community/x86_64/APKINDEX.tar.gz" | tar -xz -C /tmp \
    && awk '/^P:inkscape$/,/V:/' /tmp/APKINDEX | sed -n 2p | sed 's/^V://'); \
  fi && \
  apk add --no-cache \
    inkscape==${INKSPACE_VERSION} && \
  sed -i 's|</applications>|  <application title="*Inkscape" type="normal">\n    <maximized>yes</maximized>\n  </application>\n</applications>|' /etc/xdg/openbox/rc.xml && \
  echo "**** cleanup ****" && \
  rm -rf \
    /tmp/*

# add local files
COPY /root /

# ports and volumes
EXPOSE 3000

VOLUME /config
