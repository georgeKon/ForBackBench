import fs from 'fs'
import path from 'path'
import OBDAconverter from './utils/converter'

export default async function computeRewritings(
  queryPath : string, ontologyPath : string, tool : string, options : ComputeRewritingsOptions) {
  if(options === undefined) {
    options = { }
  }

  if(options.common === undefined) {
    options.common = false
  }
  const { common, logger } = options

  queryPath = path.resolve(queryPath)
  ontologyPath = path.resolve(ontologyPath)

  if(!common) {
    const sparql = fs.readFileSync(queryPath, 'utf8')
    const commonQuery = OBDAconverter.convertSparqlToQuery(sparql)
    const commonQueryPath = queryPath.replace('.rq', '.cq')
    fs.writeFileSync(commonQueryPath, commonQuery)
    queryPath = commonQueryPath
  }

  logger && logger.info(`Running tool '${tool}'`)
  const ucqArray : string[] = []
  switch(tool) {
    case 'rapid':
      break
    case 'iqaros':
      break
    default:
      throw new Error(`Unknown OBDA tool '${tool}'`)
  }

  return ucqArray
}
