import fs from 'fs'
import path from 'path'
import XMLWriter from 'xml-writer'

export default function writeLlunaticConfig(baseFolder : string, query : string, size : string) {
  writeDefaultLlunaticConfig(baseFolder, query, size)
  writeBCALlunaticConfig(baseFolder, query, size)
}

function writeDefaultLlunaticConfig(baseFolder : string, query : string, size : string) {
  const writer = new XMLWriter(true)
  writer.startDocument()
  writer.startElement('scenario')

  writeSourceConfig(writer, baseFolder, size)

  writeTargetConfig(writer, baseFolder)

  writeExportConfig(writer, baseFolder, size, query)

  writeDependenciesConfig(writer, baseFolder)

  writeQueriesConfig(writer, baseFolder, query)

  writer.endDocument()

  fs.writeFileSync(path.resolve(baseFolder, 'queries/RDFox/', `${query}/${size}.xml`), writer.toString())
}

function writeBCALlunaticConfig(baseFolder : string, query : string, size : string) {
  const writer = new XMLWriter(true)
  writer.startDocument()
  writer.startElement('scenario')

  writeSourceConfig(writer, baseFolder, size)

  writeTargetConfig(writer, baseFolder)

  writeExportConfig(writer, baseFolder, size, query)

  writeBCADependenciesConfig(writer, baseFolder, query)

  writeQueriesConfig(writer, baseFolder, query)

  writer.endDocument()

  fs.writeFileSync(path.resolve(baseFolder, 'queries/RDFox/', `${query}/${size}-bca.xml`), writer.toString())
}

function writeSourceConfig(writer : any, baseFolder : string, size : string) {
  writer.startElement('source')

  writeAccessConfig(writer, 'source')

  writer.startElement('schemaFile')
  writer.writeAttribute('schema', 'source')
  writer.text(path.resolve(baseFolder, 'schema/s-schema.txt'))
  writer.endElement()

  writer.startElement('import')
  fs.readdirSync(path.resolve(baseFolder, 'data', size)).filter(file => path.extname(file) === '.csv').forEach(file => {
    writer.startElement('input')
    writer.writeAttribute('type', 'csv')
    writer.writeAttribute('separator', ',')
    writer.writeAttribute('hasHeader', 'false')
    writer.writeAttribute('table', path.basename(file, '.csv').toLowerCase())
    writer.text(path.resolve(baseFolder, 'data', size, file))
    writer.endElement()
  })
  writer.endElement()

  writer.endElement()
}

function writeTargetConfig(writer : any, baseFolder : string) {
  writer.startElement('target')

  writer.writeElement('generateFromDependencies', 'true')

  writeAccessConfig(writer, 'target')

  writer.startElement('schemaFile')
  writer.writeAttribute('schema', 'target')
  writer.text(path.resolve(baseFolder, 'schema/t-schema.txt'))
  writer.endElement()

  writer.endElement()
}

function writeAccessConfig(writer : any, schema : string) {
  writer.writeElement('type', 'DBMS')

  writer.startElement('access-configuration')
  writer.writeElement('driver', 'org.postgresql.Driver')
  writer.writeElement('uri', `jdbc:postgresql:${process.env.PGDATABASE}_llunatic`)
  writer.writeElement('schema', schema)
  writer.writeElement('login', process.env.PGUSER)
  writer.writeElement('password', process.env.PGPASSWORD)
  writer.endElement()
}

function writeExportConfig(writer : any, baseFolder : string, size : string, query : string) {
  writer.startElement('configuration')

  writer.writeElement('printResults', 'true')
  writer.writeElement('exportQueryResults', 'true')
  writer.writeElement('exportQueryResultsPath', path.resolve(baseFolder, 'out', size, query, ))
  writer.writeElement('exportQueryResultsType', 'CSV')
  writer.writeElement('exportSolutions', 'true')
  writer.writeElement('exportQueryResults', 'true')
  writer.writeElement('exportSolutionsPath', path.resolve(baseFolder, 'out', size, query, ))
  writer.writeElement('exportSolutionsType', 'CSV')

  writer.endElement()
}

function writeDependenciesConfig(writer : any, baseFolder : string) {
  writer.startElement('dependencies')

  writer.writeElement('sttgdsFile', path.resolve(baseFolder, 'dependencies/st-tgds.txt'))
  writer.writeElement('ttgdsFile', path.resolve(baseFolder, 'dependencies/t-tgds.txt'))

  writer.endElement()
}

function writeBCADependenciesConfig(writer : any, baseFolder : string, query : string) {
  writer.startElement('dependencies')

  writer.writeElement('sttgdsFile', path.resolve(baseFolder, `queries/RDFox/${query}/${query}-tgds.rule`))

  writer.endElement()
}

function writeQueriesConfig(writer : any, baseFolder : string, query : string) {
  writer.startElement('queries')

  writer.writeElement('queryFile', path.resolve(baseFolder, 'queries/RDFox/', query, `${query}.txt`))

  writer.endElement()
}
