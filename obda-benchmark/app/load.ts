import fs from 'fs'
import path from 'path'
import { from as copyFrom } from 'pg-copy-streams'
import { readFileSync } from './utils/filesystem'
import Database from './utils/database'

export default async function loadData(sqlPath : string, dataPath : string, database : Database) {
  const query = readFileSync(sqlPath)

  try {
    await database.transact()
    await database.query(query)

    const files = fs.readdirSync(dataPath)
      .filter(file => path.extname(file) === '.csv')
    // For of loop because promises don't work in forEach
    for(const file of files) {
      const fileStream = fs.createReadStream(path.resolve(dataPath, file))
      const stream = await database.query(copyFrom(`COPY "${path.parse(file).name}" FROM STDIN DELIMITER ','`)) as any
      fileStream.pipe(stream)
      const promise = new Promise((resolve, reject) => {
        stream.on('end', () => resolve())
        stream.on('error', () => reject())
      })
      await promise
    }

    await database.commit()
  } catch(err) {
    database.abort()
    throw new Error(err)
  }
}

/* eslint-disable no-unused-expressions */

// import fs from 'fs'
// import path from 'path'
// // import OBDAconverter from 'obda-converter'
// import { from as copyFrom } from 'pg-copy-streams'
// import DB from './utils/db'
// import Timer from './utils/timer'

// const timer = new Timer()

// export default async function loadData(
//     schemaPath : string, dataPath : string, db : DB, { logger, verbose } : LoadDataOptions) {

//   // we need to read the schema, and the sql, and then import the data into the database
//   let schema : string
//   let query : string

//   try {
//     schemaPath = path.resolve(schemaPath)
//     schema = fs.readFileSync(schemaPath, 'utf8')
//     // FIXME: We are assuming the file name here
//     const sqlPath = schemaPath.replace('.txt', '.sql')
//     query = fs.readFileSync(sqlPath, 'utf8')
//     // if(tgd) {
//     //   logger && logger.info('Option TGD: converting TGDs to Schema before SQL')
//     //   timer.start()
//     //   query = OBDAconverter.convertTgdToSql(schema.split(/\r?\n/), { clean })
//     // } else {
//     //   timer.start()
//     //   query = OBDAconverter.convertSchemaToSql(schema, { clean })
//     // }
//     // logger && logger.pass('Schema converted successfully', timer.stop())
//     // fs.writeFileSync(sqlPath, query)
//     // logger && logger.info('SQL written to ' + sqlPath)
//   } catch(err) {
//     logger && logger.error(err.message)
//     throw new Error(err)
//   }

//   try {
//     await db.transact()
//     logger && logger.info('Begin schema import')
//     timer.start()
//     await db.query(query)
//     logger && logger.pass('Schema import complete', timer.stop())

//     const files = fs.readdirSync(path.resolve(dataPath))
//       .filter(file => path.extname(file) === '.csv')

//     logger && logger.info('Begin data import')
//     timer.start()
//     // For of loop because promises don't work in forEach
//     for(const file of files) {
//       logger && verbose && logger.info(`Import ${file}`)
//       const fileStream = fs.createReadStream(path.resolve(dataPath, file))
//       const stream = await db.query(copyFrom(`COPY "${path.parse(file).name}" FROM STDIN DELIMITER ','`)) as any
//       fileStream.pipe(stream)
//       const promise = new Promise((resolve, reject) => {
//         stream.on('end', () => resolve())
//         stream.on('error', () => reject())
//       })
//       await promise
//       logger && verbose && logger.pass(`${file} imported`)
//     }
//     logger && logger.pass('Data import complete', timer.stop())
//     await db.commit()
//   } catch(err) {
//     logger && logger.error(err.message)
//     db.abort()
//     throw new Error(err)
//   }
//   return schema
// }
