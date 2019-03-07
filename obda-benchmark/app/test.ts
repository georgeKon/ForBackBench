import fs from 'fs'
import path from 'path'
import OBDAconverter from 'obda-converter'

// async function run() {
//   const onto = fs.readFileSync(path.resolve('../scenarios/StockExchange/ontology (copy).owl'), 'utf8')
//   const tgds = await OBDAconverter.convertOwlToTgd(onto)
//   console.log(tgds)
// }

// run()

const schema = fs.readFileSync(path.resolve('../scenarios/Adolena/schema.txt'), 'utf8')
const sql = OBDAconverter.convertSchemaToSql(schema, { clean: true, data: true })
fs.writeFileSync(path.resolve('../scenarios/Adolena/schema.sql'), sql.join('\n'))
