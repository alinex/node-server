// @flow
import chalk from "chalk"
import * as Debug from "debug"
import * as Hapi from "hapi"
// import promisify from "es6-promisify" // may be removed with node util.promisify later
// import fs from "fs"
// import Good from "good"
// import os from "os"
// import path from "path"

// import DebugPlugin from "./plugin/debug"
import { IConfig, IListener, IRoute } from "./setup"
// import IPlugin from "./IPlugin"

const debug = Debug("server")

class Server {
  protected hapi: Hapi.Server

  private pluginLoader: Array<Promise<void>> = []

  constructor(config?: IConfig) {
    this.hapi = new Hapi.Server()
    if (config) {
      if (config.listen) {
        const listener = Array.isArray(config.listen) ? config.listen : [config.listen]
        for (const listen of listener) {
          this.listen(listen)
        }
      }
    }
  }

  // configuration

  public listen(config: IListener = {}): Server {
    if (!config.label) {
      config.label = "root" // use default
    }
    if (!config.port) {
      config.port = parseInt(process.env.PORT || "1974", 10)
    }
    this.hapi.connection({
      labels: config.label,
      host: config.host,
      port: config.port,
      tls: config.tls,
    })
    return this
  }

  public route(config: IRoute): Server {
    this.hapi.route({
      vhost: config.vhost,
      method: config.method,
      path: config.path,
      handler: config.handler,
      config: {
        description: config.description,
      },
    })
    return this
  }

//  public plugin(config: IPlugin): Server {
//    const labels = config.labels || "root"
//    this.hapi.select(labels).register({
//      register: config.plugin,
//      options: config.options,
//    }, {
//      select: labels,
//      routes: {
//        vhost: config.vhost,
//        prefix: config.prefix,
//      },
//    })
//    return this
//  }

  // use the server

  public info(): Hapi.ServerConnectionInfo | null {
    return this.hapi.info
  }

  public async start(): Promise<Error|null> {
    await Promise.all(this.pluginLoader)
    debug("Starting server...")
    let p = this.hapi.start()
    // print routing table
    if (debug.enabled) {
      p = p.then(() => {
        this.hapi.table().forEach((conn) => {
          debug(chalk.bold(`Server is listening under ${chalk.yellow(conn.info.uri)}`))
          conn.table.forEach((route) => {
            let msg = `${route.method.toUpperCase()}\t${chalk.yellow.bold(route.path)}`
            if (route.settings.description) {
              msg += `\t(${route.settings.description})`
            }
            debug(msg)
          })
        })
        return null
      })
    }
    // done
    return p
  }

  public stop(): Promise<void> {
    debug("Stopping server...")
    return this.hapi.stop()
      .then(() => {
        debug(chalk.bold("Server is stopped"))
      })
  }
}

export default Server
