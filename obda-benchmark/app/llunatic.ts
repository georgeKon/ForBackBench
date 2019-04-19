import fs, { write } from 'fs'
import path from 'path'
import XMLWriter from 'xml-writer'

export default function writeLlunaticConfig(dataFolder : string) {
  const writer = new XMLWriter(true)
  writer.startDocument()
  writer.startElement('scenario')
  // Write source config
  writeSourceConfig(writer, dataFolder)

  writeTargetConfig(writer)

  writeExportConfig(writer)

  writeDependenciesConfig(writer)

  writeQueriesConfig(writer)

  writer.endDocument()

  fs.writeFileSync('scenario.xml', writer.toString())
}

function writeSourceConfig(writer : any, dataFolder : string) {
  writer.startElement('source')

  writeAccessConfig(writer, 'source')

  writer.startElement('schemaFile')
  writer.writeAttribute('schema', 'source')
  writer.text('schema/s-schema.txt')
  writer.endElement()

  writer.startElement('import')
  fs.readdirSync(dataFolder).filter(file => path.extname(file) === '.csv').forEach(file => {
    writer.startElement('input')
    writer.writeAttribute('type', 'csv')
    writer.writeAttribute('separator', ',')
    writer.writeAttribute('hasHeader', 'false')
    writer.writeAttribute('table', path.basename(file, '.csv').toLowerCase())
    writer.text(path.resolve(dataFolder, file))
    writer.endElement()
  })
  writer.endElement()

  writer.endElement()
}

function writeTargetConfig(writer : any) {
  writer.startElement('target')

  writeAccessConfig(writer, 'target')

  writer.startElement('schemaFile')
  writer.writeAttribute('schema', 'target')
  writer.text('schema/t-schema.txt')
  writer.endElement()

  writer.endElement()
}

function writeAccessConfig(writer : any, schema : string) {
  writer.writeElement('type', 'DBMS')

  writer.startElement('access-configuration')
  writer.writeElement('driver', 'org.postgresql.Driver')
  writer.writeElement('uri', 'jdbc:postgresql:lubm_llunatic')
  writer.writeElement('schema', schema)
  writer.writeElement('login', 'postgres')
  writer.writeElement('password', 'password')
  writer.endElement()
}

function writeExportConfig(writer : any) {
  writer.startElement('configuration')

  writer.writeElement('printResults', 'true')

  writer.endElement()
}

function writeDependenciesConfig(writer : any) {
  writer.startElement('dependencies')

  writer.writeElement('sttgdsFile', 'dependencies/st-tgds.txt')
  writer.writeElement('ttgdsFile', 'dependencies/t-tgds.txt')

  writer.endElement()
}

function writeQueriesConfig(writer : any) {
  writer.startElement('queries')

  writer.writeElement('queryFile', 'queries/RDFox/Q1/Q1.txt')

  writer.endElement()
}
