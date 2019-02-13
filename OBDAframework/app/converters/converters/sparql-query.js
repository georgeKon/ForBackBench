const fs = require('fs')
const url = require('url')
const SparqlParser = require('sparqljs').Parser

const parser = new SparqlParser()

function convertSparqlToQueryCmd(sparqlPath) {
  const sparqlString = fs.readFileSync(path.resolve(sparqlPath), 'utf8')

  const result = convertSparqlToQuery(sparqlString)
  console.log(result)
}

function convertSparqlToQuery(sparqlString) {
  const { variables, where: [ { triples } ] } = parser.parse(sparqlString)
  const atoms = triples.map(triple => generateString(triple))
  
  return `Q(${variables.join(',')}) <- ${atoms.join(',')}`
}

function generateString({ subject, predicate, object }) {
  const fixedSubject = extract(subject)
  const fixedPredicate = extract(predicate)
  const fixedObject = extract(object)

  return fixedPredicate === 'type' ? `${fixedObject}(${fixedSubject})` : `${fixedPredicate}(${fixedSubject},${fixedObject})`
}

function extract(object) {
  if(/^\?/.test(object)) return object
  const last = object.split('#').pop()
  return last
}

module.exports = {
  convertSparqlToQuery,
  convertSparqlToQueryCmd
}
