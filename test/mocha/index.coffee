chai = require 'chai'
expect = chai.expect
path = require 'path'

server = require '../../src/index'
config = require 'alinex-config'

before ->
  server.setup ->
    config.pushOrigin
      uri: 'test/data/config/*'
      path: 'server'

describe "server", ->

  describe "config", ->

    it "should run the selfcheck on the schema", (cb) ->
      @timeout 8000
      validator = require 'alinex-validator'
      schema = require '../../src/configSchema'
      validator.selfcheck schema, cb

    it "should load configuration", (cb) ->
      @timeout 15000
      server.init (err) ->
        expect(err, 'init error').to.not.exist
        expect(config.get '/server').to.exist
        cb()
