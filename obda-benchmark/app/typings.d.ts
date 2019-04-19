declare module 'pg-copy-streams' {
  export const to : any
  export const from : any
}

declare module 'obda-converter' {
  const value : any
  export default value
}

declare module 'statman-stopwatch' {
  const value : any
  export default value
}

declare module 'xml-writer' {
  const value : any
  export default value
}

interface ILogger {
  log : (message : string, type : string, time? : string) => void
  info : (message : string) => void
  error : (message : string) => void
  out : (message : string) => void
  warn : (message : string) => void
  pass : (message : string, time? : string) => void
  title : (message : string) => void
}

interface ITimer {
  
}

interface LoadDataOptions {
  logger? : ILogger
  verbose? : boolean
}

interface ComputeRewritingsOptions {
  logger? : ILogger
}

interface ExecuteUcqOptions{
  format? : string 
  logger? : ILogger
}

interface RunBenchmarkOptions {
  format? : string
  logger? : ILogger
  skip? : boolean
  verbose? : boolean
}
