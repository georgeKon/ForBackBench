import * as fs from 'fs'
import * as path from 'path'
import DB from './utils/db'
import Logger from './utils/logger'
import { convertUcqToSql } from './converters/converters/ucq-sql'

interface ExecuteUcqOptions {
  logger? : Logger
}

export async function executeUcqCmd(ucqPath : string, schemaPath : string, options : any) {
  const logger = new Logger('execute', './logs')
  // const client = await db.openDatabaseConnection(config)

  const ucqString = fs.readFileSync(path.resolve(ucqPath), 'utf8')
  const ucqArray = ucqString.split(/\r?\n/)
  const schema = fs.readFileSync(path.resolve(schemaPath), 'utf8')

  const result = await executeUcq(ucqArray, schema, { logger })

  // console.log(result.rows)

  // await db.closeDatabaseConnection(client)
}

export async function executeUcq(ucqArray : string[], schema : string, options : ExecuteUcqOptions, db? : DB) {
  let { logger } = options
  if(!logger) {
    logger = new Logger('execute', './logs')
  }

  const schemaString = schema.trim().replace(/[\s+]+/g, ' ')
  const sql = convertUcqToSql(ucqArray, schemaString).join('\n')

  // const result = await db.queryDatabase(client, sql)

  // return result
}
