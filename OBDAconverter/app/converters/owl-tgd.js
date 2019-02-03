const fs = require('fs')
const path = require('path')
const parser = require('xml2js');

async function convertOwlToTgdCmd(owlPath, options) {
  const owlString = fs.readFileSync(path.resolve(owlPath), 'utf8')
  
  const result = await convertOwlToTgd(owlString)
  console.log(result)
}

async function convertOwlToTgd(owlString) {
  const parsed = await parseXml(owlString)
  
  const classes = handleClasses(parsed['rdf:RDF']['owl:Class'])
  const objects = handleObjects(parsed['rdf:RDF']['owl:ObjectProperty'])
  const transitives = handleTransitives(parsed['rdf:RDF']['owl:TransitiveProperty'])
  const datatypes = handleDatatypes(parsed['rdf:RDF']['owl:DatatypeProperty'])

  // console.log([...classes, ...objects, ...transitives, ...datatypes])
  return [...classes, ...objects, ...transitives, ...datatypes]
}

function handleClasses(classes) {
  if(!classes) return []
  const lines = []
  classes.forEach(classObj => {
    const name = (classObj['$']['rdf:ID'] || classObj['$']['rdf:about']).split('#').pop()

    if(classObj.hasOwnProperty('owl:intersectionOf')) {
      const intersection = classObj['owl:intersectionOf'][0]

      if(intersection.hasOwnProperty('owl:Class')) {
        const intClass = formatText(intersection['owl:Class'], 'rdf:about')
        lines.push(`${name}(?X) -> ${intClass}(?X) .`)
      }

      const restriction = handleRestriction(intersection['owl:Restriction'][0], name)
      lines.push(restriction)
    }

    if(classObj.hasOwnProperty('rdfs:subClassOf')) {
      classObj['rdfs:subClassOf'].forEach(subClass => {
        if(subClass.hasOwnProperty('owl:Restriction')) {
          const subRestriction = handleRestriction(subClass['owl:Restriction'][0], name)
          lines.push(subRestriction)
        } else {
          const sub = subClass.hasOwnProperty('owl:Class') ? formatText(subClass['owl:Class']) : subClass['$']['rdf:resource'].split('#').pop()
          lines.push(`${name}(?X) -> ${sub}(?X) .`)
        }
      })
    }
  })
  return lines
}

function handleRestriction(restriction, name) {
  const property = restriction['owl:onProperty'][0].hasOwnProperty('owl:ObjectProperty') ? formatText(restriction['owl:onProperty'][0]['owl:ObjectProperty']) : formatText(restriction['owl:onProperty'])
  const resClass = restriction['owl:someValuesFrom'][0].hasOwnProperty('owl:Class') ? formatText(restriction['owl:someValuesFrom'][0]['owl:Class']) : formatText(restriction['owl:someValuesFrom'])
  
  return `${name}(?X) -> ${property}(?X, ?Y), ${resClass}(?Y) .`
}

function handleObjects(objects) {
  if(!objects) return []
  const lines = []
  objects.forEach(object => {
    const name = (object['$']['rdf:ID'] || object['$']['rdf:about']).split('#').pop()

    if(object.hasOwnProperty('rdfs:domain')) {
      const domain = formatText(object['rdfs:domain'])
      lines.push(`${name}(?X, ?X1) -> ${domain}(?X) .`)
    }

    if(object.hasOwnProperty('rdfs:range')) {
      const range = formatText(object['rdfs:range'])
      lines.push(`${name}(?X, ?X1) -> ${range}(?X1) .`)
    }
    
    if(object.hasOwnProperty('owl:inverseOf')) {
      const inverse = object['owl:inverseOf'][0].hasOwnProperty('owl:ObjectProperty') ? formatText(object['owl:inverseOf'][0]['owl:ObjectProperty']) : formatText(object['owl:inverseOf'])
      lines.push(`${name}(?Y, ?X) -> ${inverse}(?X, ?Y) .`)
    }

    if(object.hasOwnProperty('rdfs:subPropertyOf')) {
      const sub = formatText(object['rdfs:subPropertyOf'])
      lines.push(`${name}(?X, ?Y) -> ${sub}(?X, ?Y) .`)
    }
  })
  return lines
}

function handleTransitives(transitives) {
  if(!transitives) return []
  const lines = []
  transitives.forEach(transitive => {
    const name = (transitive['$']['rdf:ID'] || transitive['$']['rdf:about']).split('#').pop()

    if(transitive.hasOwnProperty('rdfs:domain')) {
      const domain = formatText(transitive['rdfs:domain'])
      lines.push(`${name}(?X, ?X1) -> ${domain}(?X) .`)
    }

    if(transitive.hasOwnProperty('rdfs:range')) {
      const range = formatText(transitive['rdfs:range'])
      lines.push(`${name}(?X, ?X1) -> ${range}(?X1) .`)
    }

    lines.push(`${name}(?X, ?Y), ${name}(?Y, ?Z) -> ${name}(?X, ?Z) .`)
  })
  return lines
}

function handleDatatypes(datatypes) {
  if(!datatypes) return []
  const lines = []
  datatypes.forEach(datatype => {
    const name = (datatype['$']['rdf:ID'] || datatype['$']['rdf:about']).split('#').pop()

    if(datatype.hasOwnProperty('rdfs:domain')) {
      const domain = formatText(datatype['rdfs:domain'])
      lines.push(`${name}(?X, ?X1) -> ${domain}(?X) .`)
    }
  })
  return lines
}

function formatText(node) {
  if(node[0]['$'].hasOwnProperty('rdf:about')) return node[0]['$']['rdf:about'].split('#').pop()
  if(node[0]['$'].hasOwnProperty('rdf:ID')) return node[0]['$']['rdf:ID'].split('#').pop()
  return node[0]['$']['rdf:resource'].split('#').pop()
}

function parseXml(string) {
  return new Promise((res, rej) => {
    parser.parseString(string, (err, data) => {
      if(err) rej(err)
      else res(data)
    })
  })
}

module.exports = {
  convertOwlToTgd,
  convertOwlToTgdCmd
}
