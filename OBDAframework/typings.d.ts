declare module 'pg-copy-streams' {
  export const to : any
  export const from : any
}

// type Atom = [string, string | [string | string[]]]

type ParsedTGD = [[string, string | [string | string[]]][], [string, string | [string | string[]]][]]
