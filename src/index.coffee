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

# Root directory of the core application
GLOBAL.ROOT_DIR = path.dirname __dirname


# Initialize server
# -------------------------------------------------
config = new Config 'server', ->
  app = express()
  app.get "/", (req, res) ->
    res.send "hello world"

  if config.http?.port?
    server = app.listen config.http.port, ->
      console.log "Listening on port #{server.address().port}"
