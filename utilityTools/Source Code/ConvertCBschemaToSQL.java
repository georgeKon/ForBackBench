import java.io.FileWriter;
import java.io.IOException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.Map;

public class ConvertCBschemaToSQL {
	
	
	public static void main(String[] args) throws Exception {
	        String outputSQLSchemaFile = null;
	        String schemaCBFile = null;
	        if (args.length == 0) {
	            System.out.println("Supported options:");
	            System.out.println("-s-sch   <file>  | the file containing the schema in CB format");
	            System.out.println("-out   <file>  | the file that will contain schema in SQL format");
	        } else {
		        for (int i = 0; i < args.length - 1; i += 2) {
		            String argument = args[i];
		            switch (argument) {
		                case "-s-sch":
		                	schemaCBFile = args[i + 1];
		                    break;
		                case "-out":
		                	outputSQLSchemaFile = args[i + 1];
		                    break;
		          
		                default:
		                    throw new Exception("Unsupported argument " + argument);
		            }
		        }
	        }
	        System.out.println(schemaCBFile);
	        System.out.println(outputSQLSchemaFile);
	        
	        createSQLSchema(schemaCBFile,outputSQLSchemaFile);

	}
	
	public static void createSQLSchema(String schemaCBFile, String outputFile) {
		HashMap<String, ArrayList<String>> schema = OBDAtoTGDsGAV.readSchemaFile(schemaCBFile);
		FileWriter sqlSchemaWriter = null;
		try {
			sqlSchemaWriter = new FileWriter(outputFile);
		} catch (IOException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		
		for (Map.Entry<String, ArrayList<String>> entry : schema.entrySet()) {
		    String tblName = entry.getKey();
		    ArrayList<String> colsList = entry.getValue();
//		    CREATE TABLE "See_partially" (c0 text);
//		    DROP TABLE IF EXISTS "Spina_Bifida";
		   
		    try {
		    	sqlSchemaWriter.write("DROP TABLE IF EXISTS \""+tblName+"\";"+"\n");
				sqlSchemaWriter.write("CREATE TABLE \""+tblName+"\" (");
			
				for(int i=0; i< colsList.size(); i++) {
					sqlSchemaWriter.write(colsList.get(i)+" text");
					if(i<colsList.size()-1) {
						sqlSchemaWriter.write(" , ");
					}
				}
			sqlSchemaWriter.write(");"+"\n");
		    } catch (IOException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
		}
		try {
			sqlSchemaWriter.close();
		} catch (IOException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		
	}
	
	
	

}
