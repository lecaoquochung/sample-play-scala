import { chromium } from "playwright";
import { webkit } from "playwright";
import { firefox } from "playwright";

let page: any;
let browser: any;

describe("Sandbox", () => {
  beforeAll(async () => {
    // browser = process.env.HEADLESS
    //   ? await chromium.launch()
    //   : await chromium.launch({ headless: false });

      browser = process.env.BROWSER === 'chrome' ? await chromium.launch({ headless: true }) :
                process.env.BROWSER === 'firefox' ? await firefox.launch({ headless: true }) :
                await webkit.launch({ headless: true });

    page = await browser.newPage();

    await page
      .goto("https://e2e-boilerplate.github.io/sandbox/", {
        waitUntil: "networkidle0",
      })
      // tslint:disable-next-line:no-empty
      .catch(() => {});
  });

  afterAll(() => {
    if (!page.isClosed()) {
      browser.close();
    }
  });

  test("should be on the sandbox", async () => {
    await page.waitForSelector("h1");
    const title = await page.$eval(
      "h1",
      (el: { textContent: any }) => el.textContent
    );

    expect(await page.title()).toEqual("Sandbox");
    expect(title).toEqual("Sandbox");
  });
});
