import 'mocha'
import { expect } from 'chai'
import { convertOwlToTgd } from '../../app/converters/converters/owl-tgd'
import { convertTgdToSchema } from '../../app/converters/converters/tgd-schema'

describe('OWL-TGD-Schema integration', () => {

  it('should convert OWL to common format schema via common format TGDs', async () => {
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
      't0 {',
      '\tc0 : STRING',
      '\tc1 : STRING',
      '}',
      't1 {',
      '\tc0 : STRING',
      '}',
      't2 {',
      '\tc0 : STRING',
      '}'
    ]

    const tgdArray = await convertOwlToTgd(owlString)
    const result = convertTgdToSchema(tgdArray)

    expect(result).to.deep.equal(expected)
  })
})
