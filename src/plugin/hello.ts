import * as Hapi from "hapi"

const register = (app: Hapi.Server, options: any, next: () => void) => {
  console.log(options)
  app.route({
    method: "GET",
    path: "/",
    handler: (_, reply) => {
      reply("Hello, from plugin!")
    },
    config: {
      description: "Only for testing",
    },

  })
  next()
}
register.attributes = { name: "helloPlugin" }

export default { register }
