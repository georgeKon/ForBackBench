const fs = require('fs')
const { parseConfig, db } = require('./drivers')
const { loadData } = require('./load')
const { computeRewritings } = require('./rewrite')
const { executeUcq } = require('./execute')

async function runBenchmarkCmd(schemaPath, dataPath, queryPath, ontologyPath, tool, configPath, options) {
  const config = parseConfig(configPath)

  const client = await db.openDatabaseConnection(config)

  try {
    let schema
    if(options.init) {
      schema = await loadData(schemaPath, dataPath, client, config, options)
    } else {
      schema = fs.readFileSync(schemaPath, 'utf8')
    }
    const ucq = await computeRewritings(queryPath, ontologyPath, tool, config, options)
    console.log(ucq)
    // if(!options.mode === 'execute') {
      const result = await executeUcq(ucq, schema, client)
      console.log(result.rows)
    // }
  } catch(err) {
    console.error(err)
  } finally {
    await db.closeDatabaseConnection(client)
  }
}

module.exports = {
  runBenchmarkCmd
}
