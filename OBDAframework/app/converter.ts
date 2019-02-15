import { convertSchemaToSql } from './converters/converters/schema-sql'
import { convertTgdToSchema } from './converters/converters/tgd-schema'
import { convertUcqToSql } from './converters/converters/ucq-sql'
import { convertSparqlToQuery } from './converters/converters/sparql-query'
import { convertOwlToTgd } from './converters/converters/owl-tgd'
import { convertTgdToOwl } from './converters/converters/tgd-owl'

export default class OBDAconverter {
  public static convertSchemaToSql(schema : string, options? : SchemaSqlOptions) {
    return convertSchemaToSql(schema, options)
  }

  public static convertTgdToSchema(tgds : string[], options? : TgdSchemaOptions) {
    return convertTgdToSchema(tgds, options)
  }

  public static convertTgdToSql(tgds : string[], options? : TgdSqlOptions) {
    const schemaArray = this.convertTgdToSchema(tgds, options).join(' ')
    return this.convertSchemaToSql(schemaArray, options)
  }

  public static convertUcqToSql(ucq : string[], schema : string, options : UcqSqlOptions) {
    return convertUcqToSql(ucq, schema, options)
  }

  public static convertSparqlToQuery(sparql : string, options? : SparqlQueryOptions) {
    return convertSparqlToQuery(sparql, options)
  }

  public static async convertOwlToTgd(owl : string, options? : OwlTgdOptions) {
    return convertOwlToTgd(owl, options)
  }

  public static convertTgdToOwl(tgds : string[], options? : TgdOwlOptions) {
    return convertTgdToOwl(tgds, options)
  }
}
