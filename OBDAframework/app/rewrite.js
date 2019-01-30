const fs = require('fs')
const path = require('path')
const { exec } = require('child_process')
const { convertSparqlToQuery } = require('obda-converters')
const { parseConfig } = require('./drivers')

async function computeRewritingsCmd(queryPath, ontologyPath, tool, configPath) {
  const config = parseConfig(configPath)

  const result = await computeRewritings(queryPath, ontologyPath, tool, config)

  console.log(result)
}

async function computeRewritings(queryPath, ontologyPath, tool, config) {

  console.log(`Running ${tool}`)
  const toolPath = path.resolve(config.tools.find(({ name }) => name === tool).path)
  queryPath = path.resolve(queryPath)
  let conjunctiveQueryPath = queryPath.replace('.rq', '.cq')
  ontologyPath = path.resolve(ontologyPath)
  let commonQuery

  if(path.extname(queryPath) === '.rq') {
    commonQuery = convertSparqlToQuery(fs.readFileSync(queryPath, 'utf8'))
    fs.writeFileSync(conjunctiveQueryPath, commonQuery)
  }
  
  let ucqs

  switch(tool) {
    case 'rapid':
      ucqs = await new Promise((resolve, reject) => {
        exec(`java -jar ${toolPath} DU SHORT ${ontologyPath} ${conjunctiveQueryPath}`, (err, stdout, stderr) => {
          if(err) {
            console.error(err)
            if(stderr) {
              console.error(stderr)
              return
            }
          }
          if(stdout) {
            const array = stdout.split('\r\n')
            array.shift()
            array.pop()
            resolve(array)
          }
        })
      })
      break
    case 'iqaros':
      ucqs = await new Promise((resolve, reject) => {
        exec(`java -jar ${toolPath} ${ontologyPath} ${conjunctiveQueryPath}`, (err, stdout, stderr) => {
          if(err) {
            console.error(err)
            if(stderr) {
              console.error(stderr)
              return
            }
          }
          if(stdout) {
            const array = stdout.split('\r\n')
            array.pop()
            resolve(array)
          }
        })
      })
      break
  }

  return ucqs
}

module.exports = {
  computeRewritings,
  computeRewritingsCmd
}
