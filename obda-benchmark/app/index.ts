#!/usr/bin/env node

import program from 'commander'
import { loadDataCmd, computeRewritingsCmd, executeUcqCmd, runBenchmarkCmd, bootstrapCmd, runScenarioCmd } from './commands'

program
  .version('0.0.1', '-v, --version')

program
  .command('bootstrap')
  .option('--mode <mode>')
  .option('--t-tgds <tgds>')
  .option('--t-schema <schema>')
  .option('--data <data>')
  .option('--onto <onto>')
  .option('--qdir <qdir>')
  .action((options) => bootstrapCmd(options))

program
  .command('load')
  .arguments('<schema> <data>')
  .description('Initialise a database with given schema and insert data')
  .action((schema, data, options) => loadDataCmd(schema, data))

program
  .command('run')
  .arguments('<ontology> <queries> <schema>')
  .action((ontology, query, schema) => runScenarioCmd(ontology, query, schema))

// program
//   .command('rewrite')
//   .arguments('<query> <ontology> <tool>')
//   .description('Compute UCQ rewriting of given query using specified tool')
//   .option('-f, --common', 'Flags use of common format query instead of SPARQL')
//   .action((query, ontology, tool, options) => computeRewritingsCmd(query, ontology, tool, options))

// program
//   .command('execute')
//   .arguments('<ucq> <schema>')
//   .description('Execute a UCQ against a database')
//   .action((ucq, schema, options) => executeUcqCmd(ucq, schema, options))

// program
//   .command('test')
//   .arguments('<schema> <data> <query> <ontology> <tool>')
//   .description('Run a full test with the given query and ontology')
//   .option('-s, --skip', 'Skip creation of database')
//   .option('-b, --verbose', 'Log rewriting and query answers')
//   .action((schema, data, query, ontology, tool, options) =>
//     runBenchmarkCmd(schema, data, query, ontology, tool, options))

program.parse(process.argv)
