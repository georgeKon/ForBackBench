import { Client, QueryConfig } from 'pg'
import Logger from './logger'

export default class Database {
  private logger : Logger
  private connection : Client | null
  private transaction : boolean

  constructor(logger : Logger) {
    this.logger = logger
    this.connection = null
    this.transaction = false
  }

  public async connect() {
    try {
      this.logger.info(`Opening connection to database '${process.env.PGDATABASE}'`)

      const client = new Client()
      await client.connect()
      this.connection = client

      this.logger.info('Database connection opened')
    } catch(err) {
      throw new Error('Failed to open database connection: ' + err.message)
    }
  }

  public async transact() {
    if (this.connection) {
      this.transaction = true
      await this.connection.query('BEGIN;')

      this.logger.info('Database transaction opened')
    } else {
      throw new Error('Cannot begin transaction - No open database connection')
    }
  }

  public async commit() {
    if (this.connection) {
      await this.connection.query('COMMIT;')
      this.transaction = false

      this.logger.info('Committed changes to database')
    } else {
      throw new Error('Cannot commit transction - No open database connection')
    }
  }

  public async abort() {
    if (this.connection) {
      if(this.transaction) {
        await this.connection.query('ABORT;')
        this.transaction = false
        this.logger.info('Aborted changes to database')
      } else {
        this.logger.warn('Cannot abort transaction - No current transaction')
      }
    } else {
      throw new Error('Cannot abort transction - No open database connection')
    }
  }

  public async query(query : string | QueryConfig) {
    if (this.connection) {
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
      this.logger.info('Database connection closed')
    } else {
      this.logger.info('No need to close connection - No open database connection')
    }
  }
}
