chai = require 'chai'
expect = chai.expect

server = require '../../src/index'

describe "http", ->

  describe "test", ->

    it "should run", (cb) ->
      @timeout 300000
      server.init (err) ->
        return cb err if err
        server.add 'http', (err) ->
          return cb err if err
          server.http.start cb
