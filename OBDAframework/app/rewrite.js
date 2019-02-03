const fs = require('fs')
const path = require('path')
const { exec } = require('child_process')
const { convertSparqlToQuery } = require('obda-converters')
const { parseConfig, printMessage } = require('./drivers')

async function computeRewritingsCmd(queryPath, ontologyPath, tool, configPath, options) {
  const config = parseConfig(configPath)

  const result = await computeRewritings(queryPath, ontologyPath, tool, config, options)

  console.log(result)
}

async function computeRewritings(queryPath, ontologyPath, tool, config, options) {

  printMessage(`Running ${tool}`)
  const toolPath = path.resolve(config.tools.find(({ name }) => name === tool).path)
  queryPath = path.resolve(queryPath)
  const commonQueryPath = queryPath.replace('.rq', '.cq')
  ontologyPath = path.resolve(ontologyPath)

  let commonQuery
  if(fs.existsSync(commonQueryPath) && !options.force) {
    printMessage('Using cached common query')
    commonQuery = fs.readFileSync(commonQueryPath, 'utf8')
  } else if(path.extname(queryPath) === '.rq') {
    printMessage('Converting query')
    commonQuery = convertSparqlToQuery(fs.readFileSync(queryPath, 'utf8'))
    fs.writeFileSync(commonQueryPath, commonQuery)
    printMessage('Query conversion successful')
  } else {
    throw new Error('No common query or SPARQL file provided')
  }
  
  let ucqs

  switch(tool) {
    case 'rapid':
      ucqs = await new Promise((resolve, reject) => {
        exec(`java -jar ${toolPath} DU SHORT ${ontologyPath} ${commonQueryPath}`, (err, stdout, stderr) => {
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
        exec(`java -jar ${toolPath} ${ontologyPath} ${commonQueryPath}`, (err, stdout, stderr) => {
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
    case 'graal':
      ucqs = await new Promise((resolve, reject) => {
        exec(`java -jar ${toolPath} ${ontologyPath} ${queryPath} rewrite`, (err, stdout, stderr) => {
          if(err) {
            console.error(err)
            if(stderr) {
              console.error(stderr)
              return
            }
          }
          if(stdout) {
            const array = stdout.split('\n')
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
