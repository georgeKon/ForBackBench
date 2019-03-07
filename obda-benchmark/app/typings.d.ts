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
  clean? : boolean
  tgd? : boolean
  logger? : ILogger
}

interface ComputeRewritingsOptions {
  query? : boolean
  logger? : ILogger
  owl? : boolean
}

interface ExecuteUcqOptions{
  format? : string 
  logger? : ILogger
  tgd? : boolean
}

interface RunBenchmarkOptions {
  format? : string
  query? : boolean
  clean? : boolean
  tgd? : boolean
  logger? : ILogger
  skip? : boolean
  owl? : boolean
}
