const { Client } = require('pg')

class DB {
  constructor() {
    this.connection = null
    this.transaction = false
  }

  async connect() {
    const client = new Client()
    await client.connect()
    this.connection = client
  }

  async transact() {
    if (this.connection) {
      this.transaction = true
      await this.connection.query('BEGIN;')
    } else {
      throw new Error('Cannot begin transction - No open database connection')
    }
  }

  async commit() {
    if (this.connection) {
      await this.connection.query('COMMIT;')
      this.transaction = false
    } else {
      throw new Error('Cannot commit transction - No open database connection')
    }
  }

  async abort() {
    if (this.connection) {
      await this.connection.query('ABORT;')
      this.transaction = false
    } else {
      throw new Error('Cannot abort transction - No open database connection')
    }
  }

  async query(query) {
    if (this.connection) {
      return this.connection.query(query)
    } else {
      throw new Error('Cannot perform query - No open database connection')
    }
  }

  async close() {
    if (this.connection) {
      if(this.transaction) {
        await this.abort()
      }
      await this.connection.end()
    } else {
      throw new Error('Cannot close connection - No open database connection')
    }
  }
}

module.exports = DB
