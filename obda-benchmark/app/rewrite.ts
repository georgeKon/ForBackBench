import fs from 'fs'
import path from 'path'
// import OBDAconverter from 'obda-converter'
import execAsync from './utils/exec'
import Timer from './utils/timer'

const timer = new Timer()

export default async function computeRewritings(
  queryPath : string, ontologyPath : string, tool : string, { logger } : ComputeRewritingsOptions) {

  queryPath = path.resolve(queryPath)
  ontologyPath = path.resolve(ontologyPath)

  // try {
  //   if(query) {
  //     logger && logger.info('Converting SPARQL query to common format')
  //     const sparql = fs.readFileSync(queryPath, 'utf8')
  //     timer.start()
  //     const commonQuery = OBDAconverter.convertSparqlToQuery(sparql)
  //     logger && logger.pass('Sparql converted successfully', timer.stop())
  //     const commonQueryPath = queryPath.replace('.rq', '.txt')
  //     fs.writeFileSync(commonQueryPath, commonQuery)
  //     logger && logger.info(`Common format query written to ${commonQueryPath}`)
  //     queryPath = commonQueryPath
  //   } else {
  //     logger && logger.info('Option Query - Skipping SPARQL conversion')
  //   }
  //   if(owl === undefined) {
  //     logger && logger.info('Converting TGDs to OWL ontology')
  //     const tgds = fs.readFileSync(ontologyPath, 'utf8').split(/\r?\n/)
  //     timer.start()
  //     const owlOntology = OBDAconverter.convertTgdToOwl(tgds)
  //     logger && logger.pass('TGDs converted successfully', timer.stop())
  //     const owlOntologyPath = ontologyPath.replace('.txt', '.owl')
  //     fs.writeFileSync(owlOntologyPath, owlOntology)
  //     logger && logger.info(`OWL ontology written to ${owlOntologyPath}`)
  //     ontologyPath = owlOntologyPath
  //   } else {
  //     logger && logger.info('Option OWL - Skipping OWL conversion')
  //   }
  // } catch(err) {
  //   logger && logger.error(err.message)
  //   throw new Error(err)
  // }

  logger && logger.info(`Running tool '${tool}'`)
  let ucqArray : string[]
  switch(tool) {
    case 'rapid':
      try {
        timer.start()
        const out = await execAsync(`java -jar ../tools/Rapid2.jar DU SHORT ${ontologyPath} ${queryPath}`)
        const time = timer.stop()
        logger && logger.pass(`${tool} ran successfully`, time)
        const array = out.split(/\r?\n/)
        array.shift()
        array.pop()
        ucqArray = array
        break
      } catch(err) {
          logger && logger.error(err.message)
          throw new Error(err)
      }
    case 'iqaros':
      try {
        timer.start()
        const out = await execAsync(`java -jar ../tools/iqaros.jar ${ontologyPath} ${queryPath}`)
        const time = timer.stop()
        logger && logger.pass(`${tool} ran successfully`, time)
        const array = out.split(/\r?\n/)
        array.shift()
        array.shift()
        array.shift()
        array.pop()
        ucqArray = array.map(line => line.replace(/\s\s/g, ' '))
        break
      } catch(err) {
        logger && logger.error(err.message)
        throw new Error(err)
      }
    case 'graal':
      try {
        timer.start()
        const out = await execAsync(
          `java -jar ../tools/obda-benchmark-graal-1.0-SNAPSHOT-spring-boot.jar ${ontologyPath} ${queryPath}`)
        const time = timer.stop()
        logger && logger.pass(`${tool} ran successfully`, time)
        const array = out.split(/\r?\n/)
        array.shift()
        array.shift()
        array.pop()
        ucqArray = array
        break
      } catch(err) {
        logger && logger.error(err.message)
        throw new Error(err)
      }
    default:
      throw new Error(`Unknown OBDA tool '${tool}'`)
  }

  return ucqArray
}
