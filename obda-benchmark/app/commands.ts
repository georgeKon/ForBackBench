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
  createSourceData,
  createLLunaticConfigs,
  createQueryFolders
} from './bootstrap'
import { readdir } from './utils/filesystem'

export async function bootstrapCmd(baseFolder : string, mode : string) {
  baseFolder = resolve(baseFolder)
  const sizes = await readdir(path.resolve(baseFolder, 'data'))

  if(mode === 'chasebench') {
    if(path.resolve(baseFolder,'dependencies/t-tgds.txt'))
    await createOntology(path.resolve(baseFolder, 'dependencies/t-tgds.txt'), path.resolve(baseFolder, 'dependencies/ontology.owl'))
    await createSQL(path.resolve(baseFolder, 'schema/s-schema.txt'), path.resolve(baseFolder, 'schema/s-schema.sql'))
    await createSQL(path.resolve(baseFolder, 'schema/t-schema.txt'), path.resolve(baseFolder, 'schema/t-schema.sql'))
    await createQueryFolders(baseFolder)
    return
  }

  if(mode === 'dllite') {
    await createTargetDependencies(path.resolve(baseFolder, 'dependencies/ontology.owl'), path.resolve(baseFolder, 'dependencies/t-tgds.txt'))
    await createTargetSchema(path.resolve(baseFolder, 'dependencies/t-tgds.txt'), path.resolve(baseFolder, 'schema/t-schema.txt'))
    await createSourceSchema(path.resolve(baseFolder, 'schema/t-schema.txt'), path.resolve(baseFolder, 'schema/s-schema.txt')),

    Promise.all([
      createSQL(path.resolve(baseFolder, 'schema/s-schema.txt'), path.resolve(baseFolder, 'schema/s-schema.sql')),
      createSQL(path.resolve(baseFolder, 'schema/t-schema.txt'), path.resolve(baseFolder, 'schema/t-schema.sql')),
      createRuleQueries(baseFolder),
      createSourceTargetDependencies(path.resolve(baseFolder, 'schema/t-schema.txt'), path.resolve(baseFolder, 'dependencies/st-tgds.txt')),
    ])
    return
  }
}

export async function llunaticCmd(baseFolder : string) {
  const sizes = await readdir(path.resolve(baseFolder, 'data'))
  createLLunaticConfigs(baseFolder, sizes)
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
