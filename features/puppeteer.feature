@puppeteer
Feature: Puppeteer
  Use Puppeteer to open web page

  Scenario Outline: Puppeteer can be used without error
    Given Puppeteer is config
    When I open Google homepage
    Then I can see Google homepage