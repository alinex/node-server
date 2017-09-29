# Alinex Server

[![GitHub watchers](
  https://img.shields.io/github/watchers/alinex/node-server.svg?style=social&label=Watch&maxAge=86400)](
  https://github.com/alinex/node-server/subscription)
[![GitHub stars](
  https://img.shields.io/github/stars/alinex/node-server.svg?style=social&label=Star&maxAge=86400)](
  https://github.com/alinex/node-server)
[![GitHub forks](
  https://img.shields.io/github/forks/alinex/node-server.svg?style=social&label=Fork&maxAge=86400)](
  https://github.com/alinex/node-server)

[![npm package](
  https://img.shields.io/npm/v/alinex-server.svg?maxAge=86400&label=latest%20version)](
  https://www.npmjs.com/package/alinex-server)
[![latest version](
  https://img.shields.io/npm/l/alinex-server.svg?maxAge=86400)](
  #license)
[![Codacy Badge](
  https://api.codacy.com/project/badge/Grade/d1c36b200a8b47ffb31a1eabd2522d9e)](
  https://www.codacy.com/app/alinex/node-server/dashboard)
[![Travis status](
  https://img.shields.io/travis/alinex/node-server.svg?maxAge=86400&label=develop)](
  https://travis-ci.org/alinex/node-server)
[![Coverage Status](
  https://img.shields.io/coveralls/alinex/node-server.svg?maxAge=86400)](
  https://coveralls.io/r/alinex/node-server)
[![Gemnasium status](
  https://img.shields.io/gemnasium/alinex/node-server.svg?maxAge=86400)](
  https://gemnasium.com/alinex/node-server)
[![GitHub issues](
  https://img.shields.io/github/issues/alinex/node-server.svg?maxAge=86400)](
  https://github.com/alinex/node-server/issues)


## Installation


## Usage



## Development

For easy and fast handling use yarn:

``` bash
# Clone from github
$ git clone https://github.com/alinex/node-server
# Install the modules
$ npm install
```

Now you may run the development version with hot reloading or in the production
version:

``` bash
# Use rest development server
$ npm run test   # run the test suite
$ npm run dev    # run with hot reload

# create and start production server
$ npm run build
$ npm run start
```


## Configuration

The server may be configured using the environment setting. First step is to use
`NODE_ENV=production` (which is done on `npm run start`) changes the whole setting:
- protocol will be HTTPS
- logging will be set to Apache combined format

But you may also set the following entries separately through environment settings:
- `PROTOCOL` - should be `http` or `https`
- `HOST` - hostname on which to listen to, use '0.0.0.0' for all IPs
- `PORT` - port to listen on (defaults to 1974)


## License

(C) Copyright 2016-2017 Alexander Schilling

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

>  <https://www.apache.org/licenses/LICENSE-2.0>

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
