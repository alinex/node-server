chai = require 'chai'
expect = chai.expect
request = require 'request'

server = require '../../src/index'
config = require 'alinex-config'
os = require 'os'

describe "http", ->


  describe "start", ->

    it "should start", (cb) ->
      @timeout 300000
      server.init (err) ->
        return cb err if err
        server.http.start cb

  describe "test routes", ->

    it "should get url", (cb) ->
      conf = config.get 'server/http/listener/default'
      request
        method: 'GET'
        uri: "#{if conf.ssl then 'https' else 'http'}://#{conf.host ? os.hostname()}:#{conf.port}/"
      , (err, response, body) ->
        expect(err, 'server error').to.not.exist
        expect(response.statusCode, 'status code').to.equal 200

