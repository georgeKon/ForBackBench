start
  = query

query
  = "Q(" vs:vars ") <- " as:atoms { return [vs, as] }

atom
  = name:[a-zA-Z0-9\-]+ "(" vs:vars ")" { return [name.join(''), vs]}

atoms
  = (atom " ^ " / atom)+

var
  = "X" name:[a-zA-Z0-9\_]+ { return name.join('') }

vars
  =  (var ","/ var)+ 