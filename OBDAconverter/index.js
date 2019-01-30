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

program.parse(process.argv)

module.exports = {
  convertSchemaToSql
}
