const fs = require('fs')
const path = require('path')
const { Client } = require('pg')

function parseConfig(configPath) {
  const configObj = JSON.parse(fs.readFileSync(path.resolve(configPath), 'utf-8'))
  return configObj
}

async function openDatabaseConnection({ database }) {
  const client = new Client(database)
  console.log('Connecting to Postgres...')
  await client.connect()
  console.log('Postgres connection successful')
  return client
}

async function queryDatabase(client, query) {
  return client.query(query)
}

async function closeDatabaseConnection(client) {
  console.log('Closing Postgres connection...')
  await client.end()
  console.log('Connection closed')
}

module.exports = {
  parseConfig,
  openDatabaseConnection,
  queryDatabase,
  closeDatabaseConnection
}
