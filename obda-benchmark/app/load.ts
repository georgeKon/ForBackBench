/* eslint-disable no-unused-expressions */

import fs from 'fs'
import path from 'path'
import OBDAconverter from 'obda-converter'
import { from as copyFrom } from 'pg-copy-streams'
import DB from './utils/db'
import Timer from './utils/timer'
// import { readFileSync } from './utils/filesystem'

const timer = new Timer()

export default async function loadData(
    schemaPath : string, dataPath : string, db : DB, { clean, logger, tgd } : LoadDataOptions) {

  let schema : string
  let query : string[]

  try {
    schemaPath = path.resolve(schemaPath)
    schema = fs.readFileSync(schemaPath, 'utf8')

    query = tgd
      ? OBDAconverter.convertTgdToSql(schema.split(/\r?\n/), { clean })
      : OBDAconverter.convertSchemaToSql(schema, { clean })

    const sqlPath = schemaPath.replace('.txt', '.sql')
    fs.writeFileSync(sqlPath, query)
    logger && logger.info('SQL written to ' + sqlPath)
  } catch(err) {
    logger && logger.error(err.message)
    throw new Error(err)
  }

  try {
    await db.transact()
    logger && logger.info('Begin schema import')
    timer.start()
    await db.query(query.join('\n'))
    logger && logger.pass('Schema import complete', timer.stop())

    const files = fs.readdirSync(path.resolve(dataPath))
      .filter(file => path.extname(file) === '.csv')

    logger && logger.info('Begin data import')
    timer.start()
    // For of loop because promises don't work in forEach
    for(const file of files) {
      logger && logger.info(`Import ${file}`)
      const fileStream = fs.createReadStream(path.resolve(dataPath, file))
      const stream = await db.query(copyFrom(`COPY "${path.parse(file).name}" FROM STDIN DELIMITER ','`)) as any
      fileStream.pipe(stream)
      const promise = new Promise((resolve, reject) => {
        stream.on('end', () => resolve())
        stream.on('error', () => reject())
      })
      await promise
      logger && logger.pass(`${file} imported`)
    }
    logger && logger.pass('Data import complete', timer.stop())
    await db.commit()
  } catch(err) {
    logger && logger.error(err.message)
    db.abort()
    throw new Error(err)
  }
  return schema
}
