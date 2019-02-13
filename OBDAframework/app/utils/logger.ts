import * as fs from 'fs'
import * as path from 'path'
import DateTime from './datetime'

export default class Logger {
  private stream : any
  private mute : boolean

  constructor(label? : string, logPath? : string, mute? : boolean) {
    const dateTime = new DateTime()
    const name = `${dateTime.dateTimeStamp}-${label ? label : 'run'}.log`
    this.stream = fs.createWriteStream(path.resolve(logPath ? logPath : __dirname, name), { flags: 'a+' })
    this.mute = mute ? mute : false
  }

  public log(message : string, type : string) : void {
    const dateTime = new DateTime()
    const line = `${dateTime.timeStamp} ${type} ${message}`
    if(!this.mute) {
      /* tslint:disable */
      console.log(line)
      /* tslint:enable */
    }
    this.stream.write(line + '\n')
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
