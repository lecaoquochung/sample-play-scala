# sample play scala

# Cucumber
- Generate json report
```
yarn cucumber -f json:report/report.json --publish
yarn cucumber --tags="@friday" -f json:report/friday.json
yarn cucumber --tags="@puppeteer" -f json:report/puppeteer.json
```
- Share report
```
yarn cucumber -f json:report/report.json --publish  
```

# Puppeteer
https://github.com/buildkite/docker-puppeteer
https://github.com/mlampedx/cucumber-puppeteer-example