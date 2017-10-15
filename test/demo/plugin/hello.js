// @flow

import type Hapi from 'hapi'

const register = (app: Hapi.Server, options: Object, next: Function) => {
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
  next()
}
register.attributes = { name: 'helloPlugin' }

export default { register }
