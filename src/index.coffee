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
cluster = require 'cluster'
config = require './config'
# include server modules
express = require 'express'

# Root directory of the core application
GLOBAL.ROOT_DIR = path.dirname __dirname


# Initialize server
# -------------------------------------------------
config.load (config) ->
  app = express()
  app.get "/", (req, res) ->
    res.send "hello world"

  server = app.listen 3000, ->
    console.log "Listening on port #{server.address().port}"
