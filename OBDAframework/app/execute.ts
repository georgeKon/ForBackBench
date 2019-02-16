/* tslint-disable no-unused-expressions */

import DB from './utils/db'
import OBDAconverter from './utils/converter'

export default async function executeUcq(ucqArray : string[], schema : string, db : DB, options? : ExecuteUcqOptions) {
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

  return result
}
