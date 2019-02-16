import * as parser from '../grammars/tgd-grammar'

const defaultType = 'STRING'

export function convertTgdToSchema(tgdArray : string[], options? : TgdSchemaOptions) {
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
      if(atom[1] === ', ') {
        // @ts-ignore
        atom = atom[0]
      }
      const name = atom[0]
      if(!names.has(name)) {
        names.add(name)
        const sql = createSql(name, atom[1].length)
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
