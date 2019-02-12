const fs = require('fs')
const path = require('path')
const Logger = require('./drivers/logger')

function parseConfig(configPath) {
  const configObj = JSON.parse(fs.readFileSync(path.resolve(configPath), 'utf-8'))
  return configObj
}

function printMessage(message) {
  console.log(`---${message}---`)
}

module.exports = {
  parseConfig,
  printMessage
}
