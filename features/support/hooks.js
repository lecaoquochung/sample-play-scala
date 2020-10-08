const { BeforeAll, Before, After, AfterAll } = require('@cucumber/cucumber');
// var {setDefaultTimeout} = require('cucumber');
// setDefaultTimeout(600 * 1000);

// lib
const moment = require('moment');
const puppeteer = require('puppeteer');

// constant
const currentUnixTime = moment().valueOf();

BeforeAll(async function() {
  // Write code here that turns the phrase above into concrete actions
  // return 'pending';
});

Before(
  {tags: "@friday or @puppeteer"},
  async function() {
//    this.currentUnixTime = await currentUnixTime;
//    this.browser = await puppeteer.launch();
//    this.context = await this.browser.createIncognitoBrowserContext();
//    this.page = await this.context.newPage({context: currentUnixTime})
//    this.page = parseInt(constant.debugMode === 1) ? await this.browser.newPage({context: currentUnixTime}) : await this.context.newPage({context: currentUnixTime});
//    await this.page.authenticate({username: constant.basicAuthUser, password: constant.basicAuthPassword});
//    await this.page.setViewport({width: constant.defaultWidth, height: constant.defaultHeight});
  }
);

After(
  {tags: "@friday or puppeteer"},
  async function() {
//    await this.page.close();
//    if (this.browser !== null && this.browser.isConnected() === true) await this.browser.close();
  }
);