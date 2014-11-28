chai = require 'chai'
expect = chai.expect
path = require 'path'
express = require('express');
request = require 'request'

# Root directory of the core application
GLOBAL.ROOT_DIR = path.dirname path.dirname __dirname

error = require 'alinex-error'
error.install()
Config = require 'alinex-config'
Config.search = [ 'test/data/config' ]

Server = require '../../lib/index'
check = require '../../lib/check'
validator = require 'alinex-validator'

describe "Webserver", ->

  describe "configuration", ->

    it "should has correct validator rules", ->
      validator.selfcheck 'check.server', check

  describe "express", ->

    it "should work with normal express", (done) ->
      @timeout 10000
      app = express()
      app.get '/', (req, res) ->
        res.send 'hello world'
      app.listen 3000
      request
        url: 'http://localhost:3000/'
      , (err, response, body) =>
        expect(err).to.not.exist
        expect(body).to.equal 'hello world'
        done()

  describe "simple server", ->

    it "should deliver page", (done) ->
      app = express()
      app.get '/', (req, res) ->
        res.send 'hello world'
      server = new Server 'test-server', app
      server.start (err) ->
        expect(err).to.not.exist
        request
          url: 'http://localhost:3080/'
        , (err, response, body) =>
          expect(err).to.not.exist
          expect(body).to.equal 'hello world'
          server.stop (err) ->
            expect(err).to.not.exist
            done()

