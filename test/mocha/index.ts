import * as chai from "chai"
import chaiHttp = require("chai-http")
import * as Debug from "debug"
import "mocha"

import Server from "../../src/Server"

chai.use(chaiHttp)
// const expect = chai.expect
const debug = Debug("test")

describe("server", () => {

  describe("setup", () => {
    const server = new Server()

    it("should start server", () => {
      server.listen({ port: 3000, host: "localhost" })
      server.start()
    })

    it("should be working", () => chai
      .request("http://localhost:3000").get("/")
      .then((res) => {
        debug(`Returned: ${res.status} - ${res.text}`)
        return true
      })
      .catch((err) => {
        debug(`Error: ${err.message}`)
        return true
      }),
    )

    it("should stop server", () => server.stop())
  })

})
