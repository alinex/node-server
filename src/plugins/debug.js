// @flow

const Stream = require('stream')

class DebugPlugin {
  write(data: any) { // eslint-disable-line
    console.log(data) // eslint-disable-line
  }
}

module.exports = DebugPlugin
