#!/usr/bin/env node

import program from 'commander'
import { version } from './package.json'
import { loadDataCmd, executeUcqCmd } from './app/commands'

program
  .version(version, '-v, --version')

program
  .command('load')
  .arguments('<schema> <data>')
  .description('Initialise a database with given schema and insert data')
  .option('-t, --tgd', 'Flags use of tgd file that must be converted to schema')
  .option('-c, --clean', 'Create clean instance of database by including DROP IF EXISTS commands')
  .action((schema, data, options) => loadDataCmd(schema, data, options))

// program
//   .command('rewrite')
//   .arguments('<query> <ontology> <tool> <config>')
//   .description('Compute UCQ rewriting of given query using specified tool')
//   .option('-F, --force', 'Force use of provided query even if cached version exists')
//   .option('-m, --mode <mode>', 'Graal mode')
//   .action((query, ontology, tool, config, options) => computeRewritingsCmd(query, ontology, tool, config, options))

program
  .command('execute')
  .arguments('<ucq> <schema>')
  .description('Execute a UCQ against a database')
  .action((ucq, schema, options) => executeUcqCmd(ucq, schema, options))

// program
//   .command('test')
//   .arguments('<schema> <data> <query> <ontology> <tool> <config>')
//   .description('Run a full test with the given query and ontology')
//   .option('-I, --init', 'Initalise the database')
//   .option('-F, --force', 'Force use of provided query even if cached version exists')
//   .option('-m, --mode <mode>', 'Graal mode')
//   .option('-t, --tgd', 'Flags use of tgd file that must be converted to schema')
//   .action((schema, data, query, ontology, tool, config, options) =>
        // runBenchmarkCmd(schema, data, query, ontology, tool, config, options))

program.parse(process.argv)
