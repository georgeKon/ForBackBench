start
  = element*

element
  = name:string " { " attrs:attr* "} " { return [name, attrs] }
  / name:string " { " attrs:attr* "}" { return [name, attrs] }

attr
  = name:string " : " type:type ", " { return [name, type] }
  / name:string " : " type:type " "  { return [name, type] }

string
  = chars:[a-zA-Z0-9_\-]+ { return chars.join("") }

type
  = "STRING" / "INTEGER" / "DOUBLE" / "SYMBOL"
