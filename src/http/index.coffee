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
    # resolve space settings
    console.log '--->', setup
    setup = resolveSpace setup
    console.log '<---', setup
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
    @server.register setup, cb

  # Server Start and Stop
  # -------------------------------------------------

  # ### start
  start: (cb) ->
    debug "start hapi server V#{@server.version}"
    @server.root.start cb

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
    slist = Object.keys(spaces).sort (a, b) ->
      return 1 unless spaces[b][0]?
      spaces[b][0].length - spaces[a][0].length
    # uris = base:[route]
    uris = {}
    for uri, app of routes
      # search in spaces
      found = false
      for name in slist
        break if found
        for check in spaces[name]
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
      level = 'info'
      color = 'gray'
      switch
        when 'error' in data.tags
          color = 'red'
          level = 'error'
        when 'warn' in data.tags
          color = 'magenta'
          level = 'warn'
      msg = "#{level.toUpperCase()}:"
      if data.data instanceof Error
        msg += " #{data.data.message}"
        msg += " (#{data.data.code})" if data.data.code
      else
        msg += " #{data.data}"
      debug chalk[color] msg
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
            when time < 1000 then chalk.magenta "#{time}ms"
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
#  register: require '../http/plugin/log'
#  options: ....
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

