const fs = require('fs')
const path = require('path')
const { parseConfig, openDatabaseConnection, queryDatabase, closeDatabaseConnection } = require('./drivers')
const { convertUcqToSql } = require('obda-converters')

async function executeUcqCmd(ucqPath, schemaPath, configPath, options) {
  const config = parseConfig(configPath)

  const client = await openDatabaseConnection(config)

  const ucqString = fs.readFileSync(path.resolve(ucqPath), 'utf8')
  const ucqArray = ucqString.split(/\r?\n/)
  const schema = fs.readFileSync(path.resolve(schemaPath), 'utf8')

  const result = await executeUcq(ucqArray, schema, client)

  console.log(result.rows)

  await closeDatabaseConnection(client)
}

async function executeUcq(ucqArray, schema, client) {
  const schemaString = schema.trim().replace(/[\s+]+/g, ' ')
  const sql = convertUcqToSql(ucqArray, schemaString).join('\n')

  // console.log(sql)

  const result = await queryDatabase(client, sql)
  return result
}

module.exports = {
  executeUcq,
  executeUcqCmd
}
