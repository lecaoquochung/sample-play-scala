// const { setWorldConstructor } = require("cucumber");
const { setWorldConstructor } = require("@cucumber/cucumber");

class QA {
  constructor() {
    this.browser;
    this.context;
    this.currentUnixTime;
    this.page;
  }

  setTo(number) {
    this.variable = number;
  }

  incrementBy(number) {
    this.variable += number;
  }

  setTimestamp(timestamp) {
    this.currentUnixTime = timestamp;
  }
}

setWorldConstructor(QA);