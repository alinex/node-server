import * as chai from "chai"
import chaiHttp = require("chai-http")
import * as Debug from "debug"
import "mocha"

import Server from "../../src/Server"
import { IRoute } from "../../src/setup"
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

describe("listen", () => {

  it("should listen to default", () => {
    const server = new Server()
    server.listen()
    server.route(testRoute)
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

  it("should listen to specific port", () => {
    const server = new Server()
    server.listen({ host: "localhost", port: 3000 })
    server.route(testRoute)
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
