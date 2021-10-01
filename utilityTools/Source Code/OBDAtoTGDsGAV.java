
import java.io.BufferedReader;
import java.io.FileNotFoundException;
import java.io.FileReader;
import java.io.FileWriter;
import java.io.IOException;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.HashMap;
import java.util.HashSet;
import java.util.LinkedHashMap;
import java.util.Map;
import java.util.Set;
import java.util.Map.Entry;


// Convert the mapping file to set of TGDs
public class OBDAtoTGDsGAV {
	
	
	static ArrayList<STmapping> mappingFile;
	static HashMap<String, ArrayList<String>> schema;
	
	public static void main(String[] args) throws IOException {
		mappingFile = readMappingFile(args[0]);
		schema = readSchemaFile(args[1]);
		String pathOfOutputFile = args[2];

		mappingToGAVrules(mappingFile,schema, pathOfOutputFile);
	}
	
	public static void mappingToGAVrules(ArrayList<STmapping> mappingRuleQuery,HashMap<String, ArrayList<String>> schema, String filePath ) throws IOException {
		
		FileWriter st_TGDsWriter = new FileWriter(filePath+"OBDAstTGDs.txt");
		FileWriter t_TGDsWriter = new FileWriter(filePath+"OBDAtTGDs.txt");
		
		Set<String> st_tgdRules = new HashSet<String>();
		Set<String> t_tgdRules = new HashSet<String>();

		for(STmapping map : mappingRuleQuery) {// for each object of mapping file
			boolean isUnary = map.isUnary;
			ArrayList<String> ruleColsNames = map.colsNames;
			int numCols = map.colsNames.size();
			int numOfArgs = map.getNumOfArgs();
			String ruleName = map.getRuleName();
			String sqlQuery = map.getSourceQuery();
			
			String head="";
			String tempTGD = null;
			String tgd = null;
			//if the rule contains more than one column name in one side, build the temp TGDs
			if(isUnary && numCols>1 || !isUnary && numCols>2) {
				//first: the head of temp TGD
				String tempHead = buildHead( ruleName,  numOfArgs,  "?Z");
				
				//Second: build the body of temp TGD
				String tempBody = ruleName+"Temp(";
				for(int i=1; i<=ruleColsNames.size();i++) {
					tempBody+= "?X"+i;
					tempBody+=",";
				}
				for(int i=1;i<=numOfArgs;i++) {
					tempBody+= "?Z"+i;
					if(i<numOfArgs) {
						tempBody+=",";
					}
				}
				
				tempBody+= ")";
				
				
				//--- Build the main TGDs ---
				
				//build the body
				String body = buildBody(sqlQuery, ruleColsNames);
				
				tgd = body+" -> "+ tempBody + " .";
				tempTGD = tempBody+" -> "+ tempHead + " .";
				
				st_tgdRules.add(tgd);
				t_tgdRules.add(tempTGD);
				
			
			}else {//if each side contains one col, created a single TGDs
				head = buildHead( ruleName,  numOfArgs,  "?X");
				String body = buildBody(sqlQuery, ruleColsNames);
				tgd = body+ "-> "+ head + " .";
//				System.out.println(body+ "-> "+ head);
				st_tgdRules.add(tgd);

//				st_TGDsWriter.write(tgd+"\n");
			}
		     

		
//			System.out.println(map.line);
		
		}//end loop map 
		for(String rule: st_tgdRules) {
			st_TGDsWriter.write(rule+"\n");
		}
		
		for(String rule: t_tgdRules) {
			t_TGDsWriter.write(rule+"\n");
		}
	      st_TGDsWriter.close();
	      t_TGDsWriter.close();

	}
	
	public static String buildHead(String ruleName, int numOfArgs, String varName) {
		String head = ruleName +"(";
		for(int i=1; i<=numOfArgs;i++) {
			head+= varName +i;
			if(i<numOfArgs) {
				head+=",";
			}
		}
		head+= ")";
		return head;
	}
	
	public static String buildBody(String sqlQuery, ArrayList<String> ruleColsNames) {
		String body="";
		//String sqlQuery = map.getSourceQuery();
//		System.out.println("sql: " +sqlQuery);
		//Get table names from the SQL query.
		String fromCaluse = sqlQuery.substring(sqlQuery.indexOf("FROM")+4);
		
		int endingCaluseIndex;
		String splitingKeyword = null;
		boolean isSplitted = false;
		String[] tablesNamesArr=null;
		
		if(fromCaluse.contains("INNER JOIN")) {
			endingCaluseIndex= fromCaluse.indexOf("ON");
			splitingKeyword = "INNER JOIN";
			isSplitted = true;
		}else if(fromCaluse.contains("WHERE")){
			endingCaluseIndex= fromCaluse.indexOf("WHERE");
			isSplitted = false;
		}else {
			endingCaluseIndex= fromCaluse.lastIndexOf("\"");
			isSplitted = false;
		}
		fromCaluse= fromCaluse.substring(0, endingCaluseIndex).replaceAll("\"", "");
//		System.out.println(fromCaluse);
		
		if(isSplitted) {
			tablesNamesArr = fromCaluse.split(splitingKeyword);
		}else {
			tablesNamesArr =fromCaluse.split(",");
		}
		for(int i=0; i < tablesNamesArr.length; i++) {
			tablesNamesArr[i]=tablesNamesArr[i].trim();
			if(tablesNamesArr[i].contains(" ")) {
				tablesNamesArr[i]=tablesNamesArr[i].substring(0, tablesNamesArr[i].indexOf(" "));
			}
		}
		Set<String> tablesNamesSet = new HashSet<>(Arrays.asList(tablesNamesArr));
//		  System.out.println("Contents of set ::"+tablesNamesSet);
		
		//Build the rule for each table.
		int counter = ruleColsNames.size()+1;
		int tableCount=0;
		for(String tableName: tablesNamesSet) {

			tableName=tableName.trim();
			boolean isSelected =false;
			if(schema.containsKey(tableName)) {
				//get the list of cols for the table from the schema
				ArrayList<String> tblColsNames = schema.get(tableName);
				body+= tableName+"(";
				//check for the position of selected cols in the table
				for(int i=0; i<tblColsNames.size(); i++) {
					//System.out.println(tblColsNames.get(i)+".");
					for ( int j = 0; j < ruleColsNames.size(); j++) {
					//	System.out.println(ruleArgs.get(j)+".=="+ tblColsNames.get(i)+".");
				    	
				        if(ruleColsNames.get(j).equals(tblColsNames.get(i))) {
				        	body+="?X"+(j+1);
				        	isSelected =true;
				        //	System.out.println("=8="+isSelected );
				        	break;
				        }else {
				        	isSelected =false;
				        }
				    }
					if(!isSelected) {
						body+="?X"+counter;
						counter++;
						isSelected =false;
					}
					
					if(i<tblColsNames.size()-1) {
						body+=",";
					}
					
				}
				
				
				if(tableCount<tablesNamesSet.size()-1) {
					body+=") , ";
				}else {
					body+=") ";
				}
				tableCount++;
				
			}
		}
		
		
		return body;
	}
	

	
	public static HashMap<String, ArrayList<String> > readSchemaFile(String mappingFile) {
    	HashMap<String,  ArrayList<String>> map = new HashMap<String, ArrayList<String>>();
    	 BufferedReader in;
		try {
			in = new BufferedReader(new FileReader(mappingFile));
			String line = "";
			String key="";
			String val="";
			ArrayList<String> colsName;
			while ((line = in.readLine()) != null) {
			//	System.out.println("AS:  "+line);
				//if line contains target, trim the line keep only the main word of the rule.
				if(line.contains("{")) {
					key=line.replace("{", "").trim();
					
		       		//System.out.println("-K-"+key);
		       		//if line contains source, keep only the query
		       		String nextLine= in.readLine();
		       		colsName =new ArrayList();
		       		while(!nextLine.contains("}") && nextLine.contains(":") ) {
		       			val=nextLine.trim();
				       	val = val.substring(0, val.indexOf(":") ).trim();
				     //  	System.out.println("-V-"+val);
				       	colsName.add(val);
				       	nextLine= in.readLine();
		       		}
		       		
		       		
		       		if(nextLine.contains("}") ) {
		       			map.put(key, colsName);
		       			colsName =new ArrayList();
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
	
	public static ArrayList<STmapping> readMappingFile(String mappingFile) {
    	ArrayList<STmapping> mapping = new ArrayList<STmapping>();
    	 BufferedReader in;
		try {
			in = new BufferedReader(new FileReader(mappingFile));
			String line = "";
			String targetLine="";
			while ((line = in.readLine()) != null) {
				String ruleName="";
				int numOfArgs =0;
				
				String sQuery = "";
				ArrayList<String> argsNames= new ArrayList<String>();
//				System.out.println(line);
				//if line contains target, trim the line keep only the main word of the rule.
				if(line.contains("target")) {
					String adLine =line;
					targetLine=line;
					numOfArgs = 2;
					
					//add the name of argument from target line
					boolean isUnary=false;
					if(targetLine.contains(" a ")) {
						isUnary=true;
						numOfArgs = 1;
					}

					
					int posOfColon1 = targetLine.indexOf(":");			
					int posOfSpace1 = targetLine.indexOf(" "); 
					//System.out.println(posOfSpace1);
		       		targetLine = targetLine.substring(targetLine.indexOf(":", posOfColon1 + 1)+1 );
		       		
		       		ruleName =  targetLine.substring(0, targetLine.indexOf(" "));
		       		
		    //   		System.out.println("--"+ruleName);
		       		//if line contains source, keep only the query
		       		String nextLine= in.readLine();
		       		
		       		if(nextLine.contains("source")) {
		       			sQuery=nextLine;
						
		       			sQuery = sQuery.substring(sQuery.indexOf("SELECT") );
//				      	System.out.println(sQuery);
				      	
				      	String sQueryColsNames = sQuery.substring(sQuery.indexOf("\""), sQuery.indexOf("FROM"));
//				      	System.out.println("---"+sQueryColsNames);
				      	String[] splitColsName = sQueryColsNames.split(",");
						for(int i=0; i<splitColsName.length; i++) {
							if(splitColsName[i].contains(" as ") ||splitColsName[i].contains(" AS ")) {
								splitColsName[i] = splitColsName[i].substring(splitColsName[i].indexOf(".\"")+2);
								splitColsName[i] = splitColsName[i].substring(0,splitColsName[i].indexOf("\""));
							}
							splitColsName[i] = splitColsName[i].replaceAll("\"", "").trim();
							argsNames.add(splitColsName[i]);
						}


					}
		       	// add the rule details
		       		
		       		STmapping map = new STmapping(adLine,ruleName, numOfArgs, sQuery, argsNames, isUnary);
		       		mapping.add(map);
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
    	return mapping;
    }

	
	
}


class STmapping {
	String line;
	String ruleName;
	int numOfArgs;
	String sourceQuery;
	ArrayList<String> colsNames;
	boolean isUnary;
	
	public STmapping(String line, String ruleName, int numOfArgs , String sourceQuery,ArrayList<String> argsName, boolean isUnary) {
		this.ruleName= ruleName;
		this.numOfArgs = numOfArgs;
		this.sourceQuery = sourceQuery;
		this.colsNames = argsName;
		this.line = line;
		this.isUnary = isUnary;
	}
	public STmapping(String adLine, String ruleName2, int numOfArgs2, String sQuery, ArrayList<String> argsName) {
		this.ruleName= ruleName;
		this.numOfArgs = numOfArgs;
		this.sourceQuery = sourceQuery;
		this.colsNames = argsName;
		this.line = line;
		this.isUnary = isUnary;
	}
	public String getRuleName() {
		return this.ruleName;
	}
	public int getNumOfArgs() {
		return this.numOfArgs;
	}
	public String getSourceQuery() {
		return this.sourceQuery;
	}	
}




