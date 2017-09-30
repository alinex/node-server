// @flow
import promisify from 'es6-promisify' // may be removed with node util.promisify later
import fs from 'fs'
import os from 'os'
import path from 'path'
import Debug from 'debug'
import Hapi from 'hapi'

const debug = Debug('server')

type Config = {
  port: number,
  host: string,
}

class Server {
  server: Hapi.server

  constructor() {
    this.server = new Hapi.Server()
  }

  // configuration

  config(config: Config): this {
    if (config.port) this.listen(config.port, config.host)
    return this
  }

  listen(port: number, host: string): Server {
    this.server.connection({ port, host })
    return this
  }

  // use the server

  start(): Promise<void> {
    debug('Starting server...')
    return this.server.start()
  }

  stop(): Promise<void> { // eslint-disable-line
    debug('Stopping server...')
    return this.server.stop()
  }
}

export default Server
