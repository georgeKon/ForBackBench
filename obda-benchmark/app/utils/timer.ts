import Stopwatch from 'statman-stopwatch'
import DateTime from './datetime'

export default class Timer {
  private stopwatch : any

  constructor() {
    this.stopwatch = new Stopwatch()
  }

  public start() {
    this.stopwatch.start()
  }

  public stop() {
    this.stopwatch.stop()
    const datetime = new DateTime(new Date(this.stopwatch.read()))
    this.stopwatch.reset()
    return datetime.timeStamp
  }
}
