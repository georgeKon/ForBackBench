import 'mocha'
import { expect } from 'chai'
import { convertSchemaToSql } from '../app/converters/converters/schema-sql'

const schema = 't0 { c0 : STRING } t1 { c0 : STRING, c1 : STRING }'

describe('Schema-SQL converter', () => {

  it('should convert a common format schema to SQL', () => {
    const expected = [
      'CREATE TABLE "t0" (c0 text);',
      'CREATE TABLE "t1" (c0 text, c1 text);',
    ]

    const result = convertSchemaToSql(schema)

    expect(result).to.deep.equal(expected)
  })

  it('should add DROP TABLE commands when \'clean\' flag is set', () => {
    const expected = [
      'DROP TABLE IF EXISTS "t0";',
      'CREATE TABLE "t0" (c0 text);',
      'DROP TABLE IF EXISTS "t1";',
      'CREATE TABLE "t1" (c0 text, c1 text);',
    ]

    const result = convertSchemaToSql(schema, { clean: true })

    expect(result).to.deep.equal(expected)
  })
})
