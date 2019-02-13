import * as fs from 'fs'
import * as path from 'path'
import rapidUcqParser from '../grammars/rapid-ucq-grammar'
import iqarosUcqParser from '../grammars/iqaros-ucq-grammar'
import schemaParser from '../grammars/schema-grammar'

export function convertUcqToSqlCmd(ucqPath : string, schemaPath : string) {
  const ucqArray = fs.readFileSync(path.resolve(ucqPath), 'utf8').split(/\r?\n/)
  const schemaString = fs.readFileSync(path.resolve(schemaPath), 'utf8')

  const sqlArray = convertUcqToSql(ucqArray, schemaString)
  console.log(sqlArray)
}

export function convertUcqToSql(ucqArray : string[], schemaString : string) {
  const trimmedInput = schemaString.trim().replace(/[\s+]+/g, ' ')
  const parsedSchema = schemaParser.parse(trimmedInput) as ParsedSchema

  const lines = ucqArray.reduce((acc, elem, index) => {
    let parsed
    try {
      parsed = rapidUcqParser.parse(elem)
    } catch(err) {
      console.error(err)
      try {
        parsed = iqarosUcqParser.parse(elem)
      } catch(err) {
        console.error('Error parsing UCQ')
        console.error(err)
      }
    }
    console.log(JSON.stringify(parsed))
    const [selection, constraints] = parsed as ParsedUCQ
    const fixedSelection = selection.map(variable => handleConjunction(variable))

    // console.log(fixedSelection)

    const fixedConstraints = constraints.reduce((accum, element) => {
      const fixedElement = handleConjunction(element)
      const fixedVariables = fixedElement[1].map(variable => handleConjunction(variable))
      accum.push([fixedElement[0], fixedVariables])
      return accum
    }, [])

    // console.log(fixedConstraints)

    const selectStatement = fixedSelection.reduce((accum : string, elem, i : number) => {
      // console.log(elem)
      for(const j in fixedConstraints) {
        if(fixedConstraints.hasOwnProperty(j)) {
          const [name, variables] = fixedConstraints[j]
          const idx = variables.indexOf(elem)
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

    let fromStatement = fixedConstraints.reduce((accum : string, [ name ] : string[], i : number) => {
      accum += `"${name}" as ${toChar(i)}, `
      return accum
    }, 'FROM ')

    fromStatement = fromStatement.substring(0, fromStatement.lastIndexOf(', '))
    acc.push(fromStatement)

    let whereStatement = fixedConstraints.reduce((accum, [name, variables], i) => {
      fixedConstraints.forEach(([otherName, otherVariables], j) => {
        if(i === j) return
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

function handleConjunction(variable : string | string[]) : string {
  return typeof variable === 'string' ? variable : variable[0]
  // return variable.includes(',') || variable.includes(', ') || variable.includes(' ^ ') ? variable[0] : variable
}

function getAttributeString(charCode : string | number, table : string, schema : ParsedSchema, index : number) {
  return `${toChar(charCode)}.${getAttributeName(table, schema, index)}`
}

function toChar(charCode : string | number) {
  return String.fromCharCode(65 + +charCode)
}

function getAttributeName(table : string, schema : ParsedSchema, index : number) {
  const [[tableName, attributes]] = schema.filter(([name] : string[]) => name === table)
  return attributes[index][0]
}
