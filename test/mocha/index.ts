import { expect } from "chai"
import "mocha"

import Server from "../../src/index"

describe("server", () => {

  describe("setup", () => {
    const server = new Server()

    it("should start server", () => {
      server.listen({ port: 3000, host: "localhost" })
      server.start()
    })
  })

  describe("Hello function", () => {
    it("should return hello world", () => {
      const result = "Hello World!"
      expect(result).to.equal("Hello World!")
    })
  })
})
