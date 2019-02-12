const { Client } = require('pg')

class DB {
  constructor({ autoOpen = true }) {
    this.connection = null
    if (autoOpen) {
      this.connect()
    }
  }

  async connect() {
    const client = new Client()
    await client.connect()
    this.connection = client
  }

  async transact() {
    if (!this.connection) {
      this.connection.query('BEGIN;')
    }
  }

  async commit() {
    if (!this.connection) {
      this.connection.query('COMMIT;')
    }
  }

  async abort() {
    if (!this.connection) {
      this.connection.query('ABORT;')
    }
  }

  async query(query) {
    if (!this.connection) {
      return this.connection.query(query)
    }
  }

  async close() {
    if (!this.connection) {
      this.abort()
      this.connection.end()
    }
  }
}

module.exports = DB
