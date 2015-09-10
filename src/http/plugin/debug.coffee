# Logging plugin
# =================================================
# To add logging capabilities using the winston logger.

# Node Modules
# -------------------------------------------------

# include base modules
debug = require('debug')('server:http')
debugAccess = require('debug')('server:http:access')
debugHeader = require('debug')('server:http:header')
debugPayload = require('debug')('server:http:payload')
chalk = require 'chalk'
util = require 'util'
# alinex modules
config = require 'alinex-config'
async = require 'alinex-async'
{string, object} = require 'alinex-util'


obj2str = (o) -> util.inspect(o).replace /\s+/g, ' '

# Plugin Interface
# -------------------------------------------------

exports.register = (server, options, cb) ->
  conf = config.get '/server/http'
  heapdump = require 'heapdump' if conf.heapdump
  # unused events
  server.on 'log', (data) ->
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

  server.on 'request', -> debug chalk.grey 'Unhandled REQUEST event'#, arguments
  server.on 'request-internal', -> debug chalk.grey 'Unhandled INTERNAL event'#, arguments
  server.on 'tail', -> debug chalk.grey 'Unhandled TAIL event'#, arguments

  # debug requests errors
  server.on 'request-error', (request, err) ->
    msg = err.stack.split /\n/
    debug "#{chalk.red msg[0]}\n#{chalk.grey msg[1..].join '\n'}"
    if heapdump? and string.starts err.message, 'Uncaught error:'
      heapdump.writeSnapshot "#{__dirname}/../../../var/log/#{Date.now()}.heapsnapshot"

  # display routing table after start
  server.on 'start', ->
    debug "hapi server started"
    printRouting server

  # short message after stop
  server.on 'stop', ->
    debug "hapi server stopped"

  # debug requests with payload and response
  if debugAccess.enabled or debugHeader.enabled or debugPayload.enabled
    server.on 'response', (data) ->
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
  cb()

exports.register.attributes =
  name: 'debug'
  version: '1.0.0'

# ### printout routing
printRouting = (server, cb = -> ) ->
  # collect routing data
  # routes = uri:{app}
  # listen = name:base
  routes = {}
  listener = {}
  for conn in server.table()
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
  conf = config.get '/server/http'
  if conf.space
    for name, space of conf.space
      spaces[name] = []
      for listen in space.bind.listener ? Object.keys listener
        conn = server.select listen
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
  table = [chalk.underline "Routing table:"]
  for name, base of listener
    table.push "  #{chalk.bold.cyan string.rpad base, 41}
    #{chalk.magenta name + ' listener'}"
    for uri, route of uris[base]
      table.push "    #{chalk.green string.rpad route.method, 8}
      #{string.rpad route.path, 30}
      #{if route.auth then chalk.green route.auth else chalk.red 'public'}
      #{chalk.yellow route.description}"    #   - with apps
  # spaces
  for name, list of spaces
    list.sort()
    for base in list
      table.push "  #{chalk.bold.cyan string.rpad base, 41}
      #{chalk.magenta name + ' space'}"
      for uri, route of uris[base]
        table.push "    #{chalk.green string.rpad route.method, 8}
        #{string.rpad route.path, 30}
        #{if route.auth then chalk.green route.auth else chalk.red 'public'}
        #{chalk.yellow route.description}"    #   - with apps
  debug table.join '\n'
  cb()
