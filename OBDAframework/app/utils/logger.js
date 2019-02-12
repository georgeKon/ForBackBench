const fs = require('fs')
const path = require('path')
const DateTime= require('./datetime')

class Logger {
  constructor({ logPath, label, mute } = { logPath: __dirname, label: '', mute: false}) {
    const dateTime = new DateTime()
    const name = `${dateTime.dateTimeStamp}-${label}.log`
    this.stream = fs.createWriteStream(path.resolve(logPath, name), { flags: 'a+' })
    this.mute = mute
  }

  log(message, type) {
    const dateTime = new DateTime()
    const line = `${dateTime.timeStamp} ${type} ${message}`
    if(!this.mute) {
      console.log(line)
    } 
    this.stream.write(line)
  }

  info(message) {
    this.log(message, 'INFO')
  }

  error(message) {
    this.log(message, 'ERROR')
  }

  out(message) {
    this.info(message, 'OUT')
  }
}

module.exports = Logger
