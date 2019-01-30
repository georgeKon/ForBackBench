const { parseConfig, openDatabaseConnection, closeDatabaseConnection } = require('./drivers')
const { loadData } = require('./load')
const { computeRewritings } = require('./rewrite')
const { executeUcq } = require('./execute')

async function runBenchmarkCmd(schemaPath, dataPath, queryPath, ontologyPath, tool, configPath, options) {
  const config = parseConfig(configPath)

  const client = await openDatabaseConnection(config)

  try {
    const schema = await loadData(schemaPath, dataPath, client, config, options)
    const ucq = await computeRewritings(queryPath, ontologyPath, tool, config)
    console.log(ucq)
    const result = await executeUcq(ucq, schema, client)
    console.log(result.rows)
  } catch(err) {
    console.error(err)
  } finally {
    await closeDatabaseConnection(client)
  }
}

module.exports = {
  runBenchmarkCmd
}
