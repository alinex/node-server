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
      server = app.listen 3000
      request
        url: 'http://localhost:3000/'
      , (err, response, body) =>
        expect(err).to.not.exist
        expect(body).to.equal 'hello world'
        server.close()
        done()

  describe.only "default server", ->

    server = null

    it "should start server", (done) ->
      app = express()
      app.get '/hello', (req, res) ->
        res.send 'hello world'
      server = new Server 'http', app
      server.start (err) ->
        expect(err, 'error').to.not.exist
        done()

    it "should deliver default homepage", (done) ->
      request
        url: 'http://localhost:3080/'
      , (err, response, body) =>
        expect(err, 'error').to.not.exist
        expect(body, 'body').to.equal 'Alinex Server running!'
        done()

    it "should deliver page from app", (done) ->
      request
        url: 'http://localhost:3080/hello'
      , (err, response, body) =>
        expect(err, 'error').to.not.exist
        expect(body, 'body').to.equal 'hello world'
        done()

    it "should give file not found error", (done) ->
      request
        url: 'http://localhost:3080/notfound'
      , (err, response, body) =>
        expect(err, 'error').to.not.exist
        expect(response.statusCode, 'status code').to.equal 404
        expect(body, 'body').to.equal 'Resource not found!'
        done()

    it "should stop server", (done) ->
      server.stop (err) ->
        expect(err, 'error on stop').to.not.exist
        request
          url: 'http://localhost:3080/'
        , (err, response, body) =>
          expect(err, 'error on acess').to.exist
          expect(err.code, 'error code on access').to.equal 'ECONNREFUSED'
          done()

  describe "secure server", ->

