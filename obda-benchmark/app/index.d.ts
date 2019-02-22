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
}

interface ITimer {
  
}

interface SchemaSqlOptions {
  clean? : boolean
}

interface TgdSchemaOptions {

}

type TgdSqlOptions = TgdSchemaOptions | SchemaSqlOptions

interface UcqSqlOptions {
  format: string
}

interface SparqlQueryOptions {

}

interface TgdOwlOptions {

}

interface OwlTgdOptions {
  
}

interface LoadDataOptions {
  clean? : boolean
  tgd? : boolean
  logger? : ILogger
}

interface ComputeRewritingsOptions {
  common? : boolean
  logger? : ILogger
}

interface ExecuteUcqOptions{
  format? : string 
  logger? : ILogger
}

interface RunBenchmarkOptions {
  format? : string
  common? : boolean
  clean? : boolean
  tgd? : boolean
  logger? : ILogger
}
