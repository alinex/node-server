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
# include server modules
express = require 'express'

# Server class
# -------------------------------------------------
class Server extends events.EventEmitter
  # ### Check the server configuration
  # This method is meant to be used as check in [alinex-config](https://alinex.github.io/node-config)
  @configCheck = (name, config, cb) ->
    cb()

  # ### Create instance
  constructor: (@config) ->
    unless config
      throw new Error "Could not initialize server without configuration."

    if cb
      @on 'ready', cb
      @on 'error', cb
    @app = express()
    #    !!! TEST CODE
    @app.get "/", (req, res) ->
      res.send "hello world"
    #    !!! TEST END

  # ### Start the server
  start: (cb) ->
    # support callback through event wrapper
    if cb
      @on 'error', (err) ->
        cb err
        cb = ->
      @on 'started', ->
        cb()
        cb = ->
    # 
    if config.http?.port?
      @server = app.listen config.http.port, (err) ->
        if err
          @emit 'error', err
        else
          @emit 'started'

  # ### Start the server
  stop: (cb) ->
    # support callback through event wrapper
    if cb
      @on 'error', (err) ->
        cb err
        cb = ->
      @on 'stopped', ->
        cb()
        cb = ->


module.exports = Config
