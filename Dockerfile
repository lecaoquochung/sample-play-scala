# https://hub.docker.com/repository/docker/lecaoquochung/scala
# https://github.com/lecaoquochung/sample-play-scala
# scala-build
# version: 1.2.0-build-002
# image: lecaoquochung/scala:latest / branch master
# image: lecaoquochung/scala:dev    / branch dev

# https://github.com/alpinelinux/docker-alpine
FROM alpine:3.16

RUN apk update && apk upgrade

# japanese font
RUN apk add --no-cache curl fontconfig font-noto-cjk \
  && fc-cache -fv

RUN apk add --no-cache \
    java-cacerts openjdk8 ca-certificates \
    git openssh curl \
    python3 screen bash \
    zip tar \
    nodejs npm \
    libuv yarn \
    postgresql-client sudo \
    iputils

ENV JAVA_HOME=/usr/lib/jvm/java-1.8-openjdk
ENV PATH="$JAVA_HOME/bin:${PATH}"

# Basic test
RUN java -version; \
    javac -version; \
    node -v; \
    npm -v; \
    yarn -v; \
    psql -V;

# me-989 - npm  6.14.6 → 8.16.0 
# npm latest version
RUN npm install -g npm

WORKDIR /root/qa

# # Install sbt
# https://github.com/sbt/sbt/releases
RUN curl -L -o /root/sbt.zip https://github.com/sbt/sbt/releases/download/v1.2.8/sbt-1.2.8.zip \
 	&& unzip /root/sbt.zip -d /root \
 	&& rm /root/sbt.zip

# # Put tools like aws and sbt in the PATH
ENV PATH /root/.local/bin:/root/sbt/bin:/root/bin:${PATH}

# sbt build
RUN sbt sbtVersion

# The scala server will run on port 9000 by default
EXPOSE 9000

# Install mocha for API testing
RUN npm install -g mocha

# Install bats (needed for do-exclusively script)
RUN git clone https://github.com/sstephenson/bats.git \
	&& (cd bats && ./install.sh /usr/local) \
	&& rm -rf bats

# Install AWS CLI
RUN curl -O https://bootstrap.pypa.io/get-pip.py \
	&& python3 get-pip.py --user \
	&& pip3 install awscli --upgrade --user \
	&& rm get-pip.py

# Configure aws
RUN aws configure set default.region ap-northeast-1

# Install JQ
RUN mkdir /root/bin
RUN curl -L -o /root/bin/jq https://github.com/stedolan/jq/releases/download/jq-1.5rc1/jq-linux-x86_64-static \
	&& chmod +x /root/bin/jq

# Install Terraform
RUN curl -o /root/terraform.zip https://releases.hashicorp.com/terraform/0.10.3/terraform_0.10.3_linux_amd64.zip \
	&& unzip /root/terraform.zip -d /usr/bin/ \
	&& rm /root/terraform.zip

# Install Puppeteer
RUN apk add --no-cache \
      chromium \
      nss \
      freetype \
      freetype-dev \
      harfbuzz \
      ttf-freefont

# me-989
# executor failed running [/bin/sh -c apk add --no-cache      font-noto-gothic]: exit code: 1
#   && font-noto-cjk \
# RUN apk add --no-cache font-noto-gothic

ENV PUPPETEER_SKIP_CHROMIUM_DOWNLOAD=true \
    PUPPETEER_EXECUTABLE_PATH=/usr/bin/chromium-browser

# RUN set -x \
#     && apk update \
#     && apk upgrade \
#     && apk add --no-cache \
#     udev \
#     ttf-freefont \
#     chromium \
#     && npm install puppeteer@5.3.1 \
#     && PUPPETEER_PRODUCT=firefox npm install

# Init yarn dependencies
RUN mkdir -p /home/qa
COPY package.json /home/qa
RUN yarn install

# me-989 - update node 16x
RUN npm install -g n
RUN n install 16.16
RUN hash -r
RUN yarn add puppeteer
RUN yarn install

# Firefox geckodriver
# https://github.com/lecaoquochung/geckodriver-alpine/blob/master/Dockerfile
# Get all the prereqs
RUN wget -q -O /etc/apk/keys/sgerrand.rsa.pub https://alpine-pkgs.sgerrand.com/sgerrand.rsa.pub
RUN wget https://github.com/sgerrand/alpine-pkg-glibc/releases/download/2.30-r0/glibc-2.30-r0.apk
RUN wget https://github.com/sgerrand/alpine-pkg-glibc/releases/download/2.30-r0/glibc-bin-2.30-r0.apk
RUN apk add glibc-2.30-r0.apk
RUN apk add glibc-bin-2.30-r0.apk

# And of course we need Firefox if we actually want to *use* GeckoDriver
# RUN apk add firefox-esr=60.9.0-r0
RUN apk update && apk upgrade
RUN apk add firefox
RUN rm -rf /var/cache/apk/*

# Then install GeckoDriver
# RUN wget https://github.com/mozilla/geckodriver/releases/download/v0.26.0/geckodriver-v0.26.0-linux64.tar.gz
# RUN wget https://github.com/mozilla/geckodriver/releases/download/v0.26.0/geckodriver-v0.26.0-linux64.tar.gz
# RUN tar -zxf geckodriver-v0.26.0-linux64.tar.gz -C /usr/bin
RUN wget https://github.com/mozilla/geckodriver/releases/download/v0.27.0/geckodriver-v0.27.0-linux64.tar.gz
RUN tar -zxf geckodriver-v0.27.0-linux64.tar.gz -C /usr/bin

# Add user so we don't need --no-sandbox.
RUN addgroup -S qa && adduser -S -g audio,video qa \
    && mkdir -p /home/qa/Downloads /app \
    && chown -R qa:qa /home/qa \
    && chown -R qa:qa /app

# Run everything after as non-privileged user.
# RUN adduser qa sudo
# RUN echo '%sudo ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers
RUN adduser qa wheel
RUN sed -e 's;^# \(%wheel.*NOPASSWD.*\);\1;g' -i /etc/sudoers
USER qa
WORKDIR /home/qa

ENV JAVA_HOME=/usr/lib/jvm/java-1.8-openjdk
ENV PATH="$JAVA_HOME/bin:${PATH}"

# Install sbt user qa
RUN curl -L -o /home/qa/sbt.zip https://github.com/sbt/sbt/releases/download/v1.2.8/sbt-1.2.8.zip \
	&& unzip /home/qa/sbt.zip -d /home/qa \
	&& rm /home/qa/sbt.zip

# Put tools like aws and sbt in the PATH
ENV PATH /home/qa/.local/bin:/home/qa/sbt/bin:/home/qa/bin:${PATH}
RUN sudo ln -s /home/qa/sbt/bin/sbt /usr/local/bin/sbt

# aws-cli
RUN curl -O https://bootstrap.pypa.io/get-pip.py \
	&& python3 get-pip.py --user \
	&& pip3 install awscli --upgrade --user \
	&& rm get-pip.py
RUN sudo ln -s /home/qa/.local/bin/aws /usr/local/bin/aws

# node version
# TODO
# https://github.com/sgerrand/alpine-pkg-glibc/issues/80
# node: /usr/lib/libstdc++.so.6: no version information available (required by node)
RUN sudo npm install -g n
RUN sudo n install 16.16
RUN hash -r
RUN yarn add puppeteer
RUN yarn install

# robotframework
COPY requirements.txt /home/qa
#45 23.03 Collecting h11<1,>=0.9.0
#45 23.10   Downloading h11-0.13.0-py3-none-any.whl (58 kB)
#45 23.12      ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━ 58.2/58.2 kB 4.3 MB/s eta 0:00:00
#45 23.26 Building wheels for collected packages: cffi
#45 23.26   Building wheel for cffi (setup.py): started
#45 24.93   Building wheel for cffi (setup.py): finished with status 'error'
#45 24.97   error: subprocess-exited-with-error
#45 24.97   
#45 24.97   × python setup.py bdist_wheel did not run successfully.
#45 24.97   │ exit code: 1
#45 24.97   ╰─> [67 lines of output]
#45 33.25       error: command 'gcc' failed: Permission denied
#45 33.25       [end of output]
#45 33.25   
#45 33.25   note: This error originates from a subprocess, and is likely not a problem with pip.
#45 33.26 error: legacy-install-failure
#45 33.26 
#45 33.26 × Encountered error while trying to install package.
#45 33.26 ╰─> cffi
RUN pip3 install -r requirements.txt

# build
RUN env
RUN pwd
RUN sbt sbtVersion
RUN pwd;ls -all

RUN npm -v
RUN node -v
RUN yarn --version
RUN cat /home/qa/package.json
RUN sudo chmod 4755 /bin/ping
RUN sudo aws --version
RUN aws --version
RUN python3 --version
RUN pip3 --version
RUN geckodriver --version
