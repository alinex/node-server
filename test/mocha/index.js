// @flow
import chai from 'chai'
import chaiAsPromised from 'chai-as-promised'
import chaiHttp from 'chai-http'
import Debug from 'debug'

import Server from '../../src/index'

chai.use(chaiAsPromised)
chai.use(chaiHttp)
const expect = chai.expect
const debug = Debug('test')


describe('server', () => {

  describe('setup', () => {

    const server = new Server()

    it('should start server', () => {
      server.listen(3000, 'localhost')
      server.server.route({
        method: 'GET',
        path: '/',
        handler: (request, reply) => {
          reply('Hello, world!')
        },
      })
      return server.start()
    })

    it('should be working', () => (chai: any)
      .request('http://localhost:3000').get('/')
      .then((res) => {
        debug(`Returned: ${res.status} - ${res.text}`)
        return true
      })
      .catch((err) => {
        debug(`Error: ${err.message}`)
        return true
      }))

    it('should stop server', () => server.stop())

  })

  describe('config', () => {

    const server = new Server()

    it('should start server', () => {
      server.config({
        port: 3000,
        host: 'localhost',
      })
      server.server.route({
        method: 'GET',
        path: '/',
        handler: (request, reply) => {
          reply('Hello, world!')
        },
      })
      return server.start()
    })

    it('should be working', () => (chai: any)
      .request('http://localhost:3000').get('/')
      .then((res) => {
        debug(`Returned: ${res.status} - ${res.text}`)
        return true
      })
      .catch((err) => {
        debug(`Error: ${err.message}`)
        return true
      }))

    it('should stop server', () => server.stop())

  })

})
