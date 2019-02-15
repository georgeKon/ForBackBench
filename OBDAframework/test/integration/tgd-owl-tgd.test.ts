import 'mocha'
import { expect } from 'chai'
import { convertTgdToOwl } from '../../app/converters/converters/tgd-owl'
import { convertOwlToTgd } from '../../app/converters/converters/owl-tgd'

describe('TGD-OWL-TGD integration', () => {

  it('should convert common format TGDs to OWL and back to TGDs', async () => {
    const tgdArray = [
      'degreeFrom(?X,?X1) -> Person(?X) .',
      'degreeFrom(?X,?X1) -> University(?X1) .',
      'degreeFrom(?Y,?X) -> hasAlumnus(?X,?Y) .'
    ]

    const expected = [
      'degreeFrom(?X,?X1) -> Person(?X) .',
      'degreeFrom(?X,?X1) -> University(?X1) .',
      'degreeFrom(?Y,?X) -> hasAlumnus(?X,?Y) .'
    ]

    const owlString = convertTgdToOwl(tgdArray)
    const result = await convertOwlToTgd(owlString)

    expect(result).to.deep.equal(expected)
  })
})
