chai = require 'chai'
expect = chai.expect
request = require 'request'
async = require 'alinex-async'

server = require '../../src/index'
config = require 'alinex-config'
os = require 'os'

# host      *           localhost
# port      23174       23175
# protocol  http        https
# listener  default     ssl

# listener  default
# domain                localhost
# context                           /test
# space     s1          s2          s3

# bind    path          uri                             code body
#
# -       /hello        http://localhost:23174/hello    200  hello world
#                       https://localhost:23175/hello   200  hello world
# -       /500          http://localhost:23174/500      500
#                       https://localhost:23175/500     500
# -       /log          http://localhost:23174/log      200  done
#
# default /default      http://localhost:23174/default  200  default
#                       http://localhost:23174/default  404
# ssl     /ssl          https://localhost:23175/ssl     200  ssl
#                       http://localhost:23174/ssl 404
#
# s1      /s1           http://localhost:23174/s1       200  s1
#                       http://127.0.0.1:23174/s1       200  s1
#                       https://localhost:23175/s1      404
# s2      /s2           http://localhost:23174/s2       200  s2
#                       https://localhost:23175/s2      200  s2
#                       http://127.0.0.1:23174/s2       404
# s3      /s3           http://localhost:23174/test/s3  200  s3
#                       http://127.0.0.1:23174/test/s3  200  s3
#                       http://localhost:23174/s3       404

test = (uris, code, reply, cb) ->
  uris = [uris] if typeof uris is 'string'
  async.each uris, (uri, cb) ->
    request
      method: 'GET'
      uri: uri
      rejectUnauthorized: false
    , (err, response, body) ->
      expect(err, "server error (#{uri})").to.not.exist
      expect(response.statusCode, "status code (#{uri})").to.equal code
      expect(body, "reply (#{uri})").to.equal reply if reply
      cb()
  , cb

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
          req.log 'error', 'TEST'
          reply 'done'

      server.http.route
        bind:
          listener: 'default'
        method: 'GET'
        path: '/default'
        config:
          description: 'Default listener test'
        handler: (req, reply) -> reply 'default'
      server.http.route
        bind:
          listener: 'ssl'
        method: 'GET'
        path: '/ssl'
        config:
          description: 'SSL listener test'
        handler: (req, reply) -> reply 'ssl'

      server.http.route
        bind:
          space: 's1'
        method: 'GET'
        path: '/s1'
        config:
          description: 's1 space test'
        handler: (req, reply) -> reply 's1'
      server.http.route
        bind:
          space: 's2'
        method: 'GET'
        path: '/s2'
        config:
          description: 's2 space test'
        handler: (req, reply) -> reply 's2'
      server.http.route
        bind:
          space: 's3'
        method: 'GET'
        path: '/s3'
        config:
          description: 's3 space test'
        handler: (req, reply) -> reply 's3'

      cb()

  describe "start", ->

    it "should start", (cb) ->
      @timeout 5000
      server.http.start cb

  describe "simple access", ->
    @timeout 5000

    it "should get hello world message", (cb) ->
      test [
        'http://localhost:23174/hello'
        'https://localhost:23175/hello'
      ], 200, 'hello world', cb

    it "should get automatic 404 error", (cb) ->
      test [
        'http://localhost:23174/bye'
        'https://localhost:23175/bye'
      ], 404, null, cb

    it "should get custom 500 error", (cb) ->
      @timeout 15000
      test [
        'http://localhost:23174/500'
        'https://localhost:23175/500'
      ], 500, null, cb

    it "should make log entry", (cb) ->
      test [
        'http://localhost:23174/log'
      ], 200, 'done', cb

  describe "routes bind to listener", ->

    it "should succeed on default", (cb) ->
      test [
        'http://localhost:23174/default'
      ], 200, 'default', cb
    it "should fail on default", (cb) ->
      test [
        'https://localhost:23175/default'
      ], 404, null, cb

    it "should succeed on ssl", (cb) ->
      test [
        'https://localhost:23175/ssl'
      ], 200, 'ssl', cb
    it "should fail on ssl", (cb) ->
      test [
        'http://localhost:23174/ssl'
      ], 404, null, cb

  describe "routes bind to space", ->

    it "should succeed on s1", (cb) ->
      test [
        'http://localhost:23174/s1'
        'http://127.0.0.1:23174/s1'
      ], 200, 's1', cb
    it "should fail on s1", (cb) ->
      test [
        'https://localhost:23175/s1'
      ], 404, null, cb

    it "should succeed on s2", (cb) ->
      test [
        'http://localhost:23174/s2'
        'https://localhost:23175/s2'
      ], 200, 's2', cb
    it "should fail on s2", (cb) ->
      test [
        'http://127.0.0.1:23174/s2'
      ], 404, null, cb

    it "should succeed on s3", (cb) ->
      test [
        'http://localhost:23174/test/s3'
        'http://127.0.0.1:23174/test/s3'
      ], 200, 's3', cb
    it "should fail on s3", (cb) ->
      test [
        'http://localhost:23174/s3'
      ], 404, null, cb

# s1      /s1           http://localhost:23174/s1       200  s1
#                       http://127.0.0.1:23174/s1       200  s1
#                       https://localhost:23175/s1      404
# s2      /s2           http://localhost:23174/s2       200  s2
#                       https://localhost:23175/s2      200  s2
#                       http://127.0.0.1:23174/s2       404
# s3      /s3           http://localhost:23174/test/s3  200  s3
#                       http://127.0.0.1:23174/test/s3  200  s3
#                       http://localhost:23174/s3       404
