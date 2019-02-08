#!/usr/bin/env node

const program = require('commander');
const { version } = require('./package.json')
const { loadDataCmd } = require('./app/load')
const { computeRewritingsCmd } = require('./app/rewrite')
const { executeUcqCmd } = require('./app/execute')
const { runBenchmarkCmd } = require('./app/combined')


program
  .version(version, '-v, --version')

program
  .command('load')
  .arguments('<schema> <data> <config>')
  .description('Initialise a database with given schema and insert data')
  .option('-F, --force', 'Force use of provided schema even if cached version exists')
  .option('-t, --tgd', 'Flags use of tgd file that must be converted to schema')
  .action((schema, data, config, options) => loadDataCmd(schema, data, config, options))

program
  .command('rewrite')
  .arguments('<query> <ontology> <tool> <config>')
  .description('Compute UCQ rewriting of given query using specified tool')
  .option('-F, --force', 'Force use of provided query even if cached version exists')
  .option('-m, --mode <mode>', 'Graal mode')
  .action((query, ontology, tool, config, options) => computeRewritingsCmd(query, ontology, tool, config, options))

program
  .command('execute')
  .arguments('<ucq> <shema> <config>')
  .description('Execute a UCQ against a database')
  .action((ucq, schema, options) => executeUcqCmd(ucq, schema, options))

program
  .command('test')
  .arguments('<schema> <data> <query> <ontology> <tool> <config>')
  .description('Run a full test with the given query and ontology')
  .option('-I, --init', 'Initalise the database')
  .option('-F, --force', 'Force use of provided query even if cached version exists')
  .option('-m, --mode <mode>', 'Graal mode')
  .option('-t, --tgd', 'Flags use of tgd file that must be converted to schema')
  .action((schema, data, query, ontology, tool, config, options) => runBenchmarkCmd(schema, data, query, ontology, tool, config, options))

program.parse(process.argv)
