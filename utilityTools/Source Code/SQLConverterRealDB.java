import java.io.BufferedReader;
import java.io.FileNotFoundException;
import java.io.FileReader;
import java.io.IOException;
import java.util.*;

import uk.ac.ox.cs.chaseBench.model.Atom;
import uk.ac.ox.cs.chaseBench.model.Constant;
import uk.ac.ox.cs.chaseBench.model.Predicate;
import uk.ac.ox.cs.chaseBench.model.Rule;
import uk.ac.ox.cs.chaseBench.model.Term;
import uk.ac.ox.cs.chaseBench.model.Variable;


public class SQLConverterRealDB {
	static HashMap<String, ArrayList<String>> schema;
	static List<Rule> queries;
	
    public static String manyQueriestoSQL(List<Rule> queries, boolean src) {
        StringBuilder builder = new StringBuilder();
        for (int i = 0; i < queries.size(); i++) {
            Rule q = queries.get(i);
            String sqlQuery = queryToSQL(q, src).replace(";", "");
            if(sqlQuery!= "") {
            	  builder.append(sqlQuery);
                  if (i != queries.size() - 1)
                      builder.append(" UNION ");
            }
        }
        builder.append(';');
        return builder.toString();

    }

    public static void main(String[] args) throws Exception {
    	schema = readSchemaFile(args[1]);
        System.out.println(manyQueriestoSQL(DataLogToUCQ.getRuleString(args[0]), args.length > 2));
    }

    public static String addAliases(String originalQuery) {
        String[] outputVars = originalQuery.split("DISTINCT")[1].split("FROM")[0].split(",");
        StringBuilder output = new StringBuilder("SELECT ");
        for (int i = 0; i < outputVars.length; i++) {
            String var = outputVars[i];
            output.append(var.trim()).append(" as var").append(i);
            if (i < outputVars.length - 1) {
                output.append(", ");
            }
        }
        output.append(" FROM ").append(originalQuery.split("FROM")[1]);
        return output.toString();
    }

    public static String queryToSQL(Rule query, boolean src, boolean existentialRemove) {
        char aliasLetter = 'A';
        char aliasLetter1 = 'A';
        List<Variable> distVars = new ArrayList<>();
        Map<Variable, ArrayList<String>> columnMappings = new HashMap<Variable, ArrayList<String>>();
        Map<Constant, ArrayList<String>> columnConstraints = new HashMap<Constant, ArrayList<String>>();
        List<String> predicates = new ArrayList<>();
        Arrays.stream(query.getHeadAtoms()).forEach(atom -> Arrays.stream(atom.getArguments()).filter(term -> term instanceof Variable).forEach(term -> distVars.add((Variable) term)));
       
        for (Atom a : query.getBodyAtoms()) {
//        	 System.out.println(a.getPredicate().getName());
        	if(src)
        		a= a.replacePredicate(new Predicate("src_"+a.getPredicate().getName()));
//        	 System.out.println(a.getPredicate().getName());
        	predicates.add(a.getPredicate().getName());
            ArrayList<String> columnNamesFromSchema = getColNameFromSchema(a);
            for (int i = 0; i < a.getNumberOfArguments(); i++) {
                if (a.getArgument(i) instanceof Variable) {
                    Variable var = (Variable) a.getArgument(i);
                    if (columnMappings.containsKey(var)) {
                        ArrayList<String> columns = columnMappings.get(var);
                        columns.add(aliasLetter+""+aliasLetter1 + ".\"" + columnNamesFromSchema.get(i) + "\"");
                        columnMappings.put(var, columns);
                    } else {
                        ArrayList<String> columns = new ArrayList<String>();
                        columns.add(aliasLetter+""+aliasLetter1 + ".\"" + columnNamesFromSchema.get(i) + "\"");
                        columnMappings.put(var, columns);
                    }
                } else if (a.getArgument(i) instanceof Constant) {
                    Constant con = (Constant) a.getArgument(i);
                    if (columnConstraints.containsKey(con)) {
                        ArrayList<String> columns = columnConstraints.get(con);
                        columns.add(aliasLetter+""+aliasLetter1 + ".\"" + columnNamesFromSchema.get(i) + "\"");
                        columnConstraints.put(con, columns);
                    } else {
                        ArrayList<String> columns = new ArrayList<String>();
                        columns.add(aliasLetter+""+aliasLetter1 + ".\"" + columnNamesFromSchema.get(i) + "\"");
                        columnConstraints.put(con, columns);
                    }
                }
            }
            aliasLetter++;
			if(! Character.isAlphabetic(aliasLetter) ) {
				aliasLetter1++;
				aliasLetter='A';
			}
        }
		     
        aliasLetter = 'A';
        aliasLetter1 = 'A';
        StringBuilder builder = new StringBuilder();
        builder.append("SELECT DISTINCT ");
        String prefix = "";
        boolean noProjectionCols =true;
        for (Variable v : distVars) {
            if (columnMappings.containsKey(v)) {
                builder.append(prefix);
                builder.append(columnMappings.get(v).get(0));
                prefix = ", ";
//                noProjectionCols = false;
            }else {
            	 builder.append(prefix);
            	 builder.append("Null");
                 prefix = ", ";
            }
        }

        builder.append(" FROM ");
        prefix = "";
        for (String s : predicates) {
            builder.append(prefix);
            builder.append("\"");
//                builder.append("src_");
            builder.append(s).append("\"");
          
            builder.append(" as ").append(aliasLetter+""+aliasLetter1);
            aliasLetter++;
			if(! Character.isAlphabetic(aliasLetter) ) {
				aliasLetter1++;
				aliasLetter='A';
			}
            prefix = ", ";
        }
        if (equalities(columnMappings, columnConstraints) || existentialRemove)
            builder.append(" WHERE ");

        if (existentialRemove) {
            prefix = "";
            for (Variable v : distVars) {
                if (columnMappings.containsKey(v)) {
                    builder.append(prefix);
                    builder.append(columnMappings.get(v).get(0));
                    builder.append(" NOT LIKE '_:%'");
                    prefix = " AND ";
                }
            }
        }
        prefix = "";
        for (Variable v : columnMappings.keySet()) {
            ArrayList<String> columns = columnMappings.get(v);
            if (columns.size() > 1) {
                for (int i = 1; i < columns.size(); i++) {
                    builder.append(prefix);
                    builder.append(columns.get(i - 1)).append(" = ").append(columns.get(i));
                    prefix = " AND ";
                }
            }
        }

        for (Constant c : columnConstraints.keySet()) {
            ArrayList<String> columns = columnConstraints.get(c);
            for (String column : columns) {
                builder.append(prefix);
                builder.append(column).append(" = ").append(c.toString().replace("?", ""));
            }
        }

        builder.append(";");
        return builder.toString().replace("?", "");
        
    }

    public static String queryToSQL(Rule query, boolean src) {
        return queryToSQL(query, src, false);
    }

    private static boolean equalities(Map<Variable, ArrayList<String>> columnMappings, Map<Constant, ArrayList<String>> columnConstraints) {
        for (Map.Entry<Variable, ArrayList<String>> entry : columnMappings.entrySet()) {
            if (entry.getValue().size() > 1) {
                return true;
            }
        }
        for (Map.Entry<Constant, ArrayList<String>> entry : columnConstraints.entrySet()) {
            if (entry.getValue().size() > 1) {
                return true;
            }
        }
        return false;

    }
    
    public static  ArrayList<String> getColNameFromSchema(Atom atom) {
    	ArrayList<String> colsNames=new  ArrayList<String>();
    	String tblName = atom.getPredicate().getName();
		
    	if(schema.containsKey(tblName)) {
    		//get colslist for that table
    		colsNames = schema.get(tblName);

		}else {
			return null;
		}
    	
		return colsNames;
    	
    }

    public static HashMap<String, ArrayList<String> > readSchemaFile(String mappingFile) {
    	HashMap<String,  ArrayList<String>> map = new HashMap<String, ArrayList<String>>();
    	 BufferedReader in;
		try {
			in = new BufferedReader(new FileReader(mappingFile));
			String line = "";
			String tblName="";
			String val="";
			ArrayList<String> colsNames;
			while ((line = in.readLine()) != null) {
			//	System.out.println("AS:  "+line);
				//if line contains target, trim the line keep only the main word of the rule.
				if(line.contains("{")) {
					tblName=line.replace("{", "").trim();
					
		       		//System.out.println("-K-"+key);
		       		//if line contains source, keep only the query
		       		String nextLine= in.readLine();
		       		colsNames =new ArrayList();
		       		while(!nextLine.contains("}") && nextLine.contains(":") ) {
		       			val=nextLine.trim();
				       	val = val.substring(0, val.indexOf(":") ).trim();
				     //  	System.out.println("-V-"+val);
				       	colsNames.add(val);
				       	nextLine= in.readLine();
		       		}
		       		
		       		
		       		if(nextLine.contains("}") ) {
		       			map.put(tblName, colsNames);
		       			colsNames =new ArrayList();
					}
		       	// add the rule name as key, and the query as value
		       		//map.put(key, val);
		       	}
	             
			}
			in.close();
		} catch (FileNotFoundException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} catch (IOException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
    	return map;
    }

}
