
import java.io.BufferedWriter;
import java.io.File;
import java.io.FileWriter;
import java.io.IOException;
import java.util.HashSet;
import java.util.List;
import java.util.Set;

import uk.ac.ox.cs.chaseBench.model.Atom;
import uk.ac.ox.cs.chaseBench.model.Rule;
import uk.ac.ox.cs.chaseBench.model.Term;

public class TGDsToRLS {

	public static void main(String[] args) {
		
		String st_tgdsFilePath = null;
		String t_tgdsFilePath = null;
		String rlsOutputFile = null;
		String dataFolder = null;
		boolean t_tgds_Available= true;
		if (args.length == 0) {
	           System.out.println("Supported options:");
	           System.out.println("-st-tgds      <file>   | the file containing the source-to-target TGDs");
	           System.out.println("-t-tgds       <file>   | the file containing the target-to-target TGDs");
	           System.out.println("-out         <string>  | the folder path for the output Rulewerk Rule Syntax file");
    		   System.out.println("-data        <string>  | the path for the data folder");
	        } else {
	            
	            for (int i = 0; i < args.length - 1; i += 2) {
	                String argument = args[i];
	                switch (argument) {
	                    case "-st-tgds":
	                    	st_tgdsFilePath = args[i + 1];
	                        break;
	                    case "-t-tgds":
	                    	t_tgdsFilePath = args[i + 1];
	                        break;
	                    case "-out":
	                    	File dir = new File(args[i + 1]);
	                    	if(!dir.exists()) {
	                    		dir.mkdirs();
	                    	}
	                    	rlsOutputFile = args[i + 1]+"/rule.rls";
	                        break;
						case "-data":
    						dataFolder = args[i + 1];
       				    break;
	                    default:
	                        System.out.println("Unknown option '" + argument + "'.");
	                        break;

	                }
	            }
	            if (st_tgdsFilePath == null) {
	                System.out.println("Invalid argument setup: No source-to-target TGDs file found");
	            }else if (t_tgdsFilePath == null) {
	                System.out.println("Invalid argument setup: No target-to-target TGDs file found");
	            }else if (rlsOutputFile == null) {
	                System.out.println("Invalid argument setup: No output file is found ");
	            } else if (dataFolder == null) {
        			System.out.println("Invalid argument setup: No data folder is found ");
    			} else {
    				
    			 // --1-- Read st-TGDs and t-TGDs files --
    				
                    List<Rule> st_tgdsRules = null;
                    List<Rule> t_tgdsRules = null;
					try {
						st_tgdsRules = Mappings.getRules(st_tgdsFilePath);
						
						 File file = new File(t_tgdsFilePath);
		                    if (file.length() != 0) {
		                        t_tgdsRules = Mappings.getRules(t_tgdsFilePath);
		                    }else {
		                    	t_tgds_Available = false;
		                    }
		                    
					} catch (Exception e1) {
						// TODO Auto-generated catch block
						e1.printStackTrace();
					}
                    
                   

    				
    		   // --2-- Create @source prefix for data loading and Rules --
    				Set<String> dataSources = new HashSet<String>();
    				
    				for(Rule rule: st_tgdsRules ) {
    					//System.out.println("Rule# "+i +"   "+ rule.toString());
    					getDataSource(rule, dataFolder, dataSources);
    				}
    				Set<String> stRules = buildRuleFromFile(st_tgdsRules);
    				
    				Set<String> tRules=null;
    				if(t_tgds_Available) {
    					tRules =buildRuleFromFile(t_tgdsRules);
    					for(Rule rule: t_tgdsRules ) {
        						getDataSource(rule, dataFolder, dataSources);		
        				}
    				}
		
    				
    		   // --4-- Create the rls file --	
    				 try {    	           		  
	            		  BufferedWriter out = new BufferedWriter(new FileWriter(rlsOutputFile));	            	 
	            		  out.write("@prefix rdfs: <http://www.w3.org/2000/01/rdf-schema#> .");
	            		  //for loop to write @source	 
	            		  out.newLine();
	            		  for(String resource: dataSources) {
	            		      out.write(resource);
	            		      out.newLine();
	            		  }
	            		  //write rules
	            		  for(String rule: stRules) {
	            		      out.write(rule);
	            		      out.newLine();
	            		  }
	            		  if(tRules!=null)
	            			  for(String rule: tRules) {
	            				  out.write(rule);
	            				  out.newLine();
	            			  }
	            		             		
	            		  out.close();            		  
	            	      System.out.println("RLS file created successfully.");
	            	    } catch (IOException e) {
	            	      System.out.println("An error occurred.");
	            	      e.printStackTrace();
	            	    }//try
    				
	
    			}// else if the variable all set
	        
	        
	        }//if args length	
		
		
	}//main
	

	
	/*
	 * Convert TGDs rules to RLS rules
	 * @para List<Rule> rule from st-tgds file or t-tgds file .
	 * @return Set<String> the rules in RLS format 
	 */
	public static Set<String> buildRuleFromFile(List<Rule> rulesList) {
		
		Set<String> rules = new HashSet<String>();
		boolean isArgsDigits = false ;
			for(Rule rule :rulesList) {
			//	System.out.println("rule: "+rule);
				Atom[] headAtoms= rule.getHeadAtoms();
				Atom[] bodyAtoms = rule.getBodyAtoms();
			
				String ruleAsString="";
				String headAsString ="";
				for(Atom headAtom: headAtoms) {
				//	System.out.println("head atom:  "+headAtom.toString() );
					Term[] headArgs =headAtom.getArguments();
					String newHeadAtom = headAtom.toString();
					
					for(int i=0; i<headArgs.length; i++) {
						boolean notInBody = false;
						if( (headArgs[i].toString().replaceAll("\\?", "")).matches("[0-9]*")) {
							isArgsDigits=true;
						}
						for(Atom bodyAtom: bodyAtoms) {
						//	System.out.println("body atome :"+bodyAtom.toString());
							Term[] bodyArgs = bodyAtom.getArguments();
							for(int j=0; j<bodyArgs.length; j++) {
								if( (headArgs[i].toString()).equals(bodyArgs[j].toString()) ) {
									//System.out.println("I am equal  headArg: "+headArgs[i].toString() +" == " +bodyArgs[j].toString()  );
									notInBody= false;
									break;
								}else {
									//System.out.println("I am Nooot equal  headArg: "+headArgs[i].toString() +" != " +bodyArgs[j].toString()  );
									notInBody = true;
									
								}
							}//j
							if(!notInBody) {
								break;
							}
							
						}//i
						//if arguments not in the body, replace ? to !
						if(notInBody) {
							//System.out.println(headArgs[i].toString()+" I am Nooot in body");
							String newArg = headArgs[i].toString().replace("?", "!");
							newHeadAtom = newHeadAtom.replace(headArgs[i].toString(), newArg);
					
						}else {
							//System.out.println(headArgs[i].toString()+ " I am innnnn in body");
						
						}
					}
					headAsString += newHeadAtom+",";
					//System.out.println(headAsString);
					//System.out.println();

				}
				String bodyAsString="";
				for(Atom bodyAtom: bodyAtoms) {
					bodyAsString+=bodyAtom+",";
				}
				headAsString = headAsString.replaceAll(",$","");
				headAsString = headAsString.replaceAll("-", "");
				headAsString= headAsString.replaceAll("_", "");
				if(isArgsDigits) {
					headAsString= headAsString.replaceAll("\\?", "?X");
					headAsString= headAsString.replaceAll("!", "!X");
				}
				
				
				bodyAsString = bodyAsString.replaceAll(",$"," .");
				bodyAsString = bodyAsString.replaceAll("-", "");
				bodyAsString= bodyAsString.replaceAll("_", "");
				if(isArgsDigits) {
					bodyAsString= bodyAsString.replaceAll("\\?", "?X");
					bodyAsString= bodyAsString.replaceAll("!", "!X");
				}

				ruleAsString= headAsString +" :- " +bodyAsString;
				//System.out.println(ruleAsString);
				rules.add(ruleAsString);
			}
	
		return rules;
	}
	
	
	/*
	 * Produce the data sources for each rule and add it to the set of the source
	 * @para Rule the TGD rule .
	 * @para String the path for the data folder .
	 * @para Set<String> the set to add the new data source in.
	 * 
	 */
	public static void getDataSource(Rule rule, String datafolderPath,Set<String> dataSources ) {
		Set<Atom> allResourceNames = new HashSet<Atom>();
		Atom[] headAtoms= rule.getHeadAtoms();
		Atom[] bodyAtoms = rule.getBodyAtoms();

		for(Atom atom: headAtoms) {
			allResourceNames.add(atom);
		}
		

		for(Atom atom: bodyAtoms) {
			allResourceNames.add(atom);
		}
		
		
		for(Atom resource: allResourceNames) {
			String resouceName = resource.getPredicate().getName();
			resouceName= resouceName.replaceAll("\\s","");

			String fileName=null;
			if(resouceName.contains("src_")) {
				fileName = resouceName+".csv";
			}else {
				fileName = "src_"+resouceName+".csv";
			}
			//make sure if the csv file is exist or not before creating the resource.
			File folder = new File(datafolderPath);
			String datafolderAbsPath = folder.getAbsolutePath();
			File[] listOfFiles = folder.listFiles();
			if(isFileExist(fileName,listOfFiles)) {
				int arityCount = resource.getNumberOfArguments();
				resouceName= resouceName.replaceAll("-", "");
				resouceName= resouceName.replaceAll("_", "");
				String ds = "@source " + resouceName + "["+arityCount+"] : load-csv(\""+datafolderAbsPath+"/"+fileName+"\") .";
				dataSources.add(ds);
				//check if the source is new (the purpose of this step to do not duplicate sources).
				if(!dataSources.contains(ds)) {
					dataSources.add(ds);
				}
			}//isFileExist
		}//loop allResourceNames
		
	}//getDataSource method
	
	
	static boolean isFileExist(String fileName, File[] filesList) {	
		for(File f: filesList) {
	        if (f.getName().equals(fileName)) {
	            return true;
	        }
	    }
	    return false;
	}

}
