const fs = require('fs')
const path = require('path')
const { Client } = require('pg')

function parseConfig(configPath) {
  const configObj = JSON.parse(fs.readFileSync(path.resolve(configPath), 'utf-8'))
  return configObj
}

function printMessage(message) {
  console.log(`---${message}---`)
}

async function openDatabaseConnection({ database }) {
  const client = new Client(database)
  printMessage('Connecting to Postgres')
  await client.connect()
  printMessage('Postgres connection successful')
  return client
}

async function queryDatabase(client, query) {
  return client.query(query)
}

async function beginTransaction(client) {
  return client.query('BEGIN;')
}

async function commitTransaction(client) {
  return client.query('COMMIT;')
}

async function abortTransaction(client) {
  return client.query('ROLLBACK;')
}

async function closeDatabaseConnection(client) {
  printMessage('Closing Postgres connection')
  await client.end()
  printMessage('Connection closed')
}

const db = {
  openDatabaseConnection,
  beginTransaction,
  queryDatabase,
  commitTransaction,
  abortTransaction,
  closeDatabaseConnection
}


module.exports = {
  parseConfig,
  printMessage,
  db
}
