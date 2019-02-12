const Logger = require('./utils/logger')
const DB = require('./utils/db')


async function loadDataCmd() {
  const logger = new Logger({ label: 'DockerLoad', logPath: './logs' })
  try {
    const db = new DB()
    await loadData(db, logger)
    await db.close()
  } catch(err) {
    logger.error(err.message)
  }
}

async function loadData(db, logger) {
  console.log(db)
  try {
    await db.transact()
    await db.query({
      text: 'DROP TABLE IF EXISTS "AdministrativeStaff";CREATE TABLE "AdministrativeStaff" (c0 text);'
    })
    await db.commit()
    logger.info('Schema import committed')
  } catch(err) {
    db.abort()
    throw new Error(err)
  }
}

loadDataCmd()
