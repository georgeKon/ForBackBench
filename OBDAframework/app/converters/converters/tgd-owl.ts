import * as fs from 'fs'
import * as path from 'path'
import XMLWriter from 'xml-writer'
import format from 'xml-formatter'
import parser from '../grammars/tgd-grammar'

type SingleTGD = Array<[string, string | Array<string | string[]>]>
type ParsedTGD = [SingleTGD, SingleTGD]

interface Atom {
  name : string
  variables : string[]
  subClassOf : SubClass[]
  domain? : string
  range? : string,
  inverseOf? : string,
  subPropertyOf? : string
}

interface Restriction {
  onProperty : string
  someValuesFrom : string
}

interface SubClass {
  name : string
  restriction? : Restriction
}

const defaultUri = 'http://example.com/example.owl#'

// function convertTgdToOwlCmd(tgdPath, options) {
//   const tgdArray = fs.readFileSync(path.resolve(tgdPath), 'utf8').split(/\r?\n/)

//   const result = convertTgdToOwl(tgdArray, options)
//   // console.log(result)
// }

export function convertTgdToOwl(tgdArray : string[]) : string {
  const writer = new XMLWriter()
  writer.startDocument()

  writePreamble(writer)

  const parsed = tgdArray.map(line => parser.parse(line)) as ParsedTGD[]

  const atoms = new Map<string, Atom>()

  parsed.forEach(([head, body]) => {
    if(head.length > 1) {
      throw new Error('Only 1 atom allowed in head')
    }
    const [headName, headVars] = fixVariables(head[0])

    // @ts-ignore
    const headAtom : Atom = atoms.has(headName)
      ? atoms.get(headName)
      : { name: headName, variables: headVars, subClassOf: [] }

    const dependency = body[0]
    const [dependencyName, dependencyVars] = fixVariables(dependency)
    // @ts-ignore
    const dependencyAtom : Atom = atoms.has(dependencyName)
      ? atoms.get(dependencyName)
      : { name: dependencyName, variables: dependencyVars, subClassOf: [] }
    atoms.set(dependencyName, dependencyAtom)

    if(body.length === 1) {
      // Check for domain and range
      if((dependencyVars[0] === headVars[0]) && !headAtom.domain) {
        headAtom.domain = dependencyName
      } else if((dependencyVars[0] === headVars[1]) && !headAtom.range) {
        headAtom.range = dependencyName
      }
      // Check for inverseOf
      if((dependencyVars[0] === headVars[1]) && (dependencyVars[1] === headVars[0])) {
        headAtom.inverseOf = dependencyName
        dependencyAtom.inverseOf = headName
      }
      // Check for subPropertyOf
      if((dependencyVars[0] === headVars[0]) && (dependencyVars[1] === headVars[1])) {
        headAtom.subPropertyOf = dependencyName
      }
      // Check for subClassOf
      if(dependencyVars[0] === headVars[0]) {
        headAtom.subClassOf.push({ name: dependencyName })
      }
    } else if(body.length === 2) {
      const restriction = body[1]
      const [restrictionName, restrictionVars] = fixVariables(restriction)
      // @ts-ignore
      const restrictionAtom : Atom = atoms.has(restrictionName)
        ? atoms.get(restrictionName)
        : { name: restrictionName, variables: restrictionVars, subClassOf: [] }
      atoms.set(restrictionName, restrictionAtom)

      // Check for subClassOf
      if((dependencyVars[0] === headVars[0]) && (restrictionVars[0] === dependencyVars[1])) {
        headAtom.subClassOf.push({
          name: dependencyName,
          restriction: { onProperty: dependencyName, someValuesFrom: restrictionName }
        })
      }
    }

    atoms.set(headAtom.name, headAtom)
  })

  writeAtoms(writer, atoms)

  writer.endDocument()

  const output = format(writer.toString())
  return format(output)
}

function writePreamble(writer : any) {
  writeDocType(writer)
  writeRdf(writer)
  writeOntology(writer)
}

function writeDocType(writer : any) {
  // writer.writeDocType(`rdf:RDF [
  //   <!ENTITY owl "http://www.w3.org/2002/07/owl#" >
  //   <!ENTITY xsd "http://www.w3.org/2001/XMLSchema#" >
  //   <!ENTITY rdfs "http://www.w3.org/2000/01/rdf-schema#" >
  //   <!ENTITY rdf "http://www.w3.org/1999/02/22-rdf-syntax-ns#" >
  //   ]`)
}

function writeRdf(writer : any) {
  writer.startElement('rdf:RDF')
    .writeAttribute('xmlns', defaultUri)
    .writeAttribute('xml:base', defaultUri.split('#')[0])
    .writeAttribute('xmlns:owl', 'http://www.w3.org/2002/07/owl#')
    .writeAttribute('xmlns:xsd', 'http://www.w3.org/2001/XMLSchema#')
    .writeAttribute('xmlns:rdf', 'http://www.w3.org/1999/02/22-rdf-syntax-ns#')
}

function writeOntology(writer : any) {
  writer.startElement('owl:Ontology')
    .writeAttribute('rdf:about', defaultUri.split('#')[0])
    .endElement()
}

function writeAtoms(writer : any, atoms : Map<string, Atom>) {
  const filters : { objects : Atom[], classes : Atom[] } = { objects: [], classes: [] }

  atoms.forEach(atom => {
    // FIXME: we are assuming that 1 variable = Class and 2 = ObjectDependency
    if(atom.variables.length === 1) {
      filters.classes.push(atom)
    } else if(atom.variables.length === 2) {
      filters.objects.push(atom)
    } else {
      throw new Error('Atoms can be at max binary')
    }
  })

  filters.objects.forEach(objectAtom => writeObject(writer, objectAtom))
  filters.classes.forEach(classAtom => writeClass(writer, classAtom))
}

function writeClass(writer : any, { name, subClassOf } : Atom) {
  writer.startElement('owl:Class')
    .writeAttribute('rdf:about', defaultUri + name)

  subClassOf.forEach(subClass => {
    writer.startElement('rdfs:subClassOf')

    if(subClass.restriction) {
      writer.startElement('owl:Restriction')
        .startElement('owl:onProperty')
        .writeAttribute('rdf:resource', defaultUri + subClass.restriction.onProperty)
        .endElement()
        .startElement('owl:someValuesFrom')
        .writeAttribute('rdf:resource', defaultUri + subClass.restriction.someValuesFrom)
        .endElement()
        .endElement()
    } else {
      writer.writeAttribute('rdf:resource', defaultUri + subClass.name)
    }

    writer.endElement()
  })

  writer.endElement()
}

function writeObject(writer : any, { name, domain, range, inverseOf, subPropertyOf } : Atom) {
  writer.startElement('owl:ObjectProperty')
    .writeAttribute('rdf:about', defaultUri + name)

  if(domain) {
    writer.startElement('rdfs:domain')
      .writeAttribute('rdf:resource', defaultUri + domain)
      .endElement()
  }

  if(range) {
    writer.startElement('rdfs:range')
      .writeAttribute('rdf:resource', defaultUri + range)
      .endElement()
  }

  if(inverseOf) {
    writer.startElement('owl:inverseOf')
      .writeAttribute('rdf:resource', defaultUri + inverseOf)
      .endElement()
  }

  if(subPropertyOf) {
    writer.startElement('rdfs:subPropertyOf')
      .writeAttribute('rdf:resource', defaultUri + subPropertyOf)
      .endElement()
  }

  writer.endElement()
}

function fixVariables(dependency : any) : [string, Array<string[] | string>] {
  if(dependency.includes(', ')) {
    // @ts-ignore
    dependency = dependency[0]
  }
  const [name, vars] = dependency as [string, Array<string[] | string>]
  const fixedVars = vars.map(variable => handleConjunction(variable)) as string[]

  if(fixedVars.length > 2) {
    throw new Error('Atoms can at max be binary')
  }

  return [name, fixedVars]
}

function handleConjunction(variable : string | Array<string | string[]>) : [string, string[]] | string {
  // @ts-ignore
  return variable.includes(',') || variable.includes(', ') || variable.includes(' ^ ') ? variable[0] : variable
}

function handleAtom(atom : Atom) {

}

const tgdArray = fs.readFileSync(path.resolve('../scenarios/LUBM/test.txt'), 'utf8').split(/\r?\n/)
const owl = convertTgdToOwl(tgdArray)
fs.writeFileSync(path.resolve('../scenarios/LUBM/test.owl'), owl)

// <owl:Class rdf:about="http://swat.cse.lehigh.edu/onto/univ-bench.owl#TeachingAssistant">
//     <rdfs:label>university teaching assistant</rdfs:label>
//     <rdfs:subClassOf rdf:resource="http://swat.cse.lehigh.edu/onto/univ-bench.owl#Person"/>
//     <rdfs:subClassOf>
//         <owl:Restriction>
//             <owl:onProperty rdf:resource="http://swat.cse.lehigh.edu/onto/univ-bench.owl#teachingAssistantOf"/>
//             <owl:someValuesFrom rdf:resource="http://swat.cse.lehigh.edu/onto/univ-bench.owl#Course"/>
//         </owl:Restriction>
//     </rdfs:subClassOf>
// </owl:Class>
