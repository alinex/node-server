import * as Hapi from "hapi"

import Server from "../../src/Server"

class TServer extends Server {

  public handle(): Hapi.Server {
    return this.hapi
  }

}

export default TServer
