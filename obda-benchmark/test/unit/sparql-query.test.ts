import 'mocha'
import { expect } from 'chai'
import { convertSparqlToQuery } from '../../app/converters/converters/sparql-query'

describe('SPARQL-Query converter', () => {

  it('should convert a SPARQL query to common format query', () => {
    const sparqlString = `PREFIX rdf: <http://www.w3.org/1999/02/22-rdf-syntax-ns#>
      PREFIX ub: <http://www.lehigh.edu/~zhp2/2004/0401/univ-bench.owl#>
      SELECT ?X
      WHERE {
        ?X rdf:type ub:t0 .
        ?X ub:t1 ?Y
      }`
    const expected = 'Q(?X) <- t0(?X),t1(?X,?Y)'

    const result = convertSparqlToQuery(sparqlString)

    expect(result).to.deep.equal(expected)
  })
})
