# Startup Http Server
# =================================================
# This file is used to start the real http server.
#
# To configure the system use the `config/server/http` file.

# Node Modules
# -------------------------------------------------

# include base modules
debug = require('debug')('server:http:control')
EventEmitter = require('events').EventEmitter
chalk = require 'chalk'
util = require 'util'
hapi = require 'hapi'
# alinex modules
config = require 'alinex-config'
async = require 'alinex-async'
{object, string} = require 'alinex-util'

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
  init: (cb) =>
    debug "setup server connections and plugins"
    @conf = config.get '/server/http'
    # configure server
    options = {}
    options.debug = false
    for key, value of @conf.listener
      if value.load?
        options.load =
          sampleInterval: 1000
        break
    @server = new hapi.Server options
    # setup connections to use
    for label, listen of @conf.listener
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
    # register plugins (defined below)
    async.each plugins, (setup, cb) =>
      @server.register setup, cb
    # message after start/stop
    @server.on 'start', ->
      console.log chalk.bold "Server started!"
    @server.on 'stop', ->
      console.log chalk.bold "Server stopped!"
    , cb

  # ### add route
  # add routes directly
  route: (setup, cb = -> ) =>
    # resolve space settings
    setup = resolveSpace setup
    # remove bindings from setup
    bind = setup.bind
    delete setup.bind
    # set route
    setup.vhost = bind.domain if bind.domain?
    path = setup.path
    bind.context ?= ['']
    for cpath in bind.context
      setup.path = "#{bind.context}#{path ? '/'}"
      debug "adding route \"#{setup.config.description ? setup.path} \""
      debug chalk.grey "listener: #{util.inspect(bind.listener ? 'ALL')}"
      debug chalk.grey util.inspect setup, {depth: null}
      if bind.listener?
        # add to specific server
        for listen in bind.listener
          server = @server.select listen
          if server.connections.length
            server.route setup
          else
            debug chalk.magenta "No connections for listener '#{listen}' to add route
            \"#{setup.config.description ? setup.path}\""
      else
        @server.route setup
    cb()

  # ### add plugin
  plugin: (setup, cb = -> ) =>
    debug "add plugin #{setup}"
    # resolve space settings
    setup = resolveSpace setup
    @server.register setup, cb

  # Server Start and Stop
  # -------------------------------------------------

  # ### start
  start: (cb) ->
    debug "start hapi server V#{@server.version}"
    @server.root.start cb

  # ### stop
  stop: (cb) ->
    debug "stop hapi server"
    @server.root.stop()
    cb()

module.exports = http = new HttpServer()

# Plugin configurations
# -------------------------------------------------
# The following plugins will be loaded automatically. The implementation is in
# the extra files.
plugins = [
#  register: require '../http/plugin/log'
#  options: ....
  require '../http/plugin/debug'
  require '../http/plugin/log'
  require 'inert'
]

# Resolve space bindings
# -------------------------------------------------
resolveSpace = (setup) ->
  conf = config.get '/server/http'
  resolve =
    listener: []
    domain: []
    context: []
  if setup.bind?
    bind = setup.bind
    # prefer array notation everythere
    for att in ['space', 'listener', 'domain', 'context']
      bind[att] = [bind[att]] if typeof bind[att] is 'string'
      bind[att] ?= []
    # space
    if bind.space.length
      for spacename in bind.space
        space = conf.space?[spacename]?.bind
        if space?
          resolve.listener = space.listener if space.listener?
          resolve.domain = space.domain if space.domain?
          resolve.context = space.context if space.context?
    # listener
    if bind.listener.length
      if resolve.listener.length
        # only use listeners which are in both space and listener setting
        resolve.listener = bind.listener.filter (e) -> e in resolve.listener
      else
        resolve.listener = bind.listener
    # domain
    if bind.domain.length
      if resolve.domain.length
        # only use domains which are in both space and domain setting
        resolve.domain = bind.domain.filter (e) -> e in resolve.domain
      else
        resolve.domain = bind.domain
    # context
    if bind.context.length
      if resolve.context.length
        # combine together while space context is higher
        combined = []
        for a in resolve.context
          for b in bind.context
            combined.push "#{a}/#{b}".replace /\/\/+/, '/'
        resolve.context = combined
      else
        resolve.context = bind.context
  # cleanup
  delete resolve.space
  for att in ['listener', 'domain', 'context']
    delete resolve[att] unless resolve[att].length
  setup.bind = resolve
  return setup

