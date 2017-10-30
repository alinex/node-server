import * as chai from "chai"
import chaiHttp = require("chai-http")
import * as Debug from "debug"
import "mocha"

import Server from "../../src/Server"
// import Server from "../wrapper/TServer"

chai.use(chaiHttp)
const expect = chai.expect
const debug = Debug("test")

describe("server", () => {

  describe("simple", () => {
    const server = new Server({
      listen: { port: 3000, host: "localhost" },
    })
    server.route({
      method: "GET",
      path: "/",
      handler: (_, reply) => {
        reply("Hello from TEST!")
      },
      description: "welcome for testing",
    })

    it("should start server", () => {
      return server.start()
    })

    it("should be working", () => chai
      .request("http://localhost:3000").get("/")
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

    it("should stop server", () => server.stop())
  })

})
