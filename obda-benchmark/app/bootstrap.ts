import fs from 'fs'
import path from 'path'
import OBDAconverter from 'obda-converter'
import { copyFile, readFile, readFileSync, writeFile, readdir, exists, mkdir } from './utils/filesystem'
import writeLlunaticConfig from './llunatic';

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

export async function createSparqlQueries(queryFolder : string, outFolder : string) {
  const queryFiles = (await readdir(queryFolder)).filter(file => path.extname(file) === '.txt')

  return Promise.all(queryFiles.map(async (queryFile) => {
    const query = (await readFile(path.resolve(queryFolder, queryFile))).trim()
    const sparql = OBDAconverter.convertQueryToSparql(query)

    return writeFile(path.resolve(outFolder, queryFile.replace('.txt', '.rq')), sparql)
  }))
}

export async function createTargetDependencies(ontologyPath : string, outPath : string) {
  const ontology = await readFile(ontologyPath)
  const dependencies = (await OBDAconverter.convertOwlToTgd(ontology)).join('\n')

  return writeFile(outPath, dependencies)
}

export async function createRuleQueries(baseFolder : string) {
  fs.mkdirSync(path.resolve(baseFolder, 'queries/RDFox'))
  fs.mkdirSync(path.resolve(baseFolder, 'queries/graal'))
  fs.mkdirSync(path.resolve(baseFolder, 'queries/iqaros'))

  const queryFiles = (await readdir(path.resolve(baseFolder, 'queries'))).filter(file => path.extname(file) === '.rq')

  await Promise.all(queryFiles.map(async (queryFile, i) => {
    const sparql = (await readFile(path.resolve(baseFolder, 'queries', queryFile))).trim()
    const query = OBDAconverter.convertSparqlToQuery(sparql, { num: (i + 1) })

    fs.writeFileSync(path.resolve(baseFolder, 'queries/iqaros', queryFile.replace('.rq', '.txt')), query.replace(' .', '').replace(/^Q[0-9]/, 'Q'))
    fs.renameSync(path.resolve(baseFolder, 'queries', queryFile), path.resolve(baseFolder, 'queries/graal', queryFile))

    fs.mkdirSync(path.resolve(baseFolder, 'queries/RDFox', path.basename(queryFile, '.rq')))
    return writeFile(path.resolve(baseFolder, 'queries/RDFox', path.basename(queryFile, '.rq') , queryFile.replace('.rq', '.txt')), query)
  }))
}

export async function createLLunaticConfigs(baseFolder : string, sizes : string[]) {
  const queryFolders = await readdir(path.resolve(baseFolder, 'queries/RDFox'))
  queryFolders.forEach(folder => {
    sizes.forEach(size => writeLlunaticConfig(baseFolder, folder, size))
  })
}

export async function createQueryFolders(baseFolder : string) {
  fs.mkdirSync(path.resolve(baseFolder, 'queries/RDFox'))
  fs.mkdirSync(path.resolve(baseFolder, 'queries/graal'))
  fs.mkdirSync(path.resolve(baseFolder, 'queries/iqaros'))

  await createSparqlQueries(path.resolve(baseFolder, 'queries'), path.resolve(baseFolder, 'queries/graal'))

  const queries = (await readdir(path.resolve(baseFolder, 'queries'))).filter(file => path.extname(file) === '.txt')
  queries.forEach(file => {
    const query = fs.readFileSync(path.resolve(baseFolder, 'queries', file), 'utf8').replace(' .', '')
    fs.writeFileSync(path.resolve(baseFolder, 'queries/iqaros', file), query.replace(/^Q[0-9]/, 'Q'))
    fs.mkdirSync(path.resolve(baseFolder, 'queries/RDFox', path.basename(file, '.txt')))
    fs.renameSync(path.resolve(baseFolder, 'queries', file), path.resolve(baseFolder, 'queries/RDFox', path.basename(file, '.txt'), file))
  })
}
