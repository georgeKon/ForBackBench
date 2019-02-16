declare module 'pg-copy-streams' {
  export const to : any
  export const from : any
}

interface ILogger {
  log : (message : string, type : string) => void
  info : (message : string) => void
  error : (message : string) => void
  out : (message : string) => void
  warn : (message : string) => void
  pass : (message : string) => void
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
