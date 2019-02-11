const fs = require('fs')
const path = require('path')

class Logger {
  constructor(label, { mute = false, logPath }) {
    const name = `${getDateTimeStamp()}-${label}.log`
    this.stream = fs.createWriteStream(path.resolve(logPath ? logPath : __dirname, name), { flags: 'a+' })
    this.mute = mute
  }

  info(message) {
    this.log(message, 'INFO')
  }

  error(message) {
    this.log(message, 'ERROR')
  }

  output(message) {
    this.log(message, 'OUT')
  }

  log(message, type) {
    const time = getDateStamp()
    const line = `${time} ${type} ${message}`
    if(!this.mute) {
      console.log(line)
    } 
    this.stream.write(line)
  }
}

const logger = new Logger('test', { logPath: 'logs', mute: false })
logger.info('TEST')

function getDateTimeStamp(date = new Date()) {
  return `${getDateStamp(date)}-${getTimeStamp(date)}`
}

function getDateStamp(date = new Date()) {
  return `${date.getFullYear()}-${date.getMonth()}-${date.getDate()}`
}

function getTimeStamp(date = new Date()) {
  return `${date.getHours()}:${date.getMinutes()}:${date.getSeconds()}:${date.getMilliseconds()}`
}