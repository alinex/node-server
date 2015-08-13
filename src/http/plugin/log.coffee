# Logging plugin
# =================================================
# To add logging capabilities using the winston logger.

# Node Modules
# -------------------------------------------------

# include base modules
debug = require('debug')('server:http:log')
winston = require 'winston'
util = require 'util'
# alinex modules
config = require 'alinex-config'
async = require 'alinex-async'
{string} = require 'alinex-util'

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
          ['log', 'response-error']
        else
          ['response-error']
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
    logger = new winston.Logger
      transports: [
        new (if setup.file.datePattern then t.DailyRotateFile else t.File)
          level: if setup.data is 'error' then 'warn' else if 'all' then 'debug' else 'info'
          showLevel: true
          filename: "#{__dirname}/../../../log/#{setup.file.filename}"
          colorize: false
          json: false
          maxsize: setup.file.maxSize
          maxFiles: setup.file.maxFiles
          tailable: true
          zippedArchive: setup.file.compress
          datePattern: setup.file.datePattern
          formatter: formatter[setup.data]
      ]
  # return event handler which will collect the data and give them to the logger
  (data) ->
    # check context and domain filter
    raw = data.raw.req
    return unless filterContext setup, data
    # log event
    code = data.response.statusCode
    diff = data.info.responded - data.info.received
    logger.log switch
      when code < 300 then 'info'
      when code < 500 then 'warn'
      else 'error'
    ,
      # user data
      client: data.info.remoteAddress
      referrer: data.info.referrer
      session: data.session
      userAgent: data.headers['user-agent']
      # request
      requestTime: new Date data.info.received
      method: data.method.toUpperCase()
      hostname: data.info.hostname
      url: "#{data.connection.info.protocol}://#{raw.headers.host}#{raw.url}"
      query: data.query
      # response
      statusCode: data.response.statusCode
      error: data.response.source.error
      responseTime: new Date data.info.responded
      # process
      diff: diff
      duration: switch
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
    return "mydata #{data}"
  # events by priority
  event: (data) ->
    return "mydata #{data}"
  # apache custom access log
  custom: (data) ->
    return "mydata #{data}"
  # apache combined access log
  combined: (data) ->
    return "mydata #{data}"
  # apache referrer access log
  referrer: (data) ->
    return "mydata #{data}"
  # apache combined access log
  extended: (data) ->
    return "mydata #{data}"
  # apache combined access log
  all: (data) ->
    return "mydata #{data}"
