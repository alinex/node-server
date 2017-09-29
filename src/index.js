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
  }

  listen(port: number, host: string): Server {
    this.server.connection({ port, host })
    this.server.route({
      method: 'GET',
      path: '/',
      handler: (request, reply) => {
        reply('Hello, world!')
      },
    })
    return this
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
