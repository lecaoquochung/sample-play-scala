var path = require('path');
global.__base = path.resolve(__dirname) + '/';

module.exports = {
  default: `--publish-quiet --format-options '{"snippetInterface": "synchronous"}'`
}

//┌──────────────────────────────────────────────────────────────────────────┐
//│ Share your Cucumber Report with your team at https://reports.cucumber.io │
//│                                                                          │
//│ Command line option:    --publish                                        │
//│ Environment variable:   CUCUMBER_PUBLISH_ENABLED=true                    │
//│                                                                          │
//│ More information at https://reports.cucumber.io/docs/cucumber-js         │
//│                                                                          │
//│ To disable this message, add this to your ./cucumber.js:                 │
//│ module.exports = { default: '--publish-quiet' }                          │
//└──────────────────────────────────────────────────────────────────────────┘