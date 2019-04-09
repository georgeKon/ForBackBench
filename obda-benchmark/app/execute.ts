/* tslint-disable no-unused-expressions */

import OBDAconverter from 'obda-converter'
import DB from './utils/database'
import Timer from './utils/timer'

const timer = new Timer()

export default async function executeUcq(ucqArray : string[], schema : string, db : DB, options : ExecuteUcqOptions) {

  if(options === undefined) {
    options = { }
  }

  if(options.format === undefined) {
    throw new Error('No UCQ format specified')
  }
  const { format, logger } = options
  try {
    // let schemaString
    // // FIXME: This is a real hack that repeats work that we have already done
    // if(tgd) {
    //   schemaString = OBDAconverter.convertTgdToSchema(schema.split(/\r?\n/)).join('\n')
    // } else {
    //   schemaString = schema.trim().replace(/[\s+]+/g, ' ')
    // }
    const schemaString = schema.trim().replace(/[\s+]+/g, ' ')
    timer.start()
    const query = OBDAconverter.convertUcqToSql(ucqArray, schemaString, { format })
    logger && logger.pass('Query convetered successfully', timer.stop())
    const result = await db.query(query.join('\n'))
    return result
  } catch(err) {
    logger && logger.error(err.message)
    throw new Error(err)
  }
}
