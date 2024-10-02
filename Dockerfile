# Ubuntu 18.04 LTS (Bionic Beaver)
FROM ubuntu:22.04

# Set environment to avoid interactive prompts
ENV DEBIAN_FRONTEND=noninteractive

# Set timezone non-interactively
ENV TZ=Asia/Tokyo

RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone && \
    apt-get update && apt-get install -y apt-utils tzdata && \
    dpkg-reconfigure --frontend noninteractive tzdata

# Install dependencies
RUN apt-get update && apt-get install -y gnupg2 lsb-release ca-certificates

# === INSTALL BROWSER DEPENDENCIES ===

# Install WebKit dependencies
RUN apt-get update && apt-get install -y --no-install-recommends \
    libwoff1 \
    libopus0 \
    libwebpdemux2 \
    libgudev-1.0-0 \
    libsecret-1-0 \
    libhyphen0 \
    libgdk-pixbuf2.0-0 \
    libegl1 \
    libnotify4 \
    libxslt1.1 \
    libgles2 \
    libxcomposite1 \
    libatk1.0-0 \
    libatk-bridge2.0-0 \
    libepoxy0 \
    libgtk-3-0 \
    libharfbuzz-icu0

# Install gstreamer and plugins to support video playback in WebKit.
RUN apt-get update && apt-get install -y --no-install-recommends \
    libgstreamer-gl1.0-0 \
    libgstreamer-plugins-bad1.0-0 \
    gstreamer1.0-plugins-good \
    gstreamer1.0-libav

# Install Chromium dependencies
RUN apt-get update && apt-get install -y --no-install-recommends \
    libnss3 \
    libxss1 \
    libasound2 \
    fonts-noto-color-emoji \
    libxtst6

# Install Firefox dependencies
RUN apt-get update && apt-get install -y --no-install-recommends \
    libdbus-glib-1-2 \
    libxt6

# Install ffmpeg to bring in audio and video codecs necessary for playing videos in Firefox.
RUN apt-get update && apt-get install -y --no-install-recommends \
    ffmpeg

# (Optional) Install XVFB if there's a need to run browsers in headful mode
RUN apt-get update && apt-get install -y --no-install-recommends \
    xvfb

RUN apt-get update && apt-get install -y --no-install-recommends \
    libc6

# === INSTALL Node.js ===

# Install node 20.x
RUN apt-get update && apt-get install -y curl && \
    curl -sL https://deb.nodesource.com/setup_20.x | bash - && \
    apt-get install -y nodejs

# Feature-parity with node.js base images.
RUN apt-get update && apt-get install -y --no-install-recommends git ssh && \
    npm install -g yarn

# japanese font
RUN apt install -y \
  fonts-noto \
  fonts-ipafont \
  fonts-ipaexfont \
  fonts-vlgothic \
  fonts-takao \
  fonts-hanazono \
  fonts-horai-umefont \
  fonts-komatuna \
  fonts-konatu \
  fonts-migmix \
  fonts-motoya-l-cedar \
  fonts-motoya-l-maruberi \
  fonts-mplus \
  fonts-sawarabi-gothic \
  fonts-sawarabi-mincho \
  fonts-umeplus \
  fonts-dejima-mincho \
  fonts-misaki \
  fonts-mona \
  fonts-monapo \
  fonts-oradano-mincho-gsrr \
  fonts-kiloji \
  fonts-mikachan \
  fonts-seto \
  fonts-yozvox-yozfont \
  fonts-aoyagi-kouzan-t \
  fonts-aoyagi-soseki \
  fonts-kouzan-mouhitsu
#   ttf-mscorefonts-installer

# Install Python 3.10 and required packages
RUN apt-get update && apt-get install -y \
    python3.10 \
    python3.10-distutils \
    python3-pip

# Upgrade pip to the latest version
RUN python3.10 -m pip install --upgrade pip

# Instal java
RUN apt-get update && apt-get install -y \
    openjdk-11-jdk \
    openssh-server curl \
    zip tar \
    postgresql-client sudo \
    iputils-ping \
    rsync \
    nginx

ENV JAVA_HOME=/usr/lib/jvm/java-11.0.15-openjdk
ENV PATH="$JAVA_HOME/bin:${PATH}"

# Basic test
RUN java -version; \
    javac -version; \
    node -v; \
    npm -v; \
    yarn -v; \
    psql -V;

WORKDIR /root/qa

# # Install sbt
RUN curl -L -o /root/sbt.zip https://github.com/sbt/sbt/releases/download/v1.5.7/sbt-1.5.7.zip \
 	&& unzip /root/sbt.zip -d /root \
 	&& rm /root/sbt.zip

# # Put tools like aws and sbt in the PATH
ENV PATH /root/.local/bin:/root/sbt/bin:/root/bin:${PATH}

# sbt build
RUN sbt sbtVersion

# The scala server will run on port 9000 by default
EXPOSE 9000

# nginx port
EXPOSE 8080 

# Install mocha for API testing
RUN npm install -g mocha

########################### TEST-8 #############################
# Install bats (needed for do-exclusively script)
RUN git clone https://github.com/sstephenson/bats.git \
	&& (cd bats && ./install.sh /usr/local) \
	&& rm -rf bats

# Install python version

# Install AWS CLI
# RUN curl -O https://bootstrap.pypa.io/get-pip.py \
# 	&& python3 get-pip.py --user \
# 	&& pip3 install awscli --upgrade --user \
# 	&& rm get-pip.py
RUN pip install awscli --upgrade --user

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

# Init yarn dependencies
RUN mkdir -p /home/qa
COPY ./package.json /home/qa
RUN yarn install

# === BAKE BROWSERS INTO IMAGE ===

# 1. Add tip-of-tree Playwright package to install its browsers.
#    The package should be built beforehand from tip-of-tree Playwright.
COPY ./scala/build/packages/playwright-1.47.2.tar.gz /tmp/playwright.tar.gz
RUN su root -c "mkdir /tmp/qa && cd /tmp/qa && npm init -y && \
    npm i /tmp/playwright.tar.gz" && \
    rm -rf /tmp/qa && rm /tmp/playwright.tar.gz

# 2. Ensure the Playwright cache exists
RUN mkdir -p /root/.cache/ms-playwright && \
    mkdir -p /home/qa/.cache/ms-playwright

# 3. Sync the Playwright cache
RUN rsync -av --exclude=/root/.cache/ms-playwright/* /root/.cache/ms-playwright/ /home/qa/.cache/ms-playwright || true

# Add user so we don't need --no-sandbox.
RUN groupadd -r qa && useradd -r -g qa -G audio,video qa \
    && mkdir -p /home/qa/Downloads /app \
    && chown -R qa:qa /home/qa \
    && chown -R qa:qa /home/qa/.cache \
    && chown -R qa:qa /app

# Run everything after as non-privileged user.
RUN adduser qa sudo
RUN echo '%sudo ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers
USER qa
WORKDIR /home/qa

ENV JAVA_HOME=/usr/lib/jvm/java-11.0.15-openjdk
ENV PATH="$JAVA_HOME/bin:${PATH}"

# Install sbt user qa
RUN curl -L -o /home/qa/sbt.zip https://github.com/sbt/sbt/releases/download/v1.5.7/sbt-1.5.7.zip \
	&& unzip /home/qa/sbt.zip -d /home/qa \
	&& rm /home/qa/sbt.zip

# Put tools like aws and sbt in the PATH
ENV PATH /home/qa/.local/bin:/home/qa/sbt/bin:/home/qa/bin:${PATH}
RUN sudo ln -s /home/qa/sbt/bin/sbt /usr/local/bin/sbt

# aws-cli
# RUN sudo curl -O https://bootstrap.pypa.io/get-pip.py \
# 	&& python3 get-pip.py --user \
# 	&& pip3 install awscli --upgrade --user \
# 	&& sudo rm get-pip.py
RUN pip install awscli --upgrade --user
RUN sudo ln -s /home/qa/.local/bin/aws /usr/local/bin/aws

########################### TEST-8 #############################

# sbt build
RUN whoami
RUN env
RUN pwd;ls -all
RUN sbt sbtVersion
RUN yarn --version
RUN python3 --version
RUN aws --version
RUN sudo aws --version
RUN ls -all /home/qa
RUN cat /home/qa/package.json
RUN sudo chmod 4755 /bin/ping