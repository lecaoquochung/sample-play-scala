const assert = require('assert');
const { Given, When, Then } = require('cucumber');

Given('Puppeteer is config', async function () {
//   Write code here that turns the phrase above into concrete actions
//   return 'pending';
 });
When('I open Google homepage', async function () {
//   Write code here that turns the phrase above into concrete actions
//  return 'pending';
//    browser = await puppeteer.launch({
//        headless: true,
//        executablePath: '/usr/bin/chromium-browser',
//        args:['--no-sandbox']
//    });
    page = await this.browser.newPage();
    await this.page.goto('https://google.co.jp');

//    await this.page.goto('https://google.co.jp');
});
Then('I can see Google homepage', async function () {
// Write code here that turns the phrase above into concrete actions
// return 'pending';
    await this.page.screenshot({path: 'report/screenshot/open-google-homepage.png',fullPage: true})
});