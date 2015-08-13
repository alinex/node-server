# Startup Http Server
# =================================================
# This file is used to start the real http server.
#
# To configure the system use the `config/server/http` file.

# Node Modules
# -------------------------------------------------

# include base modules
debug = require('debug')('server:http')
debugAccess = require('debug')('server:http:access')
debugHeader = require('debug')('server:http:header')
debugPayload = require('debug')('server:http:payload')
EventEmitter = require('events').EventEmitter
chalk = require 'chalk'
util = require 'util'
hapi = require 'hapi'
# alinex modules
config = require 'alinex-config'
async = require 'alinex-async'
{object} = require 'alinex-util'

# helper for debug output formatting
obj2str = (o) -> util.inspect(o).replace /\s+/g, ' '

# Define singleton instance
# -------------------------------------------------
class HttpServer extends EventEmitter

  # Data container
  # -------------------------------------------------
  @conf: null # configuration
  @server: null # server

  # ### initialize
  # setup connections, debugging and base plugins
  init: (cb) ->
    debug "setup server connections and plugins"
    @conf = config.get '/server/http'
    # configure server
    options = {}
    options.debug = false unless process.env.DEBUG?
    for key, value of @conf.listen
      if value.load?
        options.load =
          sampleInterval: 1000
        break
    @server = new hapi.Server options
    setup.events.call this
    # setup connections to use
    setup.connections.call this
    # register plugins (defined below)
    async.each plugins, (setup, cb) =>
      @server.register setup, cb
    , (err) =>
      return cb err if err

      # test routing
      @server.route
        method: 'GET',
        path: '/hello',
        handler: (req, reply) ->
          throw new Error "Poopsie"
          reply 'hello world'

      cb()

  # Server Start and Stop
  # -------------------------------------------------

  # ### start
  start: (cb) ->
    debug "start hapi server V#{@server.version}"
    @server.root.start()
#    cb()

  # ### stop
  stop: (cb) ->
    @server.root.stop()
    cb()

module.exports = http = new HttpServer()

# Server setup functions
# -------------------------------------------------
# They are called within the init() method and do some specific steps.

setup =
  # ### Events for debugging
  # Event handling for debug and output
  events: ->
    @server.on 'log', -> debug chalk.grey 'Unhandled LOG event'#, arguments
    @server.on 'request', -> debug chalk.grey 'Unhandled REQUEST event'#, arguments
    @server.on 'request-internal', -> debug chalk.grey 'Unhandled INTERNAL event'#, arguments
    @server.on 'request-error', (request, err) ->
      keys = ['domainThrown', 'isBoom', 'isServer', 'isDeveloperError', 'data']
      debug chalk.red "#{err.message} #{obj2str object.filter err, (v, k) -> v? and k in keys}"
    @server.on 'tail', -> debug chalk.grey 'Unhandled TAIL event'#, arguments
    @server.on 'start', =>
      debug "hapi server started"
      for srv in @server.connections
        console.log "Server listening on #{srv.info.uri}"
    @server.on 'stop', ->
      debug "hapi server stopped"
    if debugAccess.enabled or debugHeader.enabled or debugPayload.enabled
      @server.on 'response', (data) ->
        raw = data.raw.req
        url = "#{data.connection.info.protocol}://#{raw.headers.host}#{raw.url}"
        if debugAccess.enabled
          client = chalk.grey "#{data.info.remoteAddress} "
          access = "-> #{data.method.toUpperCase()} #{url} "
          code = data.response.statusCode
          color = switch
            when code < 200 then 'white'
            when code < 300 then 'green'
            when code < 400 then 'cyan'
            when code < 500 then 'yellow'
            else 'red'
          time = data.info.responded - data.info.received
          time = switch
            when time < 50 then chalk.green "#{time}ms"
            when time < 200 then chalk.yellow "#{time}ms"
            when time < 1000 then chalk.orange "#{time}ms"
            else chalk.red "#{Math.round time/1000}s"
          response = "-> #{chalk[color] code} #{time}"
          debugAccess client + access + response
        if debugHeader.enabled
          debugHeader chalk.grey "request #{obj2str data.headers}"
          debugHeader chalk.grey "response #{obj2str data.response.headers}"
        if debugPayload.enabled
          if data.payload
            debugPayload chalk.grey "request #{obj2str data.payload}"
          debugPayload chalk.grey "response #{obj2str data.response.source}"

  # ### Add Connections
  connections: ->
    for label, listen of @conf.listen
      options =
        labels: [label]
        host: listen.host
        port: listen.port
        tls: listen.tls
      if listen.load?
        options.load =
          maxHeapUsedBytes: listen.load.maxHeap
          maxRssBytes: listen.load.maxRss
          maxEventLoopDelay: listen.load.eventLoopDelay
      @server.connection options

# Plugin configurations
# -------------------------------------------------
# The following plugins will be loaded automatically. The implementation is in
# the extra files.
plugins = [
  register: require "../http/plugin/log"
]
