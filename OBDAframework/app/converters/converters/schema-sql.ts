import * as fs from 'fs'
import * as path from 'path'
import parser from '../grammars/schema-grammar'

const types = new Map([['STRING', 'text'], ['DOUBLE', 'double precision'], ['INTEGER', 'integer'], ['SYMBOL', 'text']])

export function convertSchemaToSqlCmd(schemaPath : string, options : any) : void {
  const schemaString = fs.readFileSync(path.resolve(schemaPath), 'utf8')

  const sqlArray = convertSchemaToSql(schemaString, options)
  console.log(sqlArray)
}

export function convertSchemaToSql(schemaString : string, options? : any) : string[] {
  const trimmedInput = schemaString.trim().replace(/[\s+]+/g, ' ')
  const parsed = parser.parse(trimmedInput)

  // @ts-ignore
  const lines = parsed.reduce((acc : string[], [name, attributes] : [string, Array<string>]) => {
    let createStatment = `CREATE TABLE "${name}" (`
    attributes.forEach((attribute : string, i : number) => {
      let command = `${attribute[0]} ${types.get(attribute[1])}`
      if(i < attributes.length - 1){
        command += ', '
      }
      createStatment += command
    })
    createStatment += ');'
    acc.push(`DROP TABLE IF EXISTS "${name}";`, createStatment)
    return acc
  }, [])
  return lines
}
