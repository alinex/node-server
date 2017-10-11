// @flow

import type Hapi from 'hapi'

const register = (app: Hapi.Server) => {
  app.route({
    method: 'GET',
    path: '/',
    handler: (request, reply) => {
      reply('Hello, from plugin!')
    },
  })
}

register.attributes = {
  name: 'helloPlugin',
  version: '1.0.0',
}

export default { register }
