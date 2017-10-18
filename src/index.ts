// @flow
// import chalk from "chalk"
import * as Debug from "debug"
// import promisify from "es6-promisify" // may be removed with node util.promisify later
// import fs from "fs"
// import Good from "good"
import * as Hapi from "hapi"
// import os from "os"
// import path from "path"

// import DebugPlugin from "./plugin/debug"
import {IServerConfig} from "./IServerConfig"

const debug = Debug("server")

class Server {
  private hapi: Hapi.Server

  constructor() {
    this.hapi = new Hapi.Server()
  }

  // configuration

  public listen(config: IServerConfig): Server {
    if (!config.labels) {
      config.labels = "root" // use default
    }
    this.hapi.connection(config)
    return this
  }

  // use the server

  public start(): Promise<Error|null> {
    debug("Starting server...")
    const p = this.hapi.start()
//    if (debug.enabled) {
//      // print routing table
//      p = p.then(() => {
//        const table = this.hapi.table()
//        table.forEach((conn) => {
//          debug(chalk.bold(`Server is listening under ${chalk.yellow(conn.info.uri)}`))
//          conn.table.forEach((route) => {
//            let msg = `${route.method.toUpperCase()}\t${chalk.yellow.bold(route.path)}`
//            if (route.settings.description) {
//              msg += `\t(${route.settings.description})`
//            }
//            debug(msg)
//          })
//        })
//      })
//    }
    return p
  }

  public stop(): Promise<void> { // eslint-disable-line
    debug("Stopping server...")
    return this.hapi.stop()
      .then(() => {
        debug("Server is stopped")
      })
  }
}

export default Server
