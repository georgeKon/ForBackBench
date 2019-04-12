// what needs to happen?
// for each tool we have a number of scenarios
// for each scenario we have a set of queries
// we run each query from the scenario and record the time

import fs from 'fs'
import path from 'path'
import OBDAconverter from 'obda-converter'
import Timer from './utils/timer'
import execAsync from './utils/exec'
import { resolve } from './utils/filesystem'
import Database from './utils/database'

const timer = new Timer()

export default async function runScenario(ontologyPath : string, queryFolder : string, schemaPath : string, tool : string, database : Database) {
  const ext = tool === 'graal' ? '.rq' : '.txt'

  const schemaString = fs.readFileSync(schemaPath, 'utf8').trim().replace(/[\s+]+/g, ' ')
  // Find the queries
  const queries = fs.readdirSync(queryFolder)
    .filter(file => path.extname(file) === ext)
    .map(file => path.resolve(queryFolder, file))

  const rewriteTimes = []
  const executeTimes = []
  for(const queryFile of queries) {
    let output
    // switch(tool) {
    //   case 'rapid':
        timer.start()
        output = (await rewriteRapid(ontologyPath, queryFile)).map(line => line.replace(', .()', '')).map(line => line.replace(/Q[1-9]+\(/, 'Q('))
        rewriteTimes.push(timer.stop())
      // }
      console.log(output)
      timer.start()
      const query = OBDAconverter.convertUcqToSql(output, schemaString, { format: tool })
      const result = await database.query(query.join('\n'))
      console.log(result.rowCount)
      executeTimes.push(timer.stop())
  }

  return [rewriteTimes, executeTimes]
}

async function rewriteRapid(ontologyPath : string, queryFile : string) {
  const output = (await execAsync(`java -jar ./tools/Rapid2.jar DU SHORT ${ontologyPath} ${queryFile}`)).split(/\r?\n/)
  output.shift()
  output.pop()
  return output
}
