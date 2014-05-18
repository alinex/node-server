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
cluster = require 'cluster'
yaml = require 'js-yaml'
debug = require('debug')('server:startup')
errorHandler = require 'alinex-error'
# include server modules
express = require("express")

# Root directory of the core application
GLOBAL.ROOT_DIR = path.dirname __dirname

# Read configuration
# -------------------------------------------------
# put into config class
#config = yaml.safeLoad fs.readFileSync '/home/ixti/example.yml', 'utf8'
# read src and local config
fs.readFile 'config.yml', 'utf8', (err, data) ->
  throw err if err
  config = yaml.safeLoad data
# merge configs

# Initialize server
# -------------------------------------------------
app = express()
app.get "/", (req, res) ->
  res.send "hello world"
  return

app.listen 3000

console.log 'done'
