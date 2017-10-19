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
import IListener from "./IListener"
import IPlugin from "./IPlugin"

const debug = Debug("server")

class Server {
  private hapi: Hapi.Server

  constructor(config?: IListener) {
    this.hapi = new Hapi.Server()
    if (config) {
      this.listen(config)
    }
  }

  // configuration

  public listen(config: IListener): Server {
    if (!config.labels) {
      config.labels = "root" // use default
    }
    if (!config.port) {
      config.port = parseInt(process.env.PORT || "80", 10)
    }
    this.hapi.connection(config)
    return this
  }

  public plugin(config: IPlugin): Server {
    const labels = config.labels || "root"
    this.hapi.select(labels).register({
      register: config.plugin,
      options: config.options,
    }, {
//      select: labels,
//      routes: {
//        vhost: config.vhost,
//        prefix: config.prefix,
//      },
    })
    return this
  }

  // use the server

  public start(): Promise<Error|null> {
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
