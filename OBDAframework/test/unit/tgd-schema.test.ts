import 'mocha'
import { expect } from 'chai'
import { convertTgdToSchema } from '../../app/converters/converters/tgd-schema'

describe('TGD-Schema converter', () => {

  it('should convert a set of common format TGDs into a common format schema', () => {
    const tgdArray = [
      't0(?X,?Y) -> t1(?X) .',
      't0(?X,?Y) -> t2(?Y) .',
    ]
    const expected = [
      't0 {',
      '\tc0 : STRING',
      '\tc1 : STRING',
      '}',
      't1 {',
      '\tc0 : STRING',
      '}',
      't2 {',
      '\tc0 : STRING',
      '}',
    ]

    const result = convertTgdToSchema(tgdArray)

    expect(result).to.deep.equal(expected)
  })

  it('should handle multiple atoms on the right', () => {
    const tgdArray = [
      't0(?X) -> t1(?X) .',
      't0(?X) -> t1(?X), t2(?X,?Y) .'
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
    ]

    const result = convertTgdToSchema(tgdArray)

    expect(result).to.deep.equal(expected)
  })

  it('should ignore multiple atoms on the left', () => {
    const tgdArray = [
      't0(?X) -> t1(?X) .',
      't1(?X), t2(?Y) -> t3(?X,?Y) .'
    ]
    const expected = [
      't0 {',
      '\tc0 : STRING',
      '}',
      't1 {',
      '\tc0 : STRING',
      '}',
    ]

    const result = convertTgdToSchema(tgdArray)

    expect(result).to.deep.equal(expected)
  })
})
