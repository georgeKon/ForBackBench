import * as fs from 'fs'
import * as path from 'path'
import { convertSchemaToSql } from './converters/converters/schema-sql'
import { convertTgdToSchema } from './converters/converters/tgd-schema'
import { from as copyFrom } from 'pg-copy-streams'
import DB from './utils/db'
import Logger from './utils/logger'

interface LoadDataOptions {
  tgd? : boolean,
  clean? : boolean
  logger? : Logger
}

export async function loadDataCmd(schemaPath : string, dataPath : string, options : any) {
  const logger = new Logger({ logPath: './logs' })
  const db = new DB(logger)
  // await db.connect()

  loadData(schemaPath, dataPath, db, { logger, tgd: options.tgd, clean: options.clean })
}

export async function loadData(schemaPath : string, dataPath : string, db : DB, { logger, tgd, clean } : LoadDataOptions) {
  if(!logger) {
    logger = new Logger({ })
  }

  schemaPath = path.resolve(schemaPath)
  let schema = fs.readFileSync(schemaPath, 'utf-8')
  if(tgd) {
    schema = convertTgdToSchema(schema.split(/\r?\n/)).join('\n')
  }
  const sqlPath = schemaPath.replace('.txt', '.sql')

  // let query
  // if(fs.existsSync(sqlPath) && !options.force) {
  //   printMessage('Using cached schema SQL')
  //   query = fs.readFileSync(sqlPath, 'utf8')
  // } else {
  //   printMessage('Converting schema')
  //   query = convertSchemaToSql(schema).join('\n')
  //   fs.writeFileSync(sqlPath, query)
  //   printMessage('Schema conversion successful')
  // }
  logger.info('Begin schema convert')
  const query = convertSchemaToSql(schema, { clean }).join('\n')
  logger.pass('Schema convert complete')
  fs.writeFileSync(sqlPath, query)
  logger.info(`SQL written to ${sqlPath}`)

  try {
    await db.transact()
    // printMessage('Importing schema')
    logger.info('Begin schema import')
    const result = await db.query(query)
    logger.pass('Schema import complete')

    const files = fs.readdirSync(path.resolve(dataPath))
      .filter(file => path.extname(file) === '.csv')
    // printMessage('Importing data')
    logger.info('Begin data import')
    // For of loop because promises don't work in forEach
    for(const file of files) {
      logger.info(`Import ${file}`)
      const fileStream = fs.createReadStream(path.resolve(dataPath, file))
      const stream = await db.query(copyFrom(`COPY "${path.parse(file).name}" FROM STDIN DELIMITER ','`))
      // @ts-ignore
      fileStream.pipe(stream)
      const promise = new Promise((resolve, reject) => {
        // @ts-ignore
        stream.on('end', () => resolve())
        // @ts-ignore
        stream.on('error', () => reject())
      })
      await promise
      logger.pass(`${file} imported`)
    }
    logger.pass('Data import complete')
    await db.commit()
  } catch(err) {
    logger.error(err.message)
    db.abort()
  }
  return schema
}
