// @flow
import promisify from 'es6-promisify' // may be removed with node util.promisify later
import fs from 'fs'
import os from 'os'
import path from 'path'
import Debug from 'debug'
import Hapi from 'hapi'

const debug = Debug('server')

type Listener = {
  host?: string,
  port?: number,
  tls?: {
    key: string,
    cert: string,
  },
}
type Config = {
  listen: Listener,
}

class Server {
  hapi: Hapi.server

  constructor() {
    this.hapi = new Hapi.Server()
  }

  // configuration

  config(config: Config): Hapi.Server {
    const app = this.listen(config.listen)
    return app
  }

  listen(config: Listener): Hapi.Server {
    return this.hapi.connection(config)
  }

  // use the server

  start(): Promise<void> {
    debug('Starting server...')
    return this.hapi.start()
      .then(() => {
        debug('Server is running')
      })
  }

  stop(): Promise<void> { // eslint-disable-line
    debug('Stopping server...')
    return this.hapi.stop()
      .then(() => {
        debug('Server is stopped')
      })
  }
}

export default Server
