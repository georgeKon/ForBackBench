import { Parser as SparqlParser, SelectQuery } from 'sparqljs'

const parser = new SparqlParser()

export function convertSparqlToQuery(sparqlString : string, options? : SparqlQueryOptions) {
  // @ts-ignore
  const { variables, where: [ { triples } ] } = parser.parse(sparqlString) as SelectQuery
  const atoms = triples.map((triple : Triple) => generateString(triple))

  return `Q(${variables.join(',')}) <- ${atoms.join(',')}`
}

function generateString({ subject, predicate, object } : Triple) {
  const fixedSubject = extract(subject)
  const fixedPredicate = extract(predicate)
  const fixedObject = extract(object)

  return fixedPredicate === 'type'
    ? `${fixedObject}(${fixedSubject})`
    : `${fixedPredicate}(${fixedSubject},${fixedObject})`
}

function extract(object : string) {
  if(/^\?/.test(object)) {
    return object
  }
  const last = object.split('#').pop()
  return last
}
