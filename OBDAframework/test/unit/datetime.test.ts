import 'mocha'
import { expect } from 'chai'
import MockDate from 'mockdate'
import DateTime from '../../app/utils/datetime'

const staticDate = new Date(2019, 0, 1, 12, 30, 15, 200)

describe('DateTime util class', () => {

  beforeEach(() => {
    MockDate.set(new Date(2019, 11, 31, 20, 45, 10, 500))
  })

  afterEach(() => {
    MockDate.reset()
  })

  it('should return a correctly formatted timestamp from a given Date', () => {
    const datetime = new DateTime(staticDate)

    const expected = '12:30:15:200'

    const result = datetime.timeStamp

    expect(result).to.deep.equal(expected)
  })

  it('should return a correctly formatted datestamp from a given Date', () => {
    const datetime = new DateTime(staticDate)

    const expected = '2019-0-1'

    const result = datetime.dateStamp

    expect(result).to.deep.equal(expected)
  })

  it('should return a correctly formatted datetimestamp from a given Date', () => {
    const datetime = new DateTime(staticDate)

    const expected = '2019-0-1-12:30:15:200'

    const result = datetime.dateTimeStamp

    expect(result).to.deep.equal(expected)
  })

  it('should return a correctly formatted timestamp from the current Date', () => {
    const datetime = new DateTime()

    const expected = '20:45:10:500'

    const result = datetime.timeStamp

    expect(result).to.deep.equal(expected)
  })

  it('should return a correctly formatted datestamp from the current Date', () => {
    const datetime = new DateTime()

    const expected = '2019-11-31'

    const result = datetime.dateStamp

    expect(result).to.deep.equal(expected)
  })

  it('should return a correctly formatted datetimestamp from the current Date', () => {
    const datetime = new DateTime()

    const expected = '2019-11-31-20:45:10:500'

    const result = datetime.dateTimeStamp

    expect(result).to.deep.equal(expected)
  })
})
