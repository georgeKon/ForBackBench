import * as fs from 'fs'
import * as path from 'path'
import { Parser as SparqlParser, SelectQuery, BgpPattern } from 'sparqljs'

interface Triple {
  subject : string,
  object : string,
  predicate : string
}

const parser = new SparqlParser()

export function convertSparqlToQueryCmd(sparqlPath : string) {
  const sparqlString = fs.readFileSync(path.resolve(sparqlPath), 'utf8')

  const result = convertSparqlToQuery(sparqlString)
  console.log(result)
}

export function convertSparqlToQuery(sparqlString : string) {
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
