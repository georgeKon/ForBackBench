import fs from 'fs'
import path from 'path'
import { resolve } from './utils/filesystem'
import Logger from './utils/logger'
import Database from './utils/database'
import loadData from './load'
import runScenario from './test'
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
import execAsync from './utils/exec'

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
      createSQL(schemaPath.replace(path.basename(schemaPath), 's-schema.txt'), sqlPath.replace(path.basename(sqlPath), 's-schema.sql')),
      createSparqlQueries(queryFolder)
    ])
    return
  }

  if(options['mode'] === 'dllite') {
    // query rewriting mode
    const ontologyPath = resolve(options['onto'])
    const dataPath = resolve(options['data'])

    const dependenciesPath = ontologyPath.replace(path.basename(ontologyPath), 't-tgds.txt')
    const sourceSchemaPath = path.normalize(ontologyPath + '/../../schema/s-schema.txt')
    const targetSchemaPath = path.normalize(ontologyPath + '/../../schema/t-schema.txt')
    await createTargetDependencies(ontologyPath, dependenciesPath)
    await createTargetSchema(dependenciesPath, targetSchemaPath)
    await createSourceSchema(targetSchemaPath, targetSchemaPath.replace(path.basename(targetSchemaPath), 's-schema.txt')),

    Promise.all([
      createSQL(sourceSchemaPath, sourceSchemaPath.replace(path.extname(sourceSchemaPath), '.sql')),
      createSQL(targetSchemaPath, targetSchemaPath.replace(path.extname(targetSchemaPath), '.sql')),
      createRuleQueries(queryFolder),
      createSourceTargetDependencies(targetSchemaPath, dependenciesPath.replace(path.basename(dependenciesPath), 'st-tgds.txt')),
      // FIXME: this is not what we need
      // createSourceData(dataPath, path.resolve(dataPath, '../data_src'))
    ])
    return
  }
}

export async function loadDataCmd(schemaPath : string, dataPath : string) {
  const logger = new Logger('load', '../logs')
  const database = new Database(logger)

  await database.connect()

  await loadData(schemaPath, dataPath, database, logger)

  await database.close()
}

export async function runScenarioCmd(ontologyPath : string, queryFolder : string, schemaPath : string) {
  const logger = new Logger('load', '../logs')
  const database = new Database(logger)

  await database.connect()

  queryFolder = resolve(queryFolder)
  ontologyPath = resolve(ontologyPath)

  // for(let i = 0; i < 5; ++i) {
  //   console.log(`+++++ Run ${i + 1} +++++`)
    // const graalTimes = await runScenario(ontologyPath, queryFolder, '.rq', (ontology, query) => execAsync(`java -jar ./tools/obda-benchmark-graal-1.0-SNAPSHOT-spring-boot.jar ${ontology} ${query}`))
    const rapidTimes = await runScenario(ontologyPath, queryFolder, schemaPath, 'rapid', database)
    // const iqarosTimes = await runScenario(ontologyPath, queryFolder + '-iqaros', '.txt', (ontology, query) => execAsync(`java -jar ./tools/iqaros.jar ${ontology} ${query}`))
    // console.log(graalTimes)
    console.log(rapidTimes)
    // console.log(iqarosTimes)
    console.log('+++++')
  // }
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
