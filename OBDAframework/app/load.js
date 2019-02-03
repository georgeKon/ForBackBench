const fs = require('fs')
const path = require('path')
const { convertSchemaToSql } = require('obda-converters')
const copyFrom = require('pg-copy-streams').from
const { parseConfig, printMessage, db } = require('./drivers')

async function loadDataCmd(schemaPath, dataPath, configPath, options) {
  const config = parseConfig(configPath)

  const client = await db.openDatabaseConnection(config)

  const result = await loadData(schemaPath, dataPath, client, config, options)

  await db.closeDatabaseConnection(client)
}


async function loadData(schemaPath, dataPath, client, config, options) {
  const schema = fs.readFileSync(path.resolve(schemaPath), 'utf-8')
  const sqlPath = schemaPath.replace('.txt', '.sql')

  let query
  if(fs.existsSync(sqlPath) && !options.force) {
    printMessage('Using cached schema SQL')
    query = fs.readFileSync(sqlPath, 'utf8')
  } else {
    printMessage('Converting schema')
    query = convertSchemaToSql(schema).join('\n')
    fs.writeFileSync(sqlPath, query)
    printMessage('Schema conversion successful')
  }

  try {
    await db.beginTransaction(client)
    printMessage('Importing schema')
    const result = await db.queryDatabase(client, query)
    printMessage('Schema import successful')

    const files = fs.readdirSync(path.resolve(dataPath))
      .filter(file => path.extname(file) === '.csv')
    printMessage('Importing data')
    // For of loop because promises don't work in forEach
    for(const file of files) {
      const fileStream = fs.createReadStream(path.resolve(dataPath, file))
      const stream = await db.queryDatabase(client, copyFrom(`COPY "${path.parse(file).name}" FROM STDIN DELIMITER ','`))
      fileStream.pipe(stream)
      const promise = new Promise((resolve, reject) => {
        stream.on('end', () => resolve())
        stream.on('error', () => reject())
      })
      await promise
    }
    printMessage('Data import successful')
    await db.commitTransaction(client)
  } catch(err) {
    console.error(err)
    db.abortTransaction(client)
    printMessage('Transaction aborted')
  }
  return schema
}

module.exports = {
  loadData,
  loadDataCmd
}
