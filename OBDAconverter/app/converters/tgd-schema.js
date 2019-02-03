const fs = require('fs')
const path = require('path')
const parser = require('../grammars/tgd-grammar')

const defaultType = 'STRING'

function convertTgdToSchemaCmd(tgdPath, options) {
  console.log(tgdPath)
  const tgdArray = fs.readFileSync(path.resolve(tgdPath), 'utf8').split(/\r?\n/)

  const result = convertTgdToSchema(tgdArray, options)
  console.log(result)
}

function convertTgdToSchema(tgdArray, options) {
  const names = new Set()
  const relations = tgdArray.map(line => parser.parse(line))
    .reduce((acc, tgd) => {
    // ignore tgds with more than 1 atom on the left
    if(tgd[0].length > 1) return acc
    const leftName = tgd[0][0][0]
    if(!names.has(leftName)) {
      let relation = [`${leftName} {`, ...(Array(tgd[0][0][1].length).fill().map((_, i) => `\tc${i} : ${defaultType}`)), '}']
      names.add(leftName)
      acc.push(relation)
    }
    tgd[1].forEach(atom => {
      if(atom[1] === ', ') atom = atom[0]
      const name = atom[0]
      if(!names.has(name)) {
        relation = [`${name} {`, ...(Array(atom[1].length).fill().map((_, i) => `\tc${i} : ${defaultType}`)), '}']
        names.add(name)
        acc.push(relation)
      }
    })
    return acc
  }, [])
  return relations
}

module.exports = {
  convertTgdToSchema,
  convertTgdToSchemaCmd
}
