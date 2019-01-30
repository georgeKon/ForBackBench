const fs = require('fs')
const path = require('path')
const rapidUcqParser = require('../grammars/rapid-ucq-grammar')
const iqarosUcqParser = require('../grammars/iqaros-ucq-grammar')
const schemaParser = require('../grammars/schema-grammar')

function convertUcqToSqlCmd(ucqPath, schemaPath) {
  const ucqArray = fs.readFileSync(path.resolve(ucqPath), 'utf8').split(/\r?\n/)
  const schemaString = fs.readFileSync(path.resolve(schemaPath), 'utf8')

  const sqlArray = convertUcqToSql(ucqArray, schemaString)
  console.log(sqlArray) 
}

function convertUcqToSql(ucqArray, schemaString) {
  const trimmedInput = schemaString.trim().replace(/[\s+]+/g, ' ')
  const parsedSchema = schemaParser.parse(trimmedInput)

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
    const [selection, constraints] = parsed
    const fixedSelection = selection.map(variable => handleConjunction(variable))

    // console.log(fixedSelection)

    const fixedConstraints = constraints.reduce((accum, element) => {
      const fixedElement = handleConjunction(element)
      const fixedVariables = fixedElement[1].map(variable => handleConjunction(variable))
      accum.push([fixedElement[0], fixedVariables])
      return accum
    }, [])

    // console.log(fixedConstraints)

    const selectStatement = fixedSelection.reduce((accum, elem, i) => {
      // console.log(elem)
      for(let j in fixedConstraints) {
        const [name, variables] = fixedConstraints[j]
        const idx = variables.indexOf(elem)
        if(idx > -1) {
          accum += `${getAttributeString(j, name, parsedSchema, idx)}`
          if(i < fixedSelection.length - 1) accum += ', '
          break
        }
      }
      return accum
    }, 'SELECT ')

    acc.push(selectStatement)

    let fromStatement = fixedConstraints.reduce((accum, [name], i) => {
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
              if(variable === otherVariable) accum += `${getAttributeString(j, otherName, parsedSchema, l)} = ${getAttributeString(i, name, parsedSchema, k)} AND `
            })
          } else {
            accum += `${getAttributeString(i, name, parsedSchema, k)} = '${variable}' AND `
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

function handleConjunction(variable) {
  return variable.includes(',') || variable.includes(', ') || variable.includes(' ^ ') ? variable[0] : variable
}

function getAttributeString(charCode, table, schema, index) {
  return `${toChar(charCode)}.${getAttributeName(table, schema, index)}`
}

function toChar(charCode) {
  return String.fromCharCode(65 + +charCode)
}

function getAttributeName(table, schema, index) {
  const [[tableName, attributes]] = schema.filter(([name]) => name === table)
  return attributes[index][0]
}

module.exports = {
  convertUcqToSql,
  convertUcqToSqlCmd
}
