class DateTime {
  constructor(date = new Date()) {
    this.date = date
  }

  get dateTimeStamp() {
    return `${this.dateStamp}-${this.timeStamp}`
  }

  get dateStamp() {
    return `${this.date.getFullYear()}-${this.date.getMonth()}-${this.date.getDate()}`
  }

  get timeStamp() {
    return `${this.date.getHours()}:${this.date.getMinutes()}:${this.date.getSeconds()}:${this.date.getMilliseconds()}`
  }
}

module.exports = DateTime
