chai = require 'chai'
expect = chai.expect

# Root directory of the core application
GLOBAL.ROOT_DIR = path.dirname path.dirname __dirname

server = require '../../lib/index'

describe "Webserver", ->


  it "should add two numbers", ->
  	expect(2+2).is.equal 4
