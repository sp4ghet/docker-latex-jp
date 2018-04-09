FROM frolvlad/alpine-glibc
MAINTAINER sp4ghet <rikuo.hase1997@gmail.com>

ENV PATH /usr/local/texlive/2017/bin/x86_64-linux:$PATH

# Install latex dependencies
RUN apk --no-cache add perl wget xz tar fontconfig-dev && \
    mkdir /tmp/install-tl-unx && \
    wget -qO- ftp://tug.org/texlive/historic/2017/install-tl-unx.tar.gz | \
    tar -xz -C /tmp/install-tl-unx --strip-components=1 && \
    printf "%s\n" \
      "selected_scheme scheme-basic" \
      "option_doc 0" \
      "option_src 0" \
      > /tmp/install-tl-unx/texlive.profile && \
    /tmp/install-tl-unx/install-tl \
      --profile=/tmp/install-tl-unx/texlive.profile && \
    tlmgr install \
      collection-basic collection-latex \
      collection-latexrecommended collection-latexextra \
      collection-fontsrecommended collection-fontsextra collection-langjapanese \
      latexmk \
      bbm bbm-macros amsmath newtx physics && \
    ( tlmgr install xetex || exit 0 ) && \
    rm -fr /tmp/install-tl-unx && \
    apk --no-cache del xz tar fontconfig-dev

RUN apk --no-cache add make bash

# Font settings
ENV TEXMFLOCAL /usr/local/texlive/texmf-local
COPY fonts/* $TEXMFLOCAL/fonts/truetype/public/
COPY maps/* $TEXMFLOCAL/fonts/map/dvipdfmx/genshin/
RUN mktexlsr && \
  kanji-config-updmap-sys genshin

# Change timezone to JST
ENV TIMEZONE Asia/Tokyo
RUN apk --update add tzdata && \
    cp /usr/share/zoneinfo/$TIMEZONE /etc/localtime && \
    apk del tzdata && \
    rm -rf /var/cache/apk/*

# COPY latexmkrc /root/.latexmkrc

# User setting
ARG RUNTIME_USER="alpine"
ENV RUNTIME_UID 1000

RUN adduser -D -s /bin/bash -u $RUNTIME_UID $RUNTIME_USER && \
  mkdir -p /home/$RUNTIME_USER/src && \
  chown -R $RUNTIME_USER /home/$RUNTIME_USER/src && \
  chown -R $RUNTIME_USER /usr/local/texlive/texmf-local/fonts/truetype/

USER $RUNTIME_USER
WORKDIR /home/$RUNTIME_USER/src

COPY latexmkrc /home/$RUNTIME_USER/.latexmkrc

ENTRYPOINT ["latexmk"]

CMD ["bash"]
