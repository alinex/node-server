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
debug = require('debug')('server:express')
chalk = require 'chalk'
EventEmitter = require('events').EventEmitter
cluster = require 'cluster'
express = require 'express'
httpServer = require 'http'
# alinex modules
config = require 'alinex-config'
async = require 'alinex-async'

# Define singleton instance
# -------------------------------------------------
module.exports = http = new EventEmitter()

# Data container
# -------------------------------------------------

conf = config.get '/server/http'

server = null

app = express()
.disable 'x-powered-by'

app.get '/', (req, res) -> res.send 'Hello World!'

# Initialization
# -------------------------------------------------

http.init = (cb) -> cb()

# Server Start and Stop
# -------------------------------------------------

http.start = (cb) ->
  debug "start server"
  server = httpServer.createServer app
  server.on 'error', (err) ->
    console.log err
    if err.code is 'EACCES' and err.syscall is 'listen'
      for e in conf.listen
        if e.port < 1024
          throw new Error "Could not listen on port #{e.port} because of privileges"
    debug chalk.red "error: #{err.message}"
  # create listen entries
  async.parallel conf.listen.map (e) ->
    if e.host?
      (cb) -> server.listen.call server, e.port, e.host, (err) ->
        return cb err if err
        console.log "Server listening on http://#{e.host}:#{e.port}"
        cb()
    else
      (cb) -> server.listen.call server, e.port, (err) ->
        console.log "Server listening on http://localhost:#{e.port}"
        return cb err if err
        os = require 'os'
        for int in os.networkInterfaces()
          for addr in int
            unless addr.internal
              console.log "Server listening on http://#{adr.address}:#{e.port}"
        cb()
  , cb

http.end = (cb) ->
  debug "stop server"
  server.close()
  cb()

http.status = (cb) ->


