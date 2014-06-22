FROM ubuntu:14.04

MAINTAINER David Celis

# Install Ruby
RUN apt-get update && \
  DEBIAN_FRONTEND=noninteractive apt-get upgrade -y && \
  DEBIAN_FRONTEND=noninteractive apt-get -y install \
    build-essential \
    curl \
    git-core \
    libcurl4-openssl-dev \
    libreadline-dev \
    libssl-dev \
    libxml2-dev \
    libxslt1-dev \
    libyaml-dev \
    zlib1g-dev && \
  curl -O http://ftp.ruby-lang.org/pub/ruby/2.1/ruby-2.1.2.tar.gz && \
  tar -zxvf ruby-2.1.2.tar.gz && \
  cd ruby-2.1.2 && \
  ./configure --disable-install-doc && \
  make && \
  make install && \
  cd .. && \
  rm -r ruby-2.1.2 ruby-2.1.2.tar.gz && \
  echo 'gem: --no-document' > /usr/local/etc/gemrc

# Install Python.
RUN apt-get install -y python python-dev python-pip

ADD . /tmp/

CMD ["/tmp/runmygi.st"]
