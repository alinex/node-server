Alinex web server
=================================================

[![Build Status](https://travis-ci.org/alinex/node-server.svg?branch=master)](https://travis-ci.org/alinex/node-server)
[![Coverage Status](https://coveralls.io/repos/alinex/node-server/badge.png?branch=master)](https://coveralls.io/r/alinex/node-server?branch=master)
[![Dependency Status](https://gemnasium.com/alinex/node-server.png)](https://gemnasium.com/alinex/node-server)

The alinex server is a simple container for express applications. The express
framework integrates perfectly and can be fully used. Also subapplications can
be done easy the express way.

- full configurable
- supports also SSL and multiple IPs
- full debug and logging support

> It is one of the modules of the [Alinex Universe](http://alinex.github.io/code.html)
> following the code standards defined in the [General Docs](http://alinex.github.io/node-alinex).


Install
-------------------------------------------------

[![NPM](https://nodei.co/npm/alinex-server.png?downloads=true&downloadRank=true&stars=true)
 ![Downloads](https://nodei.co/npm-dl/alinex-server.png?months=9&height=3)
](https://www.npmjs.com/package/alinex-server)

The easiest way is to let npm add the module directly to your modules
(from within you node modules directory):

``` sh
npm install alinex-server --save
```

And update it to the latest version later:

``` sh
npm update alinex-server --save
```

Always have a look at the latest [changes](Changelog.md).


Usage
-------------------------------------------------

The usage is very simple, you have to load the server module first:

``` coffee
server = require 'alinex-server'
```

After that in your code you have to initialize the server:

``` coffee
server.init (err) ->
  return cb err if err
  server.http.start ->
    # server is running
```

> Inclusion of your own routes are not supported, yet.

Configuration
-------------------------------------------------
The main configuration is done using the [Config](http://alinex.github.io/node-config)
module so that the end user may easily configure the server without changing the
code.

See the files for `server/http' configuration to get a list of all possibilities.


Server start
-------------------------------------------------

The server will response after a short time with it's routing table on the console.
You are now able to access the server.


API
-------------------------------------------------



License
-------------------------------------------------

Copyright 2015 Alexander Schilling

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

>  <http://www.apache.org/licenses/LICENSE-2.0>

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
