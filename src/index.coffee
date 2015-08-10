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
fspath = require 'path'
# alinex modules
config = require 'alinex-config'
async = require 'alinex-async'
fs = require 'alinex-fs'

# Data container
# -------------------------------------------------
types = [] # list of possible server types
conf = null # configuration

# Define singleton instance
# -------------------------------------------------
module.exports = server =

  # Initialization
  # -------------------------------------------------

  # set the modules config paths and validation schema
  setup: (cb) -> #async.once (cb) ->
    # set module search path
    config.register false, fspath.dirname __dirname
    # add schema for module's configuration
    config.setSchema '/server', require('./configSchema'), cb

  # set the modules config paths, validation schema and initialize the configuration
  init: async.once (cb) ->
    debug "initialize server"
    async.parallel [
      # load types
      (cb) -> fs.find __dirname,
        type: 'dir'
        mindepth: 1
        maxdepth: 1
        exclude: 'doc'
      , (err, list) ->
        console.log list
        types = list?.map (e) -> fspath.basename e, fspath.extname e
        cb err
      # set module search path and init config
      (cb) -> server.setup (err) ->
        return cb err if err
        config.init cb
      # setup log directory
      (cb) -> fs.mkdir __dirname + '/../log', (err) ->
        return cb err if err and not err.code is 'EEXIST'
        cb()
    ], (err) ->
      return cb err if err
      # initialize individual servers
      conf = config.get 'server'
      async.each types, (type, cb) ->
        return cb() if server[type]? or not conf[type]?
        debug "initialize #{type} server part"
        server.http = require "./#{type}/index"
        server.http.init cb
      , cb
