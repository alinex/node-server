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
debug = require('debug')('server:http')
EventEmitter = require('events').EventEmitter
hapi = require 'hapi'
# alinex modules
config = require 'alinex-config'

# Define singleton instance
# -------------------------------------------------
class HttpServer extends EventEmitter

  # Data container
  # -------------------------------------------------
  @conf: null
  @server: null

  init: (cb) ->
    @conf = config.get '/server/http'
    @server = new hapi.Server()
    # add connections
    for label, listen of @conf.listen
      @server.connection
        labels: [label]
        host: listen.host
        port: listen.port
        tls: listen.tls

    # test routing
    @server.route
      method: 'GET',
      path: '/hello',
      handler: (req, reply) ->
        reply 'hello world'


    cb()

  # Server Start and Stop
  # -------------------------------------------------

  start: (cb) ->
    debug "start hapi server V#{@server.version}"
    @server.root.start()
    console.log "Server listening on #{srv.info.uri}" for srv in @server.connections
    console.log @server.load.rss, @server.load.heapUsed
#    cb()

  stop: (cb) ->
    @server.root.stop()
    cb()

module.exports = http = new HttpServer()

