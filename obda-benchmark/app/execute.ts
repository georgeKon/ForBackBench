/* tslint-disable no-unused-expressions */

import OBDAconverter from 'obda-converter'
import DB from './utils/db'

export default async function executeUcq(ucqArray : string[], schema : string, db : DB, options? : ExecuteUcqOptions) {
  console.log('Entering executeUcq')

  if(options === undefined) {
    options = { }
  }

  if(options.format === undefined) {
    options.format = 'rapid'
  }
  const { format, logger } = options

  const schemaString = schema.trim().replace(/[\s+]+/g, ' ')
  const query = OBDAconverter.convertUcqToSql(ucqArray, schemaString, { format })

  logger && logger.info('Execute SQL query')
  const result = await db.query(query.join('\n'))
  logger && logger.info('Rows returned: ' + result.rowCount)
  result.rows.forEach(row => {
    console.log(JSON.stringify(row))
  })

  return result
}
