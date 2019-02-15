import Logger from './utils/logger'
import DB from './utils/db'
import { loadData } from './load'

export async function loadDataCmd(schemaPath : string, dataPath : string, options? : LoadDataOptions) {
  const logger = new Logger('load', './logs')
  const db = new DB(logger)

  // await db.connect()

  if(!options) {
    options = { }
  }

  if(!options.clean) {
    options.clean = false
  }

  if(!options.tgd) {
    options.tgd = false
  }

  loadData(schemaPath, dataPath, db, options)
}
