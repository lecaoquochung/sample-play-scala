![](https://img.shields.io/docker/cloud/build/lecaoquochung/scala) ![](https://img.shields.io/circleci/build/github/lecaoquochung/sample-play-scala)

# Get started
```
./help.sh up
```

# Cucumber
- Generate json report
```
yarn cucumber -f json:report/report.json --publish
yarn cucumber --tags="@friday" -f json:report/friday.json
```

# Puppeteer
```
yarn cucumber --tags="@puppeteer" -f json:report/puppeteer.json
```

# Robotframework
```
python3 robotframework/login/server.py
pip3 install -r requirements.txt
robot robotframework/login_tests
```

# Reference
https://hub.docker.com/repository/docker/lecaoquochung/scala/builds
