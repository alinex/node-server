# Logging plugin
# =================================================
# To add logging capabilities using the winston logger.

# Node Modules
# -------------------------------------------------

# include base modules
debug = require('debug')('server:http:log')
winston = require 'winston'
moment = require 'moment'
util = require 'util'
# alinex modules
config = require 'alinex-config'
async = require 'alinex-async'
{string, object} = require 'alinex-util'


obj2str = (o) -> util.inspect(o).replace /\s+/g, ' '

# Plugin Interface
# -------------------------------------------------

exports.register = (server, options, next) ->
  # get configuration
  conf = config.get '/server/http/log'
  # loop over servers
  for setup in conf
    events = switch setup.data
      when 'error'
        unless setup.bind?.domain? or setup.bind?.context?
          ['log', 'request-error']
        else
          ['request-error']
      when 'event'
        ['log']
      else
        ['response']
    if setup.listen?
      # add to specific server
      for event in events
        server.select(setup.listen).on event, addLogger server, setup
    else
      # add to all servers
      for event in events
        server.on event, addLogger server, setup
  # done
  server.log 'error', 'have to be logged'
  return next()

exports.register.attributes =
  name: 'log'
  version: '1.0.0'
  multiple: true

# Helper methods
# -------------------------------------------------

addLogger = (server, setup) ->
  # create logger
  if setup.file?
    t = winston.transports
    trans = new (if setup.file.datePattern then t.DailyRotateFile else t.File)
      level: if setup.data is 'error' then 'warn' else if 'all' then 'debug' else 'info'
      showLevel: true
      filename: "#{__dirname}/../../../log/#{setup.file.filename}"
      colorize: false
      json: setup.data is 'all'
      maxsize: setup.file.maxSize
      maxFiles: setup.file.maxFiles
      tailable: true
      zippedArchive: setup.file.compress
      datePattern: setup.file.datePattern
      formatter: formatter[setup.data]
    logger = new winston.Logger
      transports: [trans]
    if setup.data is 'extended'
#      trans.on 'open', ->
#        trans._stream.write """
#          #Software: Microsoft Internet Information Services 6.0
#          #Version: 1.0
#          #Date: 2002-05-02 17:42:15
#          #Fields: date time c-ip cs-username s-ip s-port cs-method cs-uri-stem
#          cs-uri-query sc-status cs(User-Agent)
#          """
      logger.error
        comment: "
          #Software: Alinex-Server
          \n#Version: 1.0
          \n#Date: #{moment().format 'YYYY-MM-DD HH:mm:ss ZZ'}
          \n#Fields: date time c-ip cs-username s-ip s-port cs-method cs-uri-stem
          cs-uri-query sc-status cs(User-Agent)
          \n"
  # return event handler which will collect the data and give them to the logger
  if setup.data is 'event' or setup.data is 'error'
    return (data, err) ->
      if data.raw?
        # request-error events
#        console.log 1, err
        code = data.response.statusCode
        level = switch
          when code < 300 then 'info'
          when code < 500 then 'warn'
          else 'error'
        data = {}
        object.clone err.output.payload if err.output.payload?
        if err
          data.error = err.message
          data.file = err.fileName
          data.line = err.lineNumber
          data.column = err.columnNumber
          data.name = err.name
          data.stack = err.stack
      else if data.tags
        # log events
#        console.log 2, data
        level = if data.tags?[0] in ['error', 'warn'] then data.tags[0] else 'info'
        data = data.data
      else
        # log
#        console.log 3, data
        level = data.level
      logger.log level, data
  (data) ->
    # check context and domain filter
    raw = data.raw.req
    return unless filterContext setup, data
    # log event
    code = data.response.statusCode
    diff = data.info.responded - data.info.received
#    console.log data
    logger.log switch
      when code < 300 then 'info'
      when code < 500 then 'warn'
      else 'error'
    ,
      client:
        ip: raw['x-forwarded-for'] ? data.info.remoteAddress
        referrer: data.info.referrer
        session: data.session
        agent: data.headers['user-agent']
        user: if data.auth.isAuthenticated then data.auth.isAuthenticated else null
      server:
        port: data.connection.info.port
        ip: data.connection.info.address
        hostname: data.info.hostname
      request:
        time: new Date data.info.received
        protocolVersion: "#{data.connection.info.protocol.toUpperCase()} #{raw.httpVersion}"
        method: data.method.toUpperCase()
        url: "#{data.connection.info.protocol}://#{raw.headers.host}#{raw.url}"
        path: raw.url
        pathname: data.path
        query: data.url.search
      response:
        code: data.response.statusCode
        error: data.response.source.error
        time: new Date data.info.responded
        size: data.response.headers['content-length']
        duration: diff
        durationString: switch
          when diff < 1000 then "#{diff}ms"
          else "#{Math.round diff/1000}s"

# ### Check bind settings
filterContext = (setup, data) ->
  return true unless setup.bind?.domain? or setup.bind?.context?
  console.log data.info.hostname, data.raw.req.url
  return false unless setup.bind?.domain is data.info.hostname
  return false unless string.starts data.raw.req.url, setup.bind?.context
  true

# ### Formatter
# Used from the winston transport to format the data according to it's name.
formatter =
  # error log
  error: (data) ->
    m = if data.message then data.message else null
    d = data.meta ? null
#    console.log '=', m, d
    "#{moment().format 'YYYY-MM-DD HH:mm:ss ZZ'} #{data.level.toUpperCase()}:
    #{m ? JSON.stringify d}"
  # events by priority
  event: (data) ->
    m = if data.message then data.message else null
    d = data.meta ? null
    "#{moment().format 'YYYY-MM-DD HH:mm:ss ZZ'} #{data.level.toUpperCase()}:
    #{m ? JSON.stringify d}"
  # apache custom access log
  common: (data) ->
    d = data.meta
    "#{d.client.ip} - #{d.client.user ? '-'}
    [#{moment(d.request.time).format 'DD/MMM/YY:HH:mm:ss ZZ'}]
    \"#{d.request.method} #{d.request.path} #{d.request.protocolVersion}\"
    #{d.response.code} #{d.response.size}"
  commonvhost: (data) ->
    d = data.meta
    "#{d.server.hostname} #{d.client.ip} - #{d.client.user ? '-'}
    [#{moment(d.request.time).format 'DD/MMM/YY:HH:mm:ss ZZ'}]
    \"#{d.request.method} #{d.request.path} #{d.request.protocolVersion}\"
    #{d.response.code} #{d.response.size}"
  # apache combined access log
  combined: (data) ->
    d = data.meta
    referrer = if d.client.referrer then "\"#{d.client.referrer}\"" else '-'
    agent = if d.client.agent then "\"#{d.client.agent}\"" else '-'
    "#{d.client.ip} - #{d.client.user ? '-'}
    [#{moment(d.request.time).format 'DD/MMM/YY:HH:mm:ss ZZ'}]
    \"#{d.request.method} #{d.request.path} #{d.request.protocolVersion}\"
    #{d.response.code} #{d.response.size}
    #{referrer} #{agent}"
  # apache referrer access log
  referrer: (data) ->
    d = data.meta
    return "#{d.client.referrer} -> #{d.request.pathname}"
  # apache combined access log
  extended: (data) ->
    d = data.meta
    return d.comment if d.comment?
    "#{moment(d.request.time).format 'YYYY-MM-DD'} #{moment(d.request.time).format 'HH:mm:ss'}
    #{d.client.ip} #{d.client.user ? '-'} #{d.server.ip} #{d.server.port}
    #{d.request.method} #{d.request.pathname} #{d.request.query ? '-'}
    #{d.response.code} #{encodeURI d.client.agent}"
  # apache combined access log
  object: (data) ->
    m = if data.message then data.message else null
    d = data.meta ? null
    m ? JSON.stringify d
