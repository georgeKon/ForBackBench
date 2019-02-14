declare module 'pg-copy-streams' {
  export const to : any
  export const from : any
}

type ParsedTGD = [[string, string | (string | string[])[]][], [string, string | (string | string[])[]][]]

type ParsedSchema = Array<[string, Array<[string, string]>]>

type ParsedUCQ = [Array<string | string[]>, Array<string | Array<string | string[]>>]
