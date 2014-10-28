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
debug = require('debug')('server')
cluster = require 'cluster'
EventEmitter = require('events').EventEmitter
# alinex modules
errorHandler = require 'alinex-error'
Config = require 'alinex-config'
# internal helpers
check = require './check'
# include server modules
express = require 'express'

# Server class
# -------------------------------------------------
class Server extends EventEmitter

  # ### Create instance
  # This will only store the reference to the configuration object. This may be
  # an [alinex-config](http://alinex.github.io/node-config) object or a normal
  # object.
  constructor: (@name = 'server') ->
    debug "create server #{@name}"
    @config = Config.instance name
    @config.setCheck check.server
    @config.load()

  # ### Start the server
  start: (cb) ->
    @config.load (err, config) =>
      return @emit 'error', err if err
      # support callback through event wrapper
      if cb
        @on 'error', (err) ->
          debug "Error: #{err}"
          cb err
          cb = ->
        @on 'start', =>
          config = @config.data
          debug "listening on http://localhost:#{config.http.port}"
          cb()
          cb = ->
      #
      debug "start server #{@name}"
      @app = express()
      if config.
        @app.enable 'trust proxy'
      #    !!! TEST CODE
#      @app.use express.vhost 'hostname1.com', require('/path/to/hostname1').app
      @app.use '/public', express.static 'public'
      @app.get "/", (req, res) ->
        res.send "Alinex Server is working!"
      @app.use (req, res, next) ->
        res.send 404, 'Sorry cant find that!'
      @app.use (err, req, res, next) ->
        console.error err
        res.send 500, 'Something broke!'
      #    !!! TEST END

      if config.http?.port?
        @server = @app.listen config.http.port, (err) =>
          if err
            @emit 'error', err
          else
            @emit 'start'

  # ### Start the server
  stop: (cb) ->
    # support callback through event wrapper
    if cb
      @on 'error', (err) ->
        debug "Error: #{err}"
        cb err
        cb = ->
      @on 'stop', ->
        debug "server stopped"
        cb()
        cb = ->
    # stop server
    @server.close (err) =>
      if err
        @emit 'error', err
      else
        @emit 'stop'

module.exports = Server
