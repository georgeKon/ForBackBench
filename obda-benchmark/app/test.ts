// import fs from 'fs'
// import path from 'path'
// import OBDAconverter from 'obda-converter'

// async function run() {
//   const onto = fs.readFileSync(path.resolve('../scenarios/Vicodi/ontology.owl'), 'utf8')
//   const tgds = await OBDAconverter.convertOwlToTgd(onto)
//   fs.writeFileSync(path.resolve('../scenarios/Vicodi/dependencies.txt'), tgds.join('\n'))
//   const schema = OBDAconverter.convertTgdToSchema(tgds)
//   fs.writeFileSync(path.resolve('../scenarios/Vicodi/schema.txt'), schema.join('\n'))
//   const sql = OBDAconverter.convertSchemaToSql(schema.join('\n'), { clean: true, data: true })
//   fs.writeFileSync(path.resolve('../scenarios/Vicodi/schema.sql'), sql.join('\n'))
// }

// run()
