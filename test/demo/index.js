// @flow
import Server from '../../src/index'

const server = new Server()

console.log('To get debugging output use DEBUG=server:*') // eslint-disable-line

server.listen({ port: 3000, host: 'localhost' })
  .then((app) => {
    app.route({
      method: 'GET',
      path: '/',
      handler: (request, reply) => {
        reply('Hello, world!')
      },
    })
    return Promise.resolve(app)
  })
  .then(() => server.init())
  .then(() => server.start())
