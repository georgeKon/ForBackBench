import fs from 'fs'
import path from 'path'
import { from as copyFrom } from 'pg-copy-streams'
import { readFileSync } from './utils/filesystem'
import Database from './utils/database'

export default async function loadData(sqlPath : string, dataPath : string, database : Database, logger : ILogger) {
  const query = readFileSync(sqlPath)

  try {
    await database.transact()
    await database.query(query)

    const files = fs.readdirSync(dataPath).filter(file => path.extname(file) === '.csv')
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
      logger.info(`Inserted ${file}`)
    }

    await database.commit()
  } catch(err) {
    database.abort()
    throw new Error(err)
  }
}
