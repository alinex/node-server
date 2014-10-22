chai = require 'chai'
expect = chai.expect
path = require 'path'
request = require 'request'
# Root directory of the core application
GLOBAL.ROOT_DIR = path.dirname path.dirname __dirname

error = require 'alinex-error'
error.install()
Config = require 'alinex-config'
Config.search = [ 'test/data/config' ]

Server = require '../../lib/index'

describe "Webserver", ->

  it "should deliver page", (done) ->
    @timeout 10000
    server = new Server('test-server');
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

