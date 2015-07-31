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
cluster = require 'cluster'
express = require 'express'
# alinex modules
config = require 'alinex-config'

# Define singleton instance
# -------------------------------------------------
module.exports = http = new EventEmitter()

# Data container
# -------------------------------------------------

conf = config.get '/server/http'

app = express()
.disable 'x-powered-by'

srv = null

app.get '/', (req, res) -> res.send 'Hello World!'

# Server Start and Stop
# -------------------------------------------------

http.start = (cb) ->
  debug "start server"
  srv = app.listen 3000, ->
    address = @address()
    console.log "HTTP Server listening on #{address.address}:#{address.port}"

http.end = (cb) ->

http.status = (cb) ->


