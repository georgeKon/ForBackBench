import 'mocha'
import { expect } from 'chai'
import OBDAConverter from '../../app/utils/converter'

describe('TGD-Schema-SQL integration', () => {

  it('should convert common format TGDs to SQL via common format schema', () => {
    const tgdArray = [
      't0(?X,?Y) -> t1(?X) .',
      't0(?X,?Y) -> t2(?Y) .',
    ]

    const expected = [
      'CREATE TABLE "t0" (c0 text, c1 text);',
      'CREATE TABLE "t1" (c0 text);',
      'CREATE TABLE "t2" (c0 text);'
    ]

    const result = OBDAConverter.convertTgdToSql(tgdArray, { clean: false })

    expect(result).to.deep.equal(expected)
  })
})
