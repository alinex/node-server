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

  it("should listen to default", async () => {
    const server = new Server()
    server.listen()
    server.route(testRoute)
    await server.start()
    try {
      const res = await chai.request(server.info()!.uri).get("/")
      debug(`Returned: ${res.status} - ${res.text}`)
      expect(res.status).to.equal(200)
      expect(res.text).to.equal("Hello from TEST!")
      await server.stop()
    } catch (err) {
      await server.stop()
      throw err
    }
  })

  it("should listen to specific port", async () => {
    const server = new Server()
    server.listen({ host: "localhost", port: 3000 })
    server.route(testRoute)
    await server.start()
    try {
      const res = await chai.request(server.info()!.uri).get("/")
      debug(`Returned: ${res.status} - ${res.text}`)
      expect(res.status).to.equal(200)
      expect(res.text).to.equal("Hello from TEST!")
      await server.stop()
    } catch (err) {
      await server.stop()
      throw err
    }
  })

})
