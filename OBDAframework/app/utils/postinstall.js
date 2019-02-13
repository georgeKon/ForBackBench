const { exec } = require('child_process')

generateGrammar('./app/converters/grammars/schema-grammar.pegjs')
generateGrammar('./app/converters/grammars/rapid-ucq-grammar.pegjs')
generateGrammar('./app/converters/grammars/iqaros-ucq-grammar.pegjs')
generateGrammar('./app/converters/grammars/tgd-grammar.pegjs')

function generateGrammar(path) {
  exec(`node ./node_modules/pegjs/bin/pegjs ${path}`, (err, stdout, stderr) => {
    if(err) {
      console.error(err)
      if(stderr) console.log(stderr)
      return
    }
    console.log(`Grammar at ${path} generated successfully`)
  })
}
