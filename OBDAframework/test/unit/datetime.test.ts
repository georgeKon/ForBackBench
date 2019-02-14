import 'mocha'
import { expect } from 'chai'
import DateTime from '../../app/utils/datetime'

const testDate = new Date(2019, 0, 1, 12, 30, 15, 200)

describe('DateTime util class', () => {

  it('should return a correctly formatted timestamp', () => {
    const datetime = new DateTime(testDate)

    const expected = '12:30:15:200'

    const result = datetime.timeStamp

    expect(result).to.deep.equal(expected)
  })

  it('should return a correctly formatted datestamp', () => {
    const datetime = new DateTime(testDate)

    const expected = '2019-0-1'

    const result = datetime.dateStamp

    expect(result).to.deep.equal(expected)
  })

  it('should return a correctly formatted datetimestamp', () => {
    const datetime = new DateTime(testDate)

    const expected = '2019-0-1-12:30:15:200'

    const result = datetime.dateTimeStamp

    expect(result).to.deep.equal(expected)
  })
})
