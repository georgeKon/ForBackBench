import 'mocha'
import 'mocha-sinon'
import 'chai-fs'
import chai from 'chai'
import MockDate from 'mockdate'
import mock from 'mock-fs'
import Logger from '../../app/utils/logger'
/* tslint:disable */
chai.use(require('chai-fs'))
/* tslint:enable */
const { expect } = chai

let logger : Logger

describe('Logger util class', () => {

  beforeEach(function() {
    this.sinon.stub(console, 'log')
    MockDate.set(new Date(2019, 0, 1, 12, 30, 15, 200))
    mock({
      'logs/': {  }
    })
    logger = new Logger('Logger-Test', './logs')
  })

  afterEach(() => {
    mock.restore()
    MockDate.reset()
  })

  it('should correctly log a custom message', () => {
    const expected = '12:30:15:200 TEST Test Message'

    logger.log('Test Message', 'TEST')
    /* tslint:disable */
    // @ts-ignore
    expect(console.log.calledOnce).to.be.true
    // @ts-ignore
    expect(console.log.calledWith(expected)).to.be.true
    /* tslint:enable */
    expect('./logs/2019-0-1-12:30:15:200-Logger-Test.log').to.be.a.file().with.content(expected + '\n')
  })

  it('should correctly log an info message', () => {
    const expected = '12:30:15:200 INFO Test Message'

    logger.info('Test Message')
    /* tslint:disable */
    // @ts-ignore
    expect(console.log.calledOnce).to.be.true
    // @ts-ignore
    expect(console.log.calledWith(expected)).to.be.true
    /* tslint:enable */
    expect('./logs/2019-0-1-12:30:15:200-Logger-Test.log').to.be.a.file().with.content(expected + '\n')
  })

  it('should correctly log an error message', () => {
    const expected = '12:30:15:200 ERROR Test Message'

    logger.error('Test Message')
    /* tslint:disable */
    // @ts-ignore
    expect(console.log.calledOnce).to.be.true
    // @ts-ignore
    expect(console.log.calledWith(expected)).to.be.true
    /* tslint:enable */
    expect('./logs/2019-0-1-12:30:15:200-Logger-Test.log').to.be.a.file().with.content(expected + '\n')
  })

  it('should correctly log an output message', () => {
    const expected = '12:30:15:200 OUT Test Message'

    logger.out('Test Message')
    /* tslint:disable */
    // @ts-ignore
    expect(console.log.calledOnce).to.be.true
    // @ts-ignore
    expect(console.log.calledWith(expected)).to.be.true
    /* tslint:enable */
    expect('./logs/2019-0-1-12:30:15:200-Logger-Test.log').to.be.a.file().with.content(expected + '\n')
  })

  it('should correctly log a warning message', () => {
    const expected = '12:30:15:200 WARN Test Message'

    logger.warn('Test Message')
    /* tslint:disable */
    // @ts-ignore
    expect(console.log.calledOnce).to.be.true
    // @ts-ignore
    expect(console.log.calledWith(expected)).to.be.true
    /* tslint:enable */
    expect('./logs/2019-0-1-12:30:15:200-Logger-Test.log').to.be.a.file().with.content(expected + '\n')
  })

  it('should correctly log a pass message', () => {
    const expected = '12:30:15:200 PASS Test Message'

    logger.pass('Test Message')
    /* tslint:disable */
    // @ts-ignore
    expect(console.log.calledOnce).to.be.true
    // @ts-ignore
    expect(console.log.calledWith(expected)).to.be.true
    /* tslint:enable */
    expect('./logs/2019-0-1-12:30:15:200-Logger-Test.log').to.be.a.file().with.content(expected + '\n')
  })

  it('should be silent when set to mute', () => {
    logger = new Logger('Logger-Test', './logs', true)
    const expected = '12:30:15:200 TEST Test Message'

    logger.log('Test Message', 'TEST')
    /* tslint:disable */
    // @ts-ignore
    expect(console.log.calledOnce).to.be.false
    // @ts-ignore
    expect(console.log.calledWith(expected)).to.be.false
    /* tslint:enable */
    expect('./logs/2019-0-1-12:30:15:200-Logger-Test.log').to.not.be.a.path()
  })
})
