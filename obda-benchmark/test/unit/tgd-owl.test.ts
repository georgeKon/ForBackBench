import 'mocha'
import { expect } from 'chai'
import * as fs from 'fs'
import * as path from 'path'
import { convertTgdToOwl } from '../../app/converters/converters/tgd-owl'

describe('TGD-OWL converter', () => {

  it('should convert common format TGDs to OWL', () => {
    const tgdArray = [
      'degreeFrom(?X,?X1) -> Person(?X) .',
      'degreeFrom(?X,?X1) -> University(?X1) .',
      'degreeFrom(?Y,?X) -> hasAlumnus(?X,?Y) .'
    ]

    const expected = fs.readFileSync(path.resolve('./test/unit/owl.xml'), 'utf8')

    const result = convertTgdToOwl(tgdArray)

    expect(result).to.deep.equal(expected)
  })
})

// <owl:ObjectProperty rdf:about="http://swat.cse.lehigh.edu/onto/univ-bench.owl#degreeFrom">
//         <rdfs:label>has a degree from</rdfs:label>
//         <rdfs:domain rdf:resource="http://swat.cse.lehigh.edu/onto/univ-bench.owl#Person"/>
//         <rdfs:range rdf:resource="http://swat.cse.lehigh.edu/onto/univ-bench.owl#University"/>
//         <owl:inverseOf rdf:resource="http://swat.cse.lehigh.edu/onto/univ-bench.owl#hasAlumnus"/>
//     </owl:ObjectProperty>
