import 'mocha'
import { expect } from 'chai'
import { convertOwlToTgd } from '../app/converters/converters/owl-tgd'

describe('OWL-TGD converter', () => {

  it('should convert OWL to common format TGDs', async () => {
    const owlString = `<?xml version="1.0" encoding="UTF-8" ?>
    <rdf:RDF xmlns="http://example.com/example.owl#">
    <owl:Ontology rdf:about="http://example.com/example.owl">
    </owl:Ontology>
    <owl:ObjectProperty rdf:about="http://example.com/example.owl#t0">
        <rdfs:domain rdf:resource="http://example.com/example.owl#t1"/>
        <rdfs:range rdf:resource="http://example.com/example.owl#t2"/>
    </owl:ObjectProperty>
    </rdf:RDF>
    `
    const expected = [
      't0(?X, ?X1) -> t1(?X)',
      't0(?X, ?X1) -> t2(?X1)'
    ]

    const result = await convertOwlToTgd(owlString)

    expect(result).to.deep.equal(expected)
  })
})
