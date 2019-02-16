/* tslint-disable no-unused-expressions */

import DB from './utils/db'
import OBDAconverter from './utils/converter'

export async function executeUcq(ucqArray : string[], schema : string, db : DB, options : ExecuteUcqOptions) {
  const { format, logger } = options

  const schemaString = schema.trim().replace(/[\s+]+/g, ' ')
  const query = OBDAconverter.convertUcqToSql(ucqArray, schemaString, { format })

  logger && logger.info('Execute SQL query')
  const result = await db.query(query.join('\n'))
  logger && logger.info('Rows returned: ' + result.rowCount)

  return result
}
