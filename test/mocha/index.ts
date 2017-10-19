import * as chai from "chai"
import chaiHttp = require("chai-http")
import * as Debug from "debug"
import "mocha"

import Server from "../wrapper/TServer"

chai.use(chaiHttp)
const expect = chai.expect
const debug = Debug("test")

describe("server", () => {

  describe("listening", () => {
    let server = new Server({ port: 3000, host: "localhost" })

    it("should start server", () => {
      return server.start()
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

    it("should add listener manually", () => {
      server = new Server()
      server.listen({ port: 3001, host: "localhost" })
      return server.start()
      .then(() => {
        expect(server.handle().info!.uri).to.equal("http://localhost:3001")
      })
      .then(() => server.stop())
    })
  })

})
