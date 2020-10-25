# Return immediately with an error code if any of the following commands fail
set -ex

# Install the dependencies for testing with Node
yarn install

# Start the scala server in the background
# screen -d -m -S api /root/sbt/bin/sbt -Dconfig.file=conf/application.conf -Dplay.evolutions.db.default.autoApply=true "run 80"
# curl --retry 60 --retry-connrefused --retry-max-time 60 --retry-delay 1 http://127.0.0.1
screen -d -m -S api sudo -E sbt \
     -Dconfig.file=conf/application.conf \
     -Dplay.evolutions.db.default.autoApply=true \
     "run 80"

# Wait for the server to start up
curl --retry 60 \
     --retry-connrefused \
     --retry-max-time 120 \
     --retry-delay 1 \
     http://127.0.0.1

# Wait for the server to start up
curl --retry 60 \
     --retry-connrefused \
     --retry-max-time 120 \
     --retry-delay 1 \
     http://api.test

# API server health check
# curl --retry 60 \
     # --retry-connrefused \
     # --retry-max-time 60 \
     # --retry-delay 1 \
     # http://api.test/api/health

# Run tests
# cd /home/qa/; ./help.sh cli test cucumber local tag "@api"

# Kill the background server
#screen -S api -X quit