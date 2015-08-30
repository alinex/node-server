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
    options.debug = false unless process.env.DEBUG?
    for key, value of @conf.listener
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
    , cb

  # ### add route
  # add routes directly
  route: (setup, cb = -> ) =>
    listener = false
    if bind = setup.bind?
      # context
      setup.path = bind.context + '/' + (setup.path ? '') if bind.context?
      # space
      if bind.space?
        space = @conf.space[bind.space]?.bind
        if space?
          listener = space.listener if space.listener?
          setup.vhost = space.domain if space.domain?
          setup.path = space.context + '/' + (setup.path ? '') if space.context
      # listener
      if bind.listener?
        if listener?
          # only use domains which are in both space and domain setting
          listener = [listener] if typeof listener is 'string'
          bind.listener = [bind.listener] if typeof bind.listener is 'string'
          listener = bind.listener.filter (e) -> e in listener
        else
          listener = bind.listener
      # domain
      if bind.domain?
        if setup.vhost?
          # only use domains which are in both space and domain setting
          setup.vhost = [setup.vhost] if typeof setup.vhost is 'string'
          bind.domain = [bind.domain] if typeof bind.domain is 'string'
          setup.vhost = bind.domain.filter (e) -> e in setup.vhost
        else
          setup.vhost = bind.domain
      # optimize path
      setup.path = setup.path.replace /\/\/+/, '/'
    # set route
    if listener?
      # add to specific server
      @server.select(listen).route setup for listen in listener
    else
      @server.route setup
    cb()

  # ### add plugin
  plugin: (setup, cb = -> ) =>
    @server.register setup, cb

  # Server Start and Stop
  # -------------------------------------------------

  # ### start
  start: (cb) ->
    debug "start hapi server V#{@server.version}"
    @server.root.start()
    @server.once 'start', cb

  # ### stop
  stop: (cb) ->
    @server.root.stop()
    cb()


  # ### printout routing
  printRouting: (cb = -> ) ->
    console.log chalk.bold "Server started:"
    # collect routing data
    # routes = uri:{app}
    # listen = name:base
    routes = {}
    listener = {}
    for conn in @server.table()
      listener[conn.labels[0]] = conn.info.uri
      for route in conn.table
        base = if route.settings.vhost
          "#{conn.info.protocol}://#{route.settings.vhost}:#{conn.info.port}"
        else
          conn.info.uri
        routes[base + route.path] =
          method: route.method.toUpperCase()
          host: base
          path: route.path.replace /({.*?})/g, chalk.gray '$1'
          auth: if route.settings.auth then route.settings.auth.strategies.toString() else false
          description: route.settings.description ? ''
    # spaces = name:[base]
    spaces = {}
    for name, space of @conf.space
      spaces[name] = []
      for listen in space.bind.listener ? Object.keys listener
        conn = @server.select listen
        if space.domain?
          for domain in space.bind.domain
            base = "#{conn.info.protocol}://#{route.settings.vhost}:#{conn.info.port}"
            spaces[name].push base + context for context in space.bind.context ? ['']
        else
          spaces[name].push conn.info.uri + context for context in space.bind.context ? ['']
    # uris = base:[route]
    uris = {}
    for uri, app of routes
      # search in spaces
      found = false
      for name, checks of spaces
        break if found
        for check in checks
          if string.starts uri, check
            uris[check] ?= []
            uris[check].push app
            found = true
            break
      unless found
        for name, check of listener
          if string.starts uri, check
            uris[check] ?= []
            uris[check].push app
            break
    # sort routing
    for name of uris
      uris[name].sort (a, b) -> a.path.localeCompare b.path
    # write routing table listeners
    for name, base of listener
      console.log "  #{chalk.bold.cyan string.rpad base, 41}
      #{chalk.magenta name + ' listener'}"
      for uri, route of uris[base]
        console.log "    #{chalk.green string.rpad route.method, 8}
        #{string.rpad route.path, 30}
        #{if route.auth then chalk.green route.auth else chalk.red 'public'}
        #{chalk.yellow route.description}"    #   - with apps
    # spaces
    for name, list of spaces
      list.sort()
      for base in list
        console.log "  #{chalk.bold.cyan string.rpad base, 41}
        #{chalk.magenta name + ' space'}"
        for uri, route of uris[base]
          console.log "    #{chalk.green string.rpad route.method, 8}
          #{string.rpad route.path, 30}
          #{if route.auth then chalk.green route.auth else chalk.red 'public'}
          #{chalk.yellow route.description}"    #   - with apps
    cb()

module.exports = http = new HttpServer()


# Server setup functions
# -------------------------------------------------
# They are called within the init() method and do some specific steps.

setup =
  # ### Events for debugging
  # Event handling for debug and output
  events: ->
    # unused events
    @server.on 'log', (data) ->
      color = switch data.tags[0]
        when 'error' then 'red'
        when 'warn' then 'magenta'
        else 'gray'
      debug chalk[color] "#{data.tags[0].toUpperCase()}: #{data.data}"
    @server.on 'request', -> debug chalk.grey 'Unhandled REQUEST event'#, arguments
    @server.on 'request-internal', -> debug chalk.grey 'Unhandled INTERNAL event'#, arguments
    @server.on 'tail', -> debug chalk.grey 'Unhandled TAIL event'#, arguments
    # debug requests errors
    @server.on 'request-error', (request, err) ->
      keys = ['domainThrown', 'isBoom', 'isServer', 'isDeveloperError', 'data']
      debug chalk.red "#{err.message} #{obj2str object.filter err, (v, k) -> v? and k in keys}"
    # display routing table after start
    @server.on 'start', =>
      debug "hapi server started"
      @printRouting()
    # short message after stop
    @server.on 'stop', ->
      debug "hapi server stopped"
    # debug requests with payload and response
    if debugAccess.enabled or debugHeader.enabled or debugPayload.enabled
      @server.on 'response', (data) ->
        raw = data.raw.req
        url = "#{data.connection.info.protocol}://#{raw.headers.host}#{raw.url}"
        if debugAccess.enabled
          client = chalk.grey "#{raw['x-forwarded-for'] ? data.info.remoteAddress} "
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

# Plugin configurations
# -------------------------------------------------
# The following plugins will be loaded automatically. The implementation is in
# the extra files.
plugins = [
  register: require "../http/plugin/log"
]

