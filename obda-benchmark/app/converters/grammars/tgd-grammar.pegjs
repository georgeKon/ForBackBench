start
  = relation

relation
  = left:atoms " -> " right:atoms " ." { return [left, right] }

atom
  = name:[a-zA-Z0-9\-]+ "(" vs:vars ")" { return [name.join(''), vs] }

atoms
  = (atom ", "/ atom)+

var
  = "?" name:[a-zA-Z0-9\_]+ { return name.join('') }

vars
  =  (var ","/ var)+ 
