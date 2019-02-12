"use strict";
exports.__esModule = true;
var fs = require("fs");
var path = require("path");
var DateTime = require('./datetime');
var Logger = /** @class */ (function () {
    function Logger(_a) {
        var _b = _a === void 0 ? { logPath: __dirname, label: '', mute: false } : _a, logPath = _b.logPath, label = _b.label, mute = _b.mute;
        var dateTime = new DateTime();
        var name = dateTime.dateTimeStamp + "-" + label + ".log";
        this.stream = fs.createWriteStream(path.resolve(logPath, name), { flags: 'a+' });
        this.mute = mute;
    }
    Logger.prototype.log = function (message, type) {
        var dateTime = new DateTime();
        var line = dateTime.timeStamp + " " + type + " " + message;
        if (!this.mute) {
            console.log(line);
        }
        this.stream.write(line);
    };
    Logger.prototype.info = function (message) {
        this.log(message, 'INFO');
    };
    Logger.prototype.error = function (message) {
        this.log(message, 'ERROR');
    };
    Logger.prototype.out = function (message) {
        this.log(message, 'OUT');
    };
    return Logger;
}());
var logger = new Logger();
logger.info('test typescript');
module.exports = Logger;
