const fs = require('fs')
const path = require('path')
const { parseConfig, printMessage, db } = require('./drivers')
const { convertUcqToSql } = require('obda-converters')

async function executeUcqCmd(ucqPath, schemaPath, configPath, options) {
  const config = parseConfig(configPath)

  const client = await db.openDatabaseConnection(config)

  const ucqString = fs.readFileSync(path.resolve(ucqPath), 'utf8')
  const ucqArray = ucqString.split(/\r?\n/)
  const schema = fs.readFileSync(path.resolve(schemaPath), 'utf8')

  const result = await executeUcq(ucqArray, schema, client)

  printMessage('Results')
  console.log(result.rows)

  await db.closeDatabaseConnection(client)
}

async function executeUcq(ucqArray, schema, client) {
  const schemaString = schema.trim().replace(/[\s+]+/g, ' ')
  const sql = convertUcqToSql(ucqArray, schemaString).join('\n')
  
  console.log(sql)
  const result = await db.queryDatabase(client, sql)

  return result
}

module.exports = {
  executeUcq,
  executeUcqCmd
}
