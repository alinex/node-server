Alinex web server
=================================================

[![Build Status] (https://travis-ci.org/alinex/node-server.svg?branch=master)](https://travis-ci.org/alinex/node-server) 
[![Coverage Status] (https://coveralls.io/repos/alinex/node-server/badge.png?branch=master)](https://coveralls.io/r/alinex/node-server?branch=master)
[![Dependency Status] (https://gemnasium.com/alinex/node-server.png)](https://gemnasium.com/alinex/node-server)

This package provides a web server platform for attachable modules.


Install
-------------------------------------------------

The easiest way is to let npm add the module directly:

    > npm install alinex-server --save

[![NPM](https://nodei.co/npm/alinex-server.png?downloads=true&stars=true)](https://nodei.co/npm/alinex-server/)


Usage
-------------------------------------------------

The usage is very simple, you only have to load the server and start it:

    var server = require('alinex-server');
    server.start();

All configuration is done using a `server.yml` configuration file in... 


Configuration
-------------------------------------------------

This is possible with a `config.yml` (also in other formats) like described
under [alinex-cionfig](http://alinex.github.io/node-config).

For more information to the concrete values see the inline help in this file.


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
