// @flow
import promisify from 'es6-promisify' // may be removed with node util.promisify later
import fs from 'fs'
import os from 'os'
import path from 'path'
import Debug from 'debug'

const debug = Debug('server')

class Server {
//  constructor() {
//  }

  start(): Promise<void> { // eslint-disable-line
    debug('Starting server...')
    return Promise.resolve()
  }

  stop(): Promise<void> { // eslint-disable-line
    debug('Stopping server...')
    return Promise.resolve()
  }
}

export default Server
