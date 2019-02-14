import * as fs from 'fs'
import * as path from 'path'
import rapidUcqParser from '../grammars/rapid-ucq-grammar'
import iqarosUcqParser from '../grammars/iqaros-ucq-grammar'
import schemaParser from '../grammars/schema-grammar'
import Logger from '../../utils/logger'

interface UcqSqlOptions {
  logger? : Logger
}

type ParsedSchema = Array<[string, Array<[string, string]>]>

type ParsedUCQ = [Array<string | string[]>, Array<string | Array<string | string[]>>]

// export function convertUcqToSqlCmd(ucqPath : string, schemaPath : string) {
//   const ucqArray = fs.readFileSync(path.resolve(ucqPath), 'utf8').split(/\r?\n/)
//   const schemaString = fs.readFileSync(path.resolve(schemaPath), 'utf8')

//   const sqlArray = convertUcqToSql(ucqArray, schemaString, { })
// }

export function convertUcqToSql(ucqArray : string[], schemaString : string, options? : UcqSqlOptions) {
  const logger = options && options.logger ? options.logger : new Logger('', '', true)

  const trimmedInput = schemaString.trim().replace(/[\s+]+/g, ' ')
  const parsedSchema = schemaParser.parse(trimmedInput) as ParsedSchema

  const lines = ucqArray.reduce((acc : string[], elem) => {
    let parsed
    try {
      parsed = rapidUcqParser.parse(elem)
      logger.info('Parsed with Rapid Parser')
    } catch(err) {
      try {
        parsed = iqarosUcqParser.parse(elem)
        logger.info('Parsed with Iqaros Parser')
      } catch(err) {
        logger.error('Cannot parse UCQ')
        logger.error(err.message)
      }
    }

    const [selection, constraints] = parsed as ParsedUCQ
    const fixedSelection = selection.map(variable => handleConjunction(variable)) as string[]

    const fixedConstraints = constraints.reduce((accum : Array<[string, string[]]>, element) => {
      const fixedElement = handleConjunction(element) as [string, string[]]
      const fixedVariables = fixedElement[1].map(variable => handleConjunction(variable)) as string[]
      accum.push([fixedElement[0], fixedVariables])
      return accum
    }, [])

    const selectStatement = fixedSelection.reduce((accum, elemnt, i) => {
      for(const j in fixedConstraints) {
        if(fixedConstraints.hasOwnProperty(j)) {
          const [name, variables] = fixedConstraints[j]
          const idx = variables.indexOf(elemnt)
          if(idx > -1) {
            accum += `${getAttributeString(j, name, parsedSchema, idx)}`
            if(i < fixedSelection.length - 1) {
              accum += ', '
            }
            break
          }
        }
      }
      return accum
    }, 'SELECT ')

    acc.push(selectStatement)

    let fromStatement = fixedConstraints.reduce((accum, [ name ], i) => {
      accum += `"${name}" as ${toChar(i)}, `
      return accum
    }, 'FROM ')

    fromStatement = fromStatement.substring(0, fromStatement.lastIndexOf(', '))
    acc.push(fromStatement)

    let whereStatement = fixedConstraints.reduce((accum, [name, variables], i) => {
      fixedConstraints.forEach(([otherName, otherVariables], j) => {
        if(i === j) {
          return
        }
        variables.forEach((variable, k) => {
          if(variable.charAt(0) === '?') {
            otherVariables.forEach((otherVariable, l) => {
              if(variable === otherVariable) {
                accum += `${getAttributeString(j, otherName, parsedSchema, l)} = `
                accum += `${getAttributeString(i, name, parsedSchema, k)} AND `
              }
            })
          } else {
            accum += `${getAttributeString(i, name, parsedSchema, k)} = '${variable.replace(/\"/g, '')}' AND `
          }
        })
      })
      return accum
    }, 'WHERE ')

    whereStatement = whereStatement.substring(0, whereStatement.lastIndexOf(' AND '))
    acc.push(whereStatement, 'UNION')

    return acc
  }, [])
  lines.pop()
  lines[lines.length - 1] += ';'
  return lines
}

function handleConjunction(variable : string | Array<string | string[]>) : [string, string[]] | string {
  // @ts-ignore
  return variable.includes(',') || variable.includes(', ') || variable.includes(' ^ ') ? variable[0] : variable
}

function getAttributeString(charCode : string | number, table : string, schema : ParsedSchema, index : number) {
  return `${toChar(charCode)}.${getAttributeName(table, schema, index)}`
}

function toChar(charCode : string | number) {
  return String.fromCharCode(65 + +charCode)
}

function getAttributeName(table : string, schema : ParsedSchema, index : number) {
  const [[tableName, attributes]] = schema.filter(([name]) => name === table)
  return attributes[index][0]
}
