# Startup Alinex Server
# =================================================
# This file is used to start the whole system. It will start as single server
# or cluster server depending on the `NODE_ENV` setting.
#
# For productive system the server starts as cluster to use the power of
# multi core architectures. It is not aimed for multi server cluster, this have
# to be set up on top.
#
# To configure the system use the `config/server.coffee` file.

# Node Modules
# -------------------------------------------------

# include base modules
fs = require 'fs'
path = require 'path'
debug = require('debug')('server:startup')
errorHandler = require 'alinex-error'
Config = require 'alinex-config'
cluster = require 'cluster'
EventEmitter = require('events').EventEmitter
# include server modules
express = require 'express'

# Server class
# -------------------------------------------------
class Server extends EventEmitter
  # ### Check the server configuration
  # This method is meant to be used as check in [alinex-config](http://alinex.github.io/node-config)
  @configCheck = (name, config, cb) ->
    console.log '!!! configCheck not implemented !!!'
    cb()

  # ### Create instance
  # This will only store the reference to the configuration object. This may be
  # an [alinex-config](http://alinex.github.io/node-config) object or a normal 
  # object.
  constructor: (@config) ->
    unless config
      throw new Error "Could not initialize server without configuration."

  # ### Start the server
  start: (cb) ->
    # support callback through event wrapper
    if cb
      @on 'error', (err) ->
        cb err
        cb = ->
      @on 'start', ->
        cb()
        cb = ->
    # 
    @app = express()
    #    !!! TEST CODE
    @app.get "/", (req, res) ->
      res.send "hello world"
    #    !!! TEST END
    if config.http?.port?
      @server = app.listen config.http.port, (err) ->
        if err
          @emit 'error', err
        else
          @emit 'start'

  # ### Start the server
  stop: (cb) ->
    # support callback through event wrapper
    if cb
      @on 'error', (err) ->
        cb err
        cb = ->
      @on 'stopp', ->
        cb()
        cb = ->


module.exports = Config
