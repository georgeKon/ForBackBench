const { exec } = require('child_process')

generateGrammar('./app/grammars/schema-grammar.pegjs')
generateGrammar('./app/grammars/rapid-ucq-grammar.pegjs')
generateGrammar('./app/grammars/iqaros-ucq-grammar.pegjs')
generateGrammar('./app/grammars/tgd-grammar.pegjs')

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
