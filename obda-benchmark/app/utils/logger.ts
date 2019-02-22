import * as fs from 'fs'
import * as path from 'path'
import DateTime from './datetime'

export default class Logger implements ILogger {
  private writePath : string
  private mute : boolean

  constructor(label? : string, logPath? : string, mute? : boolean) {
    const dateTime = new DateTime()
    const name = `${dateTime.dateTimeStamp}-${label ? label : 'run'}.log`
    this.mute = mute ? mute : false
    this.writePath = path.resolve(logPath ? logPath : __dirname, name)
  }

  public log(message : string, type : string, time? : string) : void {
    const dateTime = new DateTime()
    const line = `${dateTime.timeStamp} ${type} ${message} ${time ? `in ${time}` : ''}`
    if(!this.mute) {
      /* tslint:disable */
      console.log(line)
      /* tslint:enable */
      fs.appendFileSync(this.writePath, line + '\n')
    }
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

  public pass(message : string, time? : string) : void {
    this.log(message, 'PASS', time)
  }
}
