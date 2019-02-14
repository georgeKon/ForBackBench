import 'mocha'
import { expect } from 'chai'
import { convertUcqToSql } from '../../app/converters/converters/ucq-sql'

const schema = 't0 { c0 : STRING } t1 { c0 : STRING, c1 : STRING }'

describe('UCQ-SQL converter', () => {

  it('should convert a single Rapid UCQ to SQL', () => {
    const rapidUcqSingle = ['Q(?X) <- t0(?X), t1(?X, ?Y)']
    const expected = [
      'SELECT A.c0',
      'FROM "t0" as A, "t1" as B',
      'WHERE B.c0 = A.c0 AND A.c0 = B.c0;'
    ]

    const result = convertUcqToSql(rapidUcqSingle, schema)

    expect(result).to.deep.equal(expected)
  })

  it('should convert a single Iqaros UCQ to SQL', () => {
    const iqarosUcqSingle = ['Q(X0) <- t0(X0) ^ t1(X0,X1)']
    const expected = [
      'SELECT A.c0',
      'FROM "t0" as A, "t1" as B',
      'WHERE B.c0 = A.c0 AND A.c0 = B.c0;'
    ]

    const result = convertUcqToSql(iqarosUcqSingle, schema)

    expect(result).to.deep.equal(expected)
  })

  it('should convert a union Rapid UCQ to SQL', () => {
    const rapidUcqUnion = [
      'Q(?X) <- t0(?X), t1(?X, ?Y)',
      'Q(?X, ?Y) <- t0(?X), t1(?X, ?Y)'
    ]
    const expected = [
      'SELECT A.c0',
      'FROM "t0" as A, "t1" as B',
      'WHERE B.c0 = A.c0 AND A.c0 = B.c0',
      'UNION',
      'SELECT A.c0, B.c1',
      'FROM "t0" as A, "t1" as B',
      'WHERE B.c0 = A.c0 AND A.c0 = B.c0;'
    ]

    const result = convertUcqToSql(rapidUcqUnion, schema)

    expect(result).to.deep.equal(expected)
  })

  it('should convert a union Rapid UCQ to SQL', () => {
    const iqarosUcqUnion = [
      'Q(X0) <- t0(X0) ^ t1(X0,X1)',
      'Q(X0,X1) <- t0(X0) ^ t1(X0,X1)'
    ]
    const expected = [
      'SELECT A.c0',
      'FROM "t0" as A, "t1" as B',
      'WHERE B.c0 = A.c0 AND A.c0 = B.c0',
      'UNION',
      'SELECT A.c0, B.c1',
      'FROM "t0" as A, "t1" as B',
      'WHERE B.c0 = A.c0 AND A.c0 = B.c0;'
    ]

    const result = convertUcqToSql(iqarosUcqUnion, schema)

    expect(result).to.deep.equal(expected)
  })
})
