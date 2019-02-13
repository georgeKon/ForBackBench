import * as fs from 'fs'
import * as path from 'path'
import parser from '../grammars/tgd-grammar'

const defaultUri = 'http://example.com/example.owl#'

function convertTgdToOwlCmd(tgdPath, options) {
  const tgdArray = fs.readFileSync(path.resolve(tgdPath), 'utf8').split(/\r?\n/)

  const result = convertTgdToOwl(tgdArray, options)
  // console.log(result)
}

function convertTgdToOwl(tgdArray, options) {
  const parsed = tgdArray.map(tgd => parser.parse(tgd))
  const groups = parsed.reduce((acc, elem) => {
    acc[elem[0][0][0]] ? acc[elem[0][0][0]].push(elem) : acc[elem[0][0][0]] = [elem]
    return acc
  }, [])

  const xml = Object.entries(groups).map(([key, value]) => {
    // console.log(`<owl:ObjectProperty rdf:about="${defaultUri}${key}">`)
  })

  return groups
}
