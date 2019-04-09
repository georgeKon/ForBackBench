import fs from 'fs'
import path from 'path'
import { resolve } from './utils/filesystem'
import Logger from './utils/logger'
import Database from './utils/database'
import loadData from './load'
import computeRewritings from './rewrite'
import executeUcq from './execute'
import {
  createOntology,
  createTargetSchema,
  createSQL,
  createSparqlQueries,
  createTargetDependencies,
  createRuleQueries,
  createSourceSchema,
  createSourceTargetDependencies,
  createSourceData
} from './bootstrap'

export async function bootstrapCmd(options : any) {
  const queryFolder = resolve(options['qdir'])

  if(options['mode'] === 'chasebench') {
    const dependenciesPath = resolve(options['tTgds'])
    const schemaPath = resolve(options['tSchema'])
    const ontologyPath = dependenciesPath.replace(path.basename(dependenciesPath), 'ontology.owl')
    const sqlPath = schemaPath.replace(path.extname(schemaPath), '.sql')

    Promise.all([
      createOntology(dependenciesPath, ontologyPath),
      createSQL(schemaPath, sqlPath),
      createSparqlQueries(queryFolder)
    ])
    return
  }

  if(options['mode'] === 'dllite') {
    // query rewriting mode
    const ontologyPath = resolve(options['onto'])
    const dataPath = resolve(options['data'])

    const dependenciesPath = ontologyPath.replace(path.basename(ontologyPath), 't-tgds.txt')
    const schemaPath = path.normalize(ontologyPath + '/../../schema/t-schema.txt')
    await createTargetDependencies(ontologyPath, dependenciesPath)
    await createTargetSchema(dependenciesPath, schemaPath)

    Promise.all([
      createSQL(schemaPath, schemaPath.replace(path.extname(schemaPath), '.sql')),
      createRuleQueries(queryFolder),
      createSourceSchema(schemaPath, schemaPath.replace(path.basename(schemaPath), 's-schema.txt')),
      createSourceTargetDependencies(schemaPath, dependenciesPath.replace(path.basename(dependenciesPath), 'st-tgds.txt')),
      createSourceData(dataPath, path.resolve(dataPath, '../data_src'))
    ])
    return
  }
}

export async function loadDataCmd(schemaPath : string, dataPath : string) {
  const logger = new Logger('load', '../logs')
  const db = new Database(logger)

  await db.connect()

  await loadData(schemaPath, dataPath, db)

  await db.close()
}

export async function computeRewritingsCmd(
  queryPath : string, ontologyPath : string, tool : string, options : ComputeRewritingsOptions) {
  // const logger = new Logger('rewrite', '../logs')

  // const rewritings = await computeRewritings(queryPath, ontologyPath, tool, { logger, ...options })
  // logger.title('Rewritings')
  // rewritings.forEach(query => logger.out(query))
}

export async function executeUcqCmd(ucqPath : string, schemaPath : string, options : ExecuteUcqOptions) {
  // const logger = new Logger('execute', '../logs')
  // const db = new DB(logger)

  // const ucqArray = fs.readFileSync(path.resolve(ucqPath), 'utf8').split(/\r?\n/)
  // const schema = fs.readFileSync(path.resolve(schemaPath), 'utf8')

  // await db.connect()

  // await executeUcq(ucqArray, schema, db, { logger, ...options })

  // await db.close()
}

export async function runBenchmarkCmd(
  schemaPath : string, dataPath : string, queryPath : string,
  ontologyPath : string, tool : string, options : RunBenchmarkOptions) {
  // const logger = new Logger('run', '../logs')
  // const db = new DB(logger)

  // try {
  //   await db.connect()

  //   let schema : string
  //   if(options.skip) {
  //     logger.info(`Option Skip - Skipping load data`)
  //     schemaPath = path.resolve(schemaPath)
  //     schema = fs.readFileSync(schemaPath, 'utf8')
  //   } else {
  //     logger.title('Load data')
  //     schema = await loadData(schemaPath, dataPath, db, { logger, ...options })
  //   }

  //   const rewritings = await computeRewritings(queryPath, ontologyPath, tool, { logger, ...options })
  //   logger.title('Rewritings')
  //   if(options.verbose) {
  //     rewritings.forEach(query => logger.out(query))
  //   }

  //   const result = await executeUcq(rewritings, schema, db, { logger, format: tool, ...options })
  //   logger.title('Answers')
  //   logger.info('Rows returned: ' + result.rowCount)
  //   if(options.verbose) {
  //     result.rows.forEach(row => logger.out(JSON.stringify(row)))
  //   }
  // } catch(err) {
  //   logger.info('Benchmark exited after error')
  // } finally {
  //   await db.close()
  // }
}
