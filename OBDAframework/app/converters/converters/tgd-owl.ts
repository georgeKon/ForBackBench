import * as fs from 'fs'
import * as path from 'path'
import XMLWriter from 'xml-writer'
import parser from '../grammars/tgd-grammar'

type SingleTGD = Array<[string, string | Array<string | string[]>]>
type ParsedTGD = [SingleTGD, SingleTGD]

interface Atom {
  name : string
  variables : string[]
  domain? : string
  range? : string
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
    const [headName, headVars] = head[0] as [string, Array<string[] | string>]
    const fixedHeadVars = headVars.map(variable => handleConjunction(variable)) as string[]

    if(fixedHeadVars.length > 2) {
      throw new Error('Atoms can be at max binary')
    }
    // @ts-ignore
    const headAtom : Atom = atoms.has(headName) ? atoms.get(headName) : { name: headName, variables: fixedHeadVars }

    body.forEach(dependency => {
      const [bodyName, bodyVars] = dependency as [string, Array<string[] | string>]
      const fixedBodyVars = bodyVars.map(variable => handleConjunction(variable)) as string[]

      const bodyAtom : Atom = { name: bodyName, variables: fixedBodyVars }
      atoms.set(bodyAtom.name, bodyAtom)

      if(fixedBodyVars.length > 2) {
        throw new Error('Atoms can be at max binary')
      }

      if(fixedBodyVars[0] === fixedHeadVars[0]) {
        headAtom.domain = bodyName
      } else if(fixedBodyVars[0] === fixedHeadVars[1]) {
        headAtom.range = bodyName
      }
    })

    atoms.set(headAtom.name, headAtom)
  })

  writeAtoms(writer, atoms)

  writer.endDocument()

  return writer.toString()
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
  atoms.forEach((atom, name) => {
    // FIXME: we are assuming that 1 variable = Class and 2 = ObjectDependency
    if(atom.variables.length === 1) {
      writeClass(writer, atom)
    } else if(atom.variables.length === 2) {
      writeObject(writer, atom)
    } else {
      throw new Error('Atoms can be at max binary')
    }
  })
}

function writeClass(writer : any, { name } : Atom) {
  writer.startElement('owl:Class')
    .writeAttribute('rdf:about', defaultUri + name)
    .endElement()
}

function writeObject(writer : any, { name, domain, range } : Atom) {
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

  writer.endElement()
}

function handleConjunction(variable : string | Array<string | string[]>) : [string, string[]] | string {
  // @ts-ignore
  return variable.includes(',') || variable.includes(', ') || variable.includes(' ^ ') ? variable[0] : variable
}

const tgdArray = fs.readFileSync(path.resolve('../scenarios/LUBM/test.txt'), 'utf8').split(/\r?\n/)
convertTgdToOwl(tgdArray)
