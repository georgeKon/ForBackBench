import * as fs from 'fs'
import * as path from 'path'
import DateTime from './datetime'

class Logger {
  private stream : any
  private mute : Boolean

  constructor({ logPath, label, mute } = { logPath: __dirname, label: '', mute: false}) {
    const dateTime = new DateTime()
    const name = `${dateTime.dateTimeStamp}-${label}.log`
    this.stream = fs.createWriteStream(path.resolve(logPath, name), { flags: 'a+' })
    this.mute = mute
  }

  public log(message : String, type : String) : void {
    const dateTime = new DateTime()
    const line = `${dateTime.timeStamp} ${type} ${message}`
    if(!this.mute) {
      console.log(line)
    } 
    this.stream.write(line)
  }

  public info(message : String) : void {
    this.log(message, 'INFO')
  }

  public error(message : String) : void {
    this.log(message, 'ERROR')
  }

  public out(message : String) : void {
    this.log(message, 'OUT')
  }
}

export default Logger

const logger = new Logger()
logger.info('test typescript')
