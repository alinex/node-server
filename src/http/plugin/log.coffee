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
      ]
  # return event handler
  (data) ->
    # check context and domain filter
    raw = data.raw.req
    return unless filterContext setup, data
    # collect data
    url = "#{data.connection.info.protocol}://#{raw.headers.host}#{raw.url}"
    client = "#{data.info.remoteAddress} "
    access = "-> #{data.method.toUpperCase()} #{url} "
    code = data.response.statusCode
    time = data.info.responded - data.info.received
    time = switch
      when time < 1000 then "#{time}ms"
      else "#{Math.round time/1000}s"
    response = "-> #{code} #{time}"
    level = switch
      when code < 300 then 'info'
      when code < 500 then 'warn'
      else 'error'
    console.log '----- LOG ------->', client + access + response
    logger.log level, client + access + response

# ### Check bind settings
filterContext = (setup, data) ->
  return true unless setup.bind?.domain? or setup.bind?.context?
  console.log data.info.hostname, data.raw.req.url
  return false unless setup.bind?.domain is data.info.hostname
  return false unless string.starts data.raw.req.url, setup.bind?.context
  true
