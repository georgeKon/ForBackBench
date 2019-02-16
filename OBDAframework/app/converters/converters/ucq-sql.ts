import rapidUcqParser from '../grammars/rapid-ucq-grammar'
import iqarosUcqParser from '../grammars/iqaros-ucq-grammar'
import schemaParser from '../grammars/schema-grammar'

export function convertUcqToSql(ucqArray : string[], schemaString : string, options : UcqSqlOptions) {
  const trimmedInput = schemaString.trim().replace(/[\s+]+/g, ' ')
  const parsedSchema = schemaParser.parse(trimmedInput) as ParsedSchema

  const lines = ucqArray.reduce((acc : string[], elem) => {
    let parsed
    if(options.format === 'rapid') {
      try {
        parsed = rapidUcqParser.parse(elem)
      } catch(err) {
        console.error('Cannot parse UCQ with format \'rapid\'')
      }
    } else if(options.format === 'iqaros') {
      try {
        parsed = iqarosUcqParser.parse(elem)
      } catch(err) {
        console.error('Cannot parse UCQ with format \'iqaros\'')
      }
    } else {
      throw new Error(`Unknown UCQ format '${options.format}'`)
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
          if((options.format === 'rapid' && variable.charAt(0) === '?')
            || (!(options.format === 'rapid') && variable.charAt(0) === 'X')) {
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
