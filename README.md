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
