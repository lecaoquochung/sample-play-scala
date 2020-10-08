const assert = require('assert');
const { Given, When, Then } = require('cucumber');

const puppeteer = require('puppeteer');
const timeout = 20000;

Given('Puppeteer is config', async function () {
//   Write code here that turns the phrase above into concrete actions
//   return 'pending';
 });
When('I open Google homepage', async function () {
//   Write code here that turns the phrase above into concrete actions
//  return 'pending';
    browser = await puppeteer.launch({headless: true, args:['--no-sandbox']});
    page = await browser.newPage();
    await page.goto('https://google.co.jp');
});
Then('I can see Google homepage', async function () {
// Write code here that turns the phrase above into concrete actions
// return 'pending';
    await page.close();
    await browser.close();
});
