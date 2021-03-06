FROM ruby:2.2.1

# 1. Install dependencies
RUN set -x; \
        apt-get update \
        && apt-get install -y --no-install-recommends \
        openssh-server \
        zlib1g-dev \
        build-essential \
        libssl-dev \
        libreadline-dev \
        libyaml-dev \
        libsqlite3-dev \
        sqlite3 \
        libxml2-dev \
        libxslt1-dev \
        libcurl4-openssl-dev \
        python-software-properties \
        libffi-dev \
        nodejs \
        git \
        imagemagick \
        libmagickwand-dev

# 2. Clone and install cenit
RUN git clone https://github.com/cenit-io/cenit.git /var/www/cenit
RUN /var/www/cenit/bin/bundle install
WORKDIR /var/www/cenit
