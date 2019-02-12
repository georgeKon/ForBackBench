import * as fs from 'fs'
import * as path from 'path'
import DateTime from './datetime'

class Logger {
  constructor({ logPath, label, mute } = { logPath: __dirname, label: '', mute: false}) {
    const dateTime = new DateTime()
    const name = `${dateTime.dateTimeStamp}-${label}.log`
    this.stream = fs.createWriteStream(path.resolve(logPath, name), { flags: 'a+' })
    this.mute = mute
  }

  log(message : String, type : String) {
    const dateTime = new DateTime()
    const line = `${dateTime.timeStamp} ${type} ${message}`
    if(!this.mute) {
      console.log(line)
    } 
    this.stream.write(line)
  }

  info(message : String) {
    this.log(message, 'INFO')
  }

  error(message : String) {
    this.log(message, 'ERROR')
  }

  out(message : String) {
    this.log(message, 'OUT')
  }
}

interface Logger {
  mute : Boolean
  stream : any
}

const logger = new Logger()
logger.info('test typescript')
