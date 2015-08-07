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
# alinex modules
config = require 'alinex-config'
async = require 'alinex-async'

loger = null

# Plugin Interface
# -------------------------------------------------

exports.register = (server, options, next) ->
  # get configuration
  conf = config.get '/server/http/log'
  debug '-----', conf
  # loop over loggers
  # add winston config
  # loop over servers
  # break if logger not possible for server
  # bind logger to log function
  # setup winston
  return next()

# filter entries

  date = new Date().toISOString().substring 0, 10
  logger = new winston.Logger
    transports: [
      new winston.transports.Console()
    ]
  logger = new winston.Logger
    transports: [
      new winston.transports.Console()
    ,
      new winston.transports.File
        filename: options.path + '/' + date + '.log'
        colorize: options.colorize
        timestamp: -> new Date()
        level: options.level
        json: options.json
    ]
  debug options.path + '/' + date + '.log'
  logger.error 'Ups'
  #logger.add winston.transports.Console
  #  level: options.level
  #  colorize: true
#    ]
#    exceptionHandlers: [
#      new winston.transports.File
#        colorize: options.colorize
#        timestamp: -> new Date()
#        filename: options.path + '/exceptions.log.json'
#        json: options.json
#    ]
  console.log server.pack
  pack = server.servers[0].pack
  pack.events.on('log', onLog)
  pack.events.on('internalError', internalError)
  plugin.ext('onPreResponse', onPreResponse)
  debug "initialized"
  next()
#,
#  before: 'dictionary-api'

exports.register.attributes =
  name: 'log'
  version: '1.0.0'
  multiple: true

# Helper methods
# -------------------------------------------------

onLog = (event, tags) ->
  mess = if event.data.error
    '[' + event.tags.join() + '] - \n{\n\t' +
    'source : '+event.data.source+'\n\t' +
    'code : '+event.data.code+'\n\t' +
    'message : '+event.data.message+'\n\t' +
    'stackTrace : '+event.data.stack+'\n}'
  else
    '[' + event.tags.join(',') + '] - ' + event.data
  # log type
  switch
    when tags.fatal
      logger.error mess
      process.exit(1)
    when tags.error then logger.error mess
    when tags.info then logger.info mess
    when tags.warn then logger.warn mess
    when tags.debug then logger.debug mess
    when tags.trace then logger.trace mess

onPreResponse = (request, reply) ->
  response = request.response
  if not response.isBoom and response.variety is 'plain' and not response.source instanceof Array
    # Sanitize database fields
    payload = response.source
    if payload._id
      payload.id = payload._id
      delete payload._id
    for i in payload
      delete payload[i] if payload.hasOwnProperty i and i[0] is '_'
  reply()

internalError = (request, err) ->
  logger.error "Error response (500) sent for request: " +
    request.id + ' because: ' + err.message+ ' - '+err.stack
