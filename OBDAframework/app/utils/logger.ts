import * as fs from 'fs'
import * as path from 'path'
import DateTime from './datetime'

interface LoggerOptions {
  label? : string
  logPath? : string
  mute? : boolean
}

export default class Logger {
  private stream : any
  private mute : boolean

  constructor({ label, logPath, mute } : LoggerOptions) {
    const dateTime = new DateTime()
    const name = `${dateTime.dateTimeStamp}-${label ? label : ''}.log`
    this.stream = fs.createWriteStream(path.resolve(logPath ? logPath : __dirname, name), { flags: 'a+' })
    this.mute = mute ? mute : false
  }

  public log(message : string, type : string) : void {
    const dateTime = new DateTime()
    const line = `${dateTime.timeStamp} ${type} ${message}`
    if(!this.mute) {
      console.log(line)
    }
    this.stream.write(line)
  }

  public info(message : string) : void {
    this.log(message, 'INFO')
  }

  public error(message : string) : void {
    this.log(message, 'ERROR')
  }

  public out(message : string) : void {
    this.log(message, 'OUT')
  }

  public warn(message : string) : void {
    this.log(message, 'WARN')
  }

  public pass(message : string) : void {
    this.log(message, 'PASS')
  }
}
