// @flow
import Server from '../../src/index'
import HelloPlugin from './plugin/hello'

const server = new Server()


if (!process.env.DEBUG) {
  console.log('To get debugging output use DEBUG=server:*') // eslint-disable-line
}

server.listen({
  labels: 'root',
  port: 3000,
  host: 'localhost',
})

server.add({
  labels: 'root',
  // vhost: 'localhost',
  prefix: '/plugin',
  plugin: HelloPlugin,
  options: {},
})

// server.start()


Promise.resolve(server)
//  .then((app) => {
//    app.route({
//      method: 'GET',
//      path: '/',
//      handler: (request, reply) => {
//        reply('Hello, world!')
//      },
//    })
//    return Promise.resolve(app)
//  })
  .then(() => server.init())
  .then(() => server.start())
