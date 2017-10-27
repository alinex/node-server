// @flow
import promisify from 'es6-promisify' // may be removed with node util.promisify later
import fs from 'fs'
import os from 'os'
import path from 'path'
import Debug from 'debug'
import Hapi from 'hapi'
import Good from 'good'
import chalk from 'chalk'

import DebugPlugin from './plugin/debug'

const debug = Debug('server')

type Listener = {
  labels?: string,
  host?: string,
  port?: number,
  tls?: {
    key: string,
    cert: string,
  },
}

class Server {
  hapi: Hapi.server

  constructor() {
    this.hapi = new Hapi.Server()
  }

  // configuration

  init(): Promise<Hapi.Server> {
    return this.hapi.register({
      register: Good,
      options: {
        reporters: {
          console: [{
            module: 'good-squeeze',
            name: 'Squeeze',
            args: [{
              response: '*',
              log: '*',
            }],
          }, {
            module: 'good-console',
          }, 'stdout'],
        },
      },
    })
  }

  listen(config: Listener): Server {
    if (!config.labels) config.labels = 'root' // use default
    this.hapi.connection(config)
    return this
  }

  add(config: Object): Server {
    const labels = config.labels || 'root'
    this.hapi.select(labels).register({
      register: config.plugin,
      options: config.options,
    }, {
      routes: {
        vhost: config.vhost,
        prefix: config.prefix,
      },
    })
    return this
  }

  // use the server

  start(): Promise<void> {
    debug('Starting server...')
    let p = this.hapi.start()
    if (debug.enabled) {
      // print routing table
      p = p.then(() => {
        const table = this.hapi.table()
        table.forEach((conn) => {
          debug(chalk.bold(`Server is listening under ${chalk.yellow(conn.info.uri)}`))
          conn.table.forEach((route) => {
            let msg = `${route.method.toUpperCase()}\t${chalk.yellow.bold(route.path)}`
            if (route.settings.description) msg += `\t(${route.settings.description})`
            debug(msg)
          })
        })
      })
    }
    return p
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
