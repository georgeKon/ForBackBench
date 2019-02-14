import 'mocha'
import { expect } from 'chai'
import { convertTgdToOwl } from '../../app/converters/converters/tgd-owl'
import { convertOwlToTgd } from '../../app/converters/converters/owl-tgd'

describe('TGD-OWL-TGD integration', () => {

  it('should convert common format TGDs to OWL and back to TGDs', async () => {
    const tgdArray = [
      'advisor(?X,?X1) -> Person(?X) .',
      'advisor(?X,?X1) -> Professor(?X1) .'
    ]

    const expected = [
      'advisor(?X,?X1) -> Person(?X) .',
      'advisor(?X,?X1) -> Professor(?X1) .'
    ]

    const owlString = convertTgdToOwl(tgdArray)
    const result = await convertOwlToTgd(owlString)

    expect(result).to.deep.equal(expected)
  })
})
