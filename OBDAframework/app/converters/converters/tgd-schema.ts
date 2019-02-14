import * as fs from 'fs'
import * as path from 'path'
import * as parser from '../grammars/tgd-grammar'

type SingleTGD = Array<[string, string | Array<string | string[]>]>
type ParsedTGD = [SingleTGD, SingleTGD]

const defaultType = 'STRING'

// export function convertTgdToSchemaCmd(tgdPath : string, options : any) {
//   const tgdArray = fs.readFileSync(path.resolve(tgdPath), 'utf8').split(/\r?\n/)

//   const result = convertTgdToSchema(tgdArray)
//   // console.log(result)
// }

export function convertTgdToSchema(tgdArray : string[]) {
  const names = new Set()
  const relations = (tgdArray.map(line => parser.parse(line)) as ParsedTGD[])
    .reduce((acc : string[], tgd : ParsedTGD) => {
    // ignore tgds with more than 1 atom on the left
    if(tgd[0].length > 1) {
      return acc
    }
    const leftName = tgd[0][0][0]
    if(!names.has(leftName)) {
      names.add(leftName)
      const sql = createSql(leftName, tgd[0][0][1].length)
      acc.push(...sql)
    }
    tgd[1].forEach(atom => {
      // console.log(atom)
      if(atom[1] === ', ') {
        // @ts-ignore
        atom = atom[0]
      }
      const name = atom[0]
      if(!names.has(name)) {
        names.add(name)
        const sql = createSql(name, tgd[0][0][1].length)
        acc.push(...sql)
      }
    })
    return acc
  }, [])
  return relations
}

function createSql(name : string, length : number) {
  const fields = new Array(length).fill(0).map((_, i) => `\tc${i} : ${defaultType}`)
  return [`${name} {`, ...fields, '}']
}
