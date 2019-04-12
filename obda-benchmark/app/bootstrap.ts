import fs from 'fs'
import path from 'path'
import OBDAconverter from 'obda-converter'
import { copyFile, readFile, readFileSync, writeFile, readdir, exists, mkdir } from './utils/filesystem'

export async function createSourceSchema(schemaPath : string, outPath : string) {
  // Read file and format string
  const schemaString = (await readFile(schemaPath)).trim().replace(/[\s+]+/g, ' ')
  const parsed = OBDAconverter.parseSchema(schemaString)

  const newSchema = parsed.map(([name, attributes] : [string, string[]]) => {
    return `${'src_' + name} {\n\t${attributes.map(([field, type]) => `${field} : ${type}`).join(',\n\t')}\n}`
  }).join('\n')

  return writeFile(outPath, newSchema)
}

export async function createSourceData(dataPath : string, outPath : string) {
  if(await exists(outPath) === false) {
    await mkdir(outPath)
  }

  const files = await readdir(dataPath)
  return Promise.all(files.map(filePath =>
    copyFile(path.resolve(dataPath, filePath), path.resolve(outPath, filePath.replace(path.extname(filePath), '_src.txt')))))
}

export async function createSourceTargetDependencies(schemaPath : string, outPath : string) {
  const schemaString = (await readFile(schemaPath)).trim().replace(/[\s+]+/g, ' ')
  const parsed = OBDAconverter.parseSchema(schemaString)

  const dependencies = parsed.map(([name, attributes] : [string, string[]]) => {
    const args = `${attributes.map((_, i) => `?${String.fromCharCode(88 + i)}`).join(',')}`
    return `src_${name}(${args}) -> ${name}(${args}) .`
  }).join('\n')

  return writeFile(outPath, dependencies)
}

export async function createOntology(dependenciesPath : string, outPath : string) {
  const dependencies = (await readFile(dependenciesPath)).trim().split(/\r?\n/)
  const ontology = OBDAconverter.convertTgdToOwl(dependencies)

  return writeFile(outPath, ontology)
}

export async function createTargetSchema(dependenciesPath : string, outPath : string) {
  const dependencies = (await readFile(dependenciesPath)).trim().split(/\r?\n/)
  const schema = OBDAconverter.convertTgdToSchema(dependencies).join('\n')

  return writeFile(outPath, schema)
}

export async function createSQL(schemaPath : string, outPath : string) {
  const schema = (await readFile(schemaPath)).trim().replace(/[\s+]+/g, ' ')
  const sql = OBDAconverter.convertSchemaToSql(schema, { clean: true }).join('\n')

  return writeFile(outPath, sql)
}

export async function createSparqlQueries(queryFolder : string) {
  const queryFiles = (await readdir(queryFolder)).filter(file => path.extname(file) === '.txt')

  return Promise.all(queryFiles.map(async (queryFile) => {
    const query = (await readFile(path.resolve(queryFolder, queryFile))).trim()
    const sparql = OBDAconverter.convertQueryToSparql(query)

    return writeFile(path.resolve(queryFolder, queryFile.replace('.txt', '.rq')), sparql)
  }))
}

export async function createTargetDependencies(ontologyPath : string, outPath : string) {
  const ontology = await readFile(ontologyPath)
  const dependencies = (await OBDAconverter.convertOwlToTgd(ontology)).join('\n')

  return writeFile(outPath, dependencies)
}

export async function createRuleQueries(queryFolder : string) {
  const queryFiles = (await readdir(queryFolder)).filter(file => path.extname(file) === '.rq')

  return Promise.all(queryFiles.map(async (queryFile, i) => {
    const sparql = (await readFile(path.resolve(queryFolder, queryFile))).trim()
    const query = OBDAconverter.convertSparqlToQuery(sparql, { num: (i + 1) })

    return writeFile(path.resolve(queryFolder, queryFile.replace('.rq', '.txt')), query)
  }))
}
