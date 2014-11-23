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
debug = require('debug')('server')
EventEmitter = require('events').EventEmitter
# alinex modules
Config = require 'alinex-config'
# internal helpers
check = require './check'

# Server class
# -------------------------------------------------
class Server extends EventEmitter

  # ### Create instance
  # This will only store the reference to the configuration object. This may be
  # an [alinex-config](http://alinex.github.io/node-config), a name for the
  # configuration to load or the configuration structure itself.
  constructor: (@config = 'server') ->
    debug "create new server instance"
    if typeof @config is 'string'
      # load
      @config = Config.instance @config
      @config.setCheck check.server
    if @config instanceof Config
      @configClass = @config
      @config = @config.data
      @name = @configClass.name
      # start loading
      @configClass.load()

  # ### Start the server
  start: (cb, loaded = false) ->
    # wait till configuration is loaded
    if @configClass? and not loaded
      return @configClass.load (err) =>
        @start cb, true unless err
        @emit 'error', err
        cb err if cb
    # support callback through event wrapper
    if cb
      @on 'error', (err) ->
        debug "Error: #{err}"
        cb err
        cb = ->
      @on 'start', =>
        config = @config.data
        debug "listening on http://localhost:#{@config.port}"
        cb()
        cb = ->
      # start the server
      debug "start server #{@name}", @config
      if @config.port
        @server = @app.listen @config.port, (err) =>
          if err
            if e.code is 'EADDRINUSE'
              console.log chalk.bold.red 'Failed to bind to port - address already in use '
              process.exit(1);
            else
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
