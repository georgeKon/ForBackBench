#!/usr/bin/env node

const program = require('commander');
const { version } = require('./package.json')
const { loadDataCmd } = require('./app/load')

program
  .version(version, '-v, --version')

program
  .command('load')
  .arguments('<schema> <data> <config>')
  .description('Initialise a database and insert data')
  .action((schema, data, config, options) => loadDataCmd(schema, data, config, options))

program.parse(process.argv)
