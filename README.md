Alinex web server
=================================================

[![Build Status] (https://travis-ci.org/alinex/node-server.svg?branch=master)](https://travis-ci.org/alinex/node-server)
[![Coverage Status] (https://coveralls.io/repos/alinex/node-server/badge.png?branch=master)](https://coveralls.io/r/alinex/node-server?branch=master)
[![Dependency Status] (https://gemnasium.com/alinex/node-server.png)](https://gemnasium.com/alinex/node-server)

The alinex server is a simple container for express applications. The express
framework integrates perfectly and can be fully used. Also subapplications can
be done easy the express way.

- full configurable
- supports also ssl
- single server cluster support
- easy api

It is one of the modules of the [Alinex Universe](http://alinex.github.io/node-alinex)
following the code standards defined there.


Install
-------------------------------------------------

The easiest way is to let npm add the module directly:

    > npm install alinex-server express --save

[![NPM](https://nodei.co/npm/alinex-server.png?downloads=true&stars=true)](https://nodei.co/npm/alinex-server/)


Usage
-------------------------------------------------

The usage is very simple, you have to load the server modules first:

    var Server = require('alinex-server');
    var express = require('express');

Because it depends on express.js you may define your app in the standard manner
adding routes...

    var app = express();
    app.get('/', function (req, res) {
      // do something
      res.send('...the rsponse body...');
    });
    app.use(...);

You can also use subapps if you want:

    var rest = express();
    rest.get('/', function (req, res) {
        // do something
    });
    app.use('/rest', rest);

That adds the defined routes under `/rest/...`.

Now you may instantiate a server with the root app. The configuration is done
using [alinex-config](http://alinex.github.io/node-config)
module. Therefore you may specify the config name to use on start or `server`
is used.

    server = new Server('rest-server', app);

Now the server may be started and stopped on demand:

    server.start();
    server.stop();

Both methods also supports events and callbacks if needed. The setup will remain.

### SSL server

The use as ssl server is as easy as a normal webserver. All you need to do is set
it to ssl with the corresponding port and certificates in the configuration file.


API
-------------------------------------------------

### Events

The following events are supported:

- `error` - then something fails
- `init` - after initialization is done
- `start` - then the server has started
- `stop` - then the server has stopped

### Properties

- `config` (object) - configuration data
- `configClass` (Config) - if an alinex-config instance is given or the config loaded
- `init` (boolean) - flag set to true if server is fully initialized
- `app` (Express) - application runing as main
- `server` (Server) - node network server instance

### Methods

- `start` - start the web server
- `stop` - stop the webserver


Configuration
-------------------------------------------------

This is possible with a `server.yml` or `given-name.yml` (also in other formats)
like described under [alinex-cionfig](http://alinex.github.io/node-config).

For more information to the concrete values see the example config file.


License
-------------------------------------------------

Copyright 2014 Alexander Schilling

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

>  <http://www.apache.org/licenses/LICENSE-2.0>

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
