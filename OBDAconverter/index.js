#!/usr/bin/env node

const program = require('commander');
const { version } = require('./package.json')
const { convertSchemaToSql, convertSchemaToSqlCmd } = require('./app/converters/schema-sql')

program
  .version(version, '-v, --version')

program
  .command('schema')
  .arguments('<schema>')
  .description('Convert ChaseBench common format schema to SQL')
  .action((schema, options) => convertSchemaToSqlCmd(schema, options))

program
  .command('sparql')
  .arguments('<query>')
  .description('Convert SPARQL query to conjunctive query')
  .action((query, options) => convertSparqlToQueryCmd(query))

program.parse(process.argv)

module.exports = {
  convertSchemaToSql
}
