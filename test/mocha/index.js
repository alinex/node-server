// @flow
import chai from 'chai'
import chaiAsPromised from 'chai-as-promised'
import Debug from 'debug'

import Server from '../../src/index'

chai.use(chaiAsPromised)
const expect = chai.expect
const debug = Debug('test')


describe('start', () => {

  const server = new Server()

  it('should start server', () => {
    expect(server).to.be.an.instanceof(Server)
  })

})
