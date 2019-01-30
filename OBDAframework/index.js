#!/usr/bin/env node

const program = require('commander');
const { version } = require('./package.json')
const { loadDataCmd } = require('./app/load')
const { computeRewritingsCmd } = require('./app/rewrite')

program
  .version(version, '-v, --version')

program
  .command('load')
  .arguments('<schema> <data> <config>')
  .description('Initialise a database with given schema and insert data')
  .action((schema, data, config, options) => loadDataCmd(schema, data, config, options))

program
  .command('rewrite')
  .arguments('<query> <ontology> <tool> <config>')
  .description('Compute UCQ rewriting of given query using specified tool')
  .action((query, ontology, tool, options) => computeRewritingsCmd(query, ontology, tool, options))

program.parse(process.argv)
