// @flow
import promisify from 'es6-promisify' // may be removed with node util.promisify later
import fs from 'fs'
import os from 'os'
import path from 'path'
import Debug from 'debug'
import Hapi from 'hapi'

const debug = Debug('server')

class Server {
  server: Hapi.server

  constructor() {
    this.server = new Hapi.Server()
    this.server.connection({ port: 3000, host: 'localhost' })
  }

  start(): Promise<void> {
    return this.server.start()
  }

  stop(): Promise<void> { // eslint-disable-line
    debug('Stopping server...')
    return Promise.resolve()
  }
}

export default Server
