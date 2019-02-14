import 'mocha'
import { expect } from 'chai'
import { convertTgdToSchema } from '../../app/converters/converters/tgd-schema'
import { convertSchemaToSql } from '../../app/converters/converters/schema-sql'

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

    const schemaString = convertTgdToSchema(tgdArray).join('\n')
    const result = convertSchemaToSql(schemaString, { clean: false })

    expect(result).to.deep.equal(expected)
  })
})
