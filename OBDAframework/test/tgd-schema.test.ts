import 'mocha'
import { expect } from 'chai'
import { convertTgdToSchema } from '../app/converters/converters/tgd-schema'

describe('TGD-Schema converter', () => {

  it('should convert a set of common format TGDs into a common format schema', () => {
    const tgdArray = [
      't0(?X) -> t1(?X) .',
      't2(?X,?X1) -> t0(?X) .',
      't0(?X) -> t3(?X,?Y), t1(?Y) .',
    ]
    const expected = [
      't0 {',
      '\tc0 : STRING',
      '}',
      't1 {',
      '\tc0 : STRING',
      '}',
      't2 {',
      '\tc0 : STRING',
      '\tc1 : STRING',
      '}',
      't3 {',
      '\tc0 : STRING',
      '\tc1 : STRING',
      '}',
    ]

    const result = convertTgdToSchema(tgdArray)

    expect(result).to.deep.equal(expected)
  })
})
