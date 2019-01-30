const fs = require('fs')
const path = require('path')
const parser = require('../grammars/schema-grammar')

const types = {
  'STRING': 'text',
  'DOUBLE': 'double precision',
  'INTEGER': 'integer',
  'SYMBOL': 'text'
}

function convertSchemaToSqlCmd(schemaPath, options) {
  const schemaString = fs.readFileSync(path.resolve(schemaPath), 'utf8')

  const sqlArray = convertSchemaToSql(schemaString, options)
  console.log(sqlArray)
}

function convertSchemaToSql(schemaString, options) {
  const trimmedInput = schemaString.trim().replace(/[\s+]+/g, ' ')
  const parsed = parser.parse(trimmedInput)
  
  const lines = parsed.reduce((acc, [name, attributes]) => {
    let createStatment = `CREATE TABLE "${name}" (`
    attributes.forEach((attribute, i) => {
      let string = `${attribute[0]} ${types[attribute[1]]}`
      if(i < attributes.length - 1) string += ', '
      createStatment += string
    })
    createStatment += ');'
    acc.push(`DROP TABLE IF EXISTS "${name}";`, createStatment)
    return acc
  }, [])
  return lines
}

module.exports = {
  convertSchemaToSql,
  convertSchemaToSqlCmd
}
