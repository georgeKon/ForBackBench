import fs from 'fs'
import path from 'path'
import Logger from './utils/logger'
import DB from './utils/db'
import loadData from './load'
import computeRewritings from './rewrite'
import executeUcq from './execute'

export async function loadDataCmd(schemaPath : string, dataPath : string, options : LoadDataOptions) {
  const logger = new Logger('load', '../logs')
  const db = new DB(logger)

  await db.connect()

  await loadData(schemaPath, dataPath, db, { logger, ...options })

  await db.close()
}

export async function computeRewritingsCmd(
  queryPath : string, ontologyPath : string, tool : string, options : ComputeRewritingsOptions) {
  const logger = new Logger('rewrite', '../logs')

  await computeRewritings(queryPath, ontologyPath, tool, { logger, ...options })
}

export async function executeUcqCmd(ucqPath : string, schemaPath : string, options : ExecuteUcqOptions) {
  const logger = new Logger('execute', '../logs')
  const db = new DB(logger)

  const ucqArray = fs.readFileSync(path.resolve(ucqPath), 'utf8').split(/\r?\n/)
  const schema = fs.readFileSync(path.resolve(schemaPath), 'utf8')

  await db.connect()

  await executeUcq(ucqArray, schema, db, { logger, ...options })

  await db.close()
}

export async function runBenchmark(
  schemaPath : string, dataPath : string, queryPath : string,
  ontologyPath : string, tool : string, options : RunBenchmarkOptions) {
  const logger = new Logger('run', '../logs')
  const db = new DB(logger)

  await db.connect()

  const schema = await loadData(schemaPath, dataPath, db, { logger, ...options })

  const rewritings = await computeRewritings(queryPath, ontologyPath, tool, { logger, ...options })

  const result = await executeUcq(rewritings, schema, db, { logger, ...options })

  await db.close()
}
