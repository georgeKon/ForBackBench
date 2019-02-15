import fs from 'fs'
import path from 'path'
import OBDAconverter from './app/converter'

const schema = fs.readFileSync(path.resolve('../scenarios/test/test-schema.txt'), 'utf8')
const sql = OBDAconverter.convertSchemaToSql(schema, { clean: true }).join('\n')
fs.writeFileSync(path.resolve('../scenarios/test/test-schema.sql'), sql)
