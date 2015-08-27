chai = require 'chai'
expect = chai.expect
request = require 'request'

server = require '../../src/index'
config = require 'alinex-config'
os = require 'os'

describe "http", ->

  describe "setup", ->

    it "should add test routes", (cb) ->
      # add test routes
      server.http.route
        method: 'GET'
        path: '/hello'
        config:
          description: 'Hello World'
          handler: (req, reply) -> reply 'hello world'
      server.http.route
        method: 'GET'
        path: '/500'
        config:
          description: 'Test Call with 500 error'
          handler: (req, reply) -> throw new Error "Poopsie"
      server.http.route
        method: 'GET'
        path: '/log'
        config:
          description: 'Log an error message'
          handler: (req, reply) ->
            @server.log 'error', 'TEST'
            reply 'done'
      cb()

  describe "start", ->

    it "should start", (cb) ->
      @timeout 5000
      server.http.start cb

  describe "simple access", ->
    @timeout 5000

    it "should get url", (cb) ->
      conf = config.get 'server/http/listener/default'
      request
        method: 'GET'
        uri: "#{if conf.ssl then 'https' else 'http'}://#{conf.host ? os.hostname()}:#{conf.port}/hello"
      , (err, response, body) ->
        expect(err, 'server error').to.not.exist
        expect(response.statusCode, 'status code').to.equal 200
        cb()
