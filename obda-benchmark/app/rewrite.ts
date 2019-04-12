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
