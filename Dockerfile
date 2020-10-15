# https://hub.docker.com/repository/docker/lecaoquochung/scala
# https://github.com/lecaoquochung/sample-play-scala
# scala-build
# image: lecaoquochung/scala:latest / branch build-latest
# image: lecaoquochung/scala:dev    / branch build-dev
# image: lecaoquochung/scala:stable / branch build-stable

FROM alpine:3.12

RUN apk update && apk upgrade

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

WORKDIR /root/qa

# # Install sbt
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
      
RUN apk add --no-cache \
     fonts-ipafont-gothic

# ENV CHROME_BIN="/usr/bin/chromium-browser" \
# PUPPETEER_SKIP_CHROMIUM_DOWNLOAD="true"
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
RUN yarn add puppeteer

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

# sbt build
RUN env
RUN pwd
RUN sbt sbtVersion
RUN pwd;ls -all 
RUN yarn --version
RUN cat /home/qa/package.json
RUN sudo chmod 4755 /bin/ping
RUN sudo aws --version
RUN aws --version
