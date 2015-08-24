chai = require 'chai'
expect = chai.expect
path = require 'path'

describe "server", ->

  server = require '../../src/index'

  describe "config", ->

    config = require 'alinex-config'

    it "should run the selfcheck on the schema", (cb) ->
      @timeout 8000
      validator = require 'alinex-validator'
      schema = require '../../src/configSchema'
      validator.selfcheck schema, cb

    it "should load configuration", (cb) ->
      @timeout 15000
      server.init (err) ->
        expect(err, 'error').to.not.exist
        expect(config.get '/server').to.exist
        cb()
