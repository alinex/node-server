import * as chai from "chai"
import chaiHttp = require("chai-http")
import * as Debug from "debug"
import * as Hapi from "hapi"
import "mocha"

import Server from "../../src/Server"
import { IPlugin, IRoute } from "../../src/setup"
// import Server from "../wrapper/TServer"

chai.use(chaiHttp)
const expect = chai.expect
const debug = Debug("test")

const testRoute: IRoute = {
  method: "GET",
  path: "/",
  handler: (_, reply) => {
    reply("Hello from TEST!")
  },
  description: "welcome for testing",
}

const testPlugin: IPlugin = {
  plugin: (app: Hapi.Server, _: any, next: () => void) => {
    app.route({
      vhost: testRoute.vhost,
      method: testRoute.method,
      path: testRoute.path,
      handler: testRoute.handler,
      config: {
        description: testRoute.description,
      },
    })
    next()
  },
}
testPlugin.plugin.attributes = { name: "test" }

describe("plugin", () => {

  it("should add simple plugin", () => {
    const server = new Server()
    server.listen()
    server.plugin(testPlugin)
    return server.start()
    .then(() => chai
      .request(server.info()!.uri).get("/")
      .then((res) => {
        debug(`Returned: ${res.status} - ${res.text}`)
        expect(res.status).to.equal(200)
        expect(res.text).to.equal("Hello from TEST!")
      })
      .catch((err) => {
        debug(`Error: ${err.message}`)
        throw err
      }),
    )
    .then(() => server.stop())
  })

})
