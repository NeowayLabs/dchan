FROM golang:1.5

ENV DEBIAN_FRONTEND=noninteractive
ENV ORGMK_EL=/gopath/src/github.com/NeowayLabs/dchan/scripts/orgmk.el

ADD sources.list /etc/apt/sources.list
RUN apt-get update -qq
RUN apt-get install -qq --force-yes emacs24

RUN cd /tmp && git clone https://github.com/fniessen/orgmk && \
    cd orgmk && make -e && make install

RUN mkdir -p /gopath/src/github.com/NeowayLabs/dchan

ADD . /gopath/src/github.com/NeowayLabs/dchan

WORKDIR /gopath/src/github.com/NeowayLabs/dchan

CMD ["make", "build"]
