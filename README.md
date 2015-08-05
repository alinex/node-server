Alinex web server
=================================================

[![Build Status](https://travis-ci.org/alinex/node-server.svg?branch=master)](https://travis-ci.org/alinex/node-server)
[![Coverage Status](https://coveralls.io/repos/alinex/node-server/badge.png?branch=master)](https://coveralls.io/r/alinex/node-server?branch=master)
[![Dependency Status](https://gemnasium.com/alinex/node-server.png)](https://gemnasium.com/alinex/node-server)

The alinex server is a simple container for express applications. The express
framework integrates perfectly and can be fully used. Also subapplications can
be done easy the express way.

- full configurable
- supports also ssl
- single server cluster support
- serve static files
- multiple service interfaces

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

The usage is very simple, you have to load the server modules first:

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


Configuration
-------------------------------------------------







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
