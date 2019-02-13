import { Client, QueryConfig } from 'pg'
import Logger from './logger'

class DB {
  private logger : Logger
  private connection : Client | null
  private transaction : Boolean

  constructor(logger : Logger) {
    this.logger = logger
    this.connection = null
    this.transaction = false
  }

  public async connect() {
    try {
      this.logger.info('Open database connection')

      const client = new Client()
      await client.connect()
      this.connection = client
      
      this.logger.info('Database connection open')
    } catch(err) {
      this.logger.error('Failed to open database connection')
      throw err
    }
  }

  public async transact() {
    if (this.connection) {
      this.transaction = true
      await this.connection.query('BEGIN;')

      this.logger.info('Begin database transaction')
    } else {
      throw new Error('Cannot begin transaction - No open database connection')
    }
  }

  public async commit() {
    if (this.connection) {
      await this.connection.query('COMMIT;')
      this.transaction = false

      this.logger.info('Commit database transaction')
    } else {
      throw new Error('Cannot commit transction - No open database connection')
    }
  }

  public async abort() {
    if (this.connection) {
      await this.connection.query('ABORT;')
      this.transaction = false

      this.logger.info('Abort database transaction')
    } else {
      throw new Error('Cannot abort transction - No open database connection')
    }
  }

  public async query(query : string | QueryConfig) {
    if (this.connection) {
      this.logger.info('Run database query')
      return this.connection.query(query)
    } else {
      throw new Error('Cannot perform query - No open database connection')
    }
  }

  public async close() {
    if (this.connection) {
      if(this.transaction) {
        await this.abort()
      }
      
      await this.connection.end()
      this.logger.info('Close database connection')
    } else {
      throw new Error('Cannot close connection - No open database connection')
    }
  }
}

module.exports = DB
