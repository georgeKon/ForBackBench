const fs = require('fs')
const path = require('path')
const { convertSchemaToSql } = require('obda-converters')
const copyFrom = require('pg-copy-streams').from
const { parseConfig, db } = require('./drivers')

async function loadDataCmd(schemaPath, dataPath, configPath, options) {
  const config = parseConfig(configPath)

  const client = await db.openDatabaseConnection(config)

  const result = await loadData(schemaPath, dataPath, client, config, options)

  await db.closeDatabaseConnection(client)
}


async function loadData(schemaPath, dataPath, client, config, options) {

  const schema = fs.readFileSync(path.resolve(schemaPath), 'utf-8')
  // FIXME: Could be join to be consistent
  const query = convertSchemaToSql(schema).reduce((acc, elem) => acc.concat(elem))

  const test = await db.beginTransaction(client)
  try {
    console.log('Importing schema...')
    const result = await db.queryDatabase(client, query)
    console.log('Schema import successful')

    const files = fs.readdirSync(path.resolve(dataPath))
      .filter(file => path.extname(file) === '.csv')
    console.log('Importing data')
    // For of loop because promises don't work in forEach
    for(const file of files) {
      const fileStream = fs.createReadStream(path.resolve(dataPath, file))
      const stream = await db.queryDatabase(client, copyFrom(`COPY "${path.parse(file).name}" FROM STDIN DELIMITER ','`))
      fileStream.pipe(stream)
      const promise = new Promise((resolve, reject) => {
        stream.on('end', () => resolve())
      })
      await promise
    }
    console.log('Data import successful')
    await db.commitTransaction(client)
  } catch(err) {
    console.error(err)
    db.abortTransaction(client)
    console.log('Transaction aborted')
  }
  return schema
}

module.exports = {
  loadData,
  loadDataCmd
}
