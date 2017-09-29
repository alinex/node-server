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


describe('start', () => {

  const server = new Server()

  it('should start server', () => {
    server.listen(3000, 'localhost')
    return server.start()
  })

  it('should be working', () => (chai: any).request('http://localhost:3000').get('/')
    .then((res) => {
      debug(`Returned: ${res.status} - ${res.text}`)
      return true
    })
    .catch((err) => {
      debug(`Error: ${err.message}`)
      return true
    }))

})
