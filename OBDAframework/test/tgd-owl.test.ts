import 'mocha'
import { expect } from 'chai'
import { convertTgdToOwl } from '../app/converters/converters/tgd-owl'

describe('TGD-OWL converter', () => {

  it('should convert common format TGDs to OWL', async () => {
    const tgdArray = [
      't0(?X, ?X1) -> t1(?X)',
      't0(?X, ?X1) -> t2(?X1)'
    ]
    const expected = [
      '<?xml version="1.0" encoding="UTF-8" ?>',
      '<rdf:RDF xmlns="http://example.com/example.owl#">',
      '<owl:Ontology rdf:about="http://example.com/example.owl">',
      '</owl:Ontology>',
      '<owl:ObjectProperty rdf:about="http://example.com/example.owl#t0">',
      '<rdfs:domain rdf:resource="http://example.com/example.owl#t1"/>',
      '<rdfs:range rdf:resource="http://example.com/example.owl#t2"/>',
      '</owl:ObjectProperty>',
      '</rdf:RDF>'
    ]

    const result = await convertTgdToOwl(tgdArray)

    expect(result).to.deep.equal(expected)
  })
})
