// @flow

import type Hapi from 'hapi'

const register = (app: Hapi.Server) => {
  app.route({
    method: 'GET',
    path: '/',
    handler: (request, reply) => {
      reply('Hello, from plugin!')
    },
    config: {
      description: 'Only for testing',
    },
  })
}
register.attributes = { name: 'helloPlugin' }

export default { register }
