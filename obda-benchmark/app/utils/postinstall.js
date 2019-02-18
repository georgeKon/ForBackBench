const { exec } = require('child_process')

generateGrammar('./app/converters/grammars/schema-grammar.pegjs')
generateGrammar('./app/converters/grammars/rapid-ucq-grammar.pegjs')
generateGrammar('./app/converters/grammars/iqaros-ucq-grammar.pegjs')
generateGrammar('./app/converters/grammars/tgd-grammar.pegjs')

function generateGrammar(path) {
  exec(`node ./node_modules/pegjs/bin/pegjs ${path}`, (err, stdout, stderr) => {
    if(err) {
      /* tslint:disable */
      console.error(err)
      /* tslint:enable */
      if(stderr) {
        /* tslint:disable */
        console.log(stderr)
        /* tslint:enable */
      }
      return
    }
    /* tslint:disable */
    console.log(`Grammar at ${path} generated successfully`)
    /* tslint:enable */
  })
}
