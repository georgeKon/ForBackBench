declare module 'xml-writer' {
  const value : any
  export default value
}

declare module 'xml-formatter' {
  const value : any
  export default value
}

type ParsedSchema = Array<[string, Array<[string, string]>]>
type ParsedUCQ = [Array<string | string[]>, Array<string | Array<string | string[]>>]
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

interface Triple {
  subject : string,
  object : string,
  predicate : string
}
