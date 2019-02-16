import fs from 'fs'
import path from 'path'
import Logger from './utils/logger'
import DB from './utils/db'
import { loadData } from './load'
import { executeUcq } from './execute'

export async function loadDataCmd(schemaPath : string, dataPath : string, options? : LoadDataOptions) {
  const logger = new Logger('load', '../logs')
  const db = new DB(logger)

  if(!options) {
    options = { }
  }

  if(!options.clean) {
    options.clean = false
  }

  if(!options.tgd) {
    options.tgd = false
  }

  await db.connect()

  await loadData(schemaPath, dataPath, db, { logger, ...options, clean: true })
}

export async function executeUcqCmd(ucqPath : string, schemaPath : string, options? : ExecuteUcqOptions) {
  const logger = new Logger('execute', '../logs')
  const db = new DB(logger)

  if(!options) {
    options = { format: 'rapid' }
  }

  const ucqArray = fs.readFileSync(path.resolve(ucqPath), 'utf8').split(/\r?\n/)
  const schema = fs.readFileSync(path.resolve(schemaPath), 'utf8')

  await db.connect()

  await executeUcq(ucqArray, schema, db, { logger, ...options })
}
