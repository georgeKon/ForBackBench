


import java.io.File;
import java.io.FileWriter;
import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Collections;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

public class CreateCGQRTTGD {

	
	public static void consolidateTTGDFile(Path inPath, Path outPath) throws IOException {
		List<String> consolidated = consolidateTTGD(readTTGD(inPath));
    	verifySpecifics(consolidated);
		writeTTGD(outPath, consolidated);
	}
	
	public static void consolidateAllTTGDs() {
		try {
            List<File> dirs = Files.list(Paths.get("scenarios").toAbsolutePath())
            			.filter(Files::isDirectory)
                        .map(Path::toFile)
                        .collect(Collectors.toList());
                
            for (File dir : dirs) {
            	try {
            		System.out.println("Getting scenario directory "+dir);
            		consolidateTTGDFile(Paths.get(dir.getPath(), "dependencies", "oneToOne-t-tgds.txt"), Paths.get(dir.getPath(), "dependencies", "ChaseGQR", "cgqr-t-tgds.txt"));
	            } catch (IOException e) {
	            	e.printStackTrace();
	            }
            }
		} catch (IOException e) {
        	e.printStackTrace();
        }
	}
	
	
	
	public static void verifySpecifics(List<String> lines) {
		for (int i = 0; i < lines.size(); i++) {
			// TODO: This is pretty inefficient!
			for (int j = 0; j < lines.size(); j++) {
				if(isMoreSpecific(lines.get(i).split(" -> ")[0], lines.get(j).split(" -> ")[0])) {					
					System.out.println("WARNING: The body \""+lines.get(i).split(" -> ")[0]+"\" (Line "+i+") may be a more specific version of the body \""+lines.get(j).split(" -> ")[0]+"\" (Line "+j+")");					
				}	
			}
		}
	}
	
	
	//Returns true if (and only if) body1 is more specific than body2
	public static boolean isMoreSpecific(String body1, String body2) {

		String[] bodyComponents1 = body1.split("\\(|\\)");
		String[] bodyComponents2 = body2.split("\\(|\\)");
		
		//Ensure there are the same number of components
		if(bodyComponents1.length != bodyComponents2.length) {
			return false;
		}
		
		Map<String, String> atoms1 = new HashMap<String, String>();
		Map<String, String> atoms2 = new HashMap<String, String>();
		for(int i=0; i<bodyComponents1.length; i+=2) {
			atoms1.put(bodyComponents1[i], bodyComponents1[i+1]);
			atoms2.put(bodyComponents2[i], bodyComponents2[i+1]);
		}
		
		//Ensure that the body atoms are equivalent, but contain different arguments
		if(!atoms1.keySet().equals(atoms2.keySet()) || new ArrayList<String>(atoms1.values()).equals(new ArrayList<String>(atoms2.values()))){
			return false;
		}

		//TODO: Some other checks are likely needed here, but for now we'll accept a human checking it
		
		return true;
	}
	
	
	
	public static List<String> readTTGD(Path path) throws IOException {
		List<String> lines = Files.readAllLines(path);
		return lines;	
	}
	
	public static boolean bodyIsEquivalent(String line1, String line2) {
		String body1 = line1.split(" -> ")[0];
		String body2 = line2.split(" -> ")[0];
		
		// Quick check to avoid double checking later
		if(body1.equals(body2)) {return true;}
		
		// Take into account multiple body atoms (that may not be in the same order)
		String[] body1atoms = body1.split(", ");
		Arrays.sort(body1atoms);
		body1 = String.join(", ", body1atoms);
		
		String[] body2atoms = body2.split(", ");
		Arrays.sort(body2atoms);
		body2 = String.join(", ", body2atoms);
	
		return body1.equals(body2);
	}
	
	
	// Add the head of one line to the head of another
	public static String consolidate(String line1, String line2) {
		return line1.substring(0, line1.length() - 1) + ", " + line2.split(" -> ")[1];
	}
	
	
	public static List<String> consolidateTTGD(List<String> inputLines) {		
		
		List<String> outputLines = new ArrayList<String>();
		int existentialVariableIndex = 1;
		while(inputLines.size() > 0) {
			
			boolean matchFound = false;
			
			String currentLine = inputLines.remove(0);
			
			
			//Reparse the arguments of the current line to be a uniform format
			//(This *would* be a separate method, but we need the existentialVariables count above)
			String parsedLine = "";
			
			//Get the arguments in just the body, so we can refer back to them
			List<String> bodyArguments = new ArrayList<String>();
			String[] bodyParts = currentLine.split(" -> ")[0].split("\\(|\\)");
			for(int i=1; i<bodyParts.length; i+=2) {
				for(String argument : bodyParts[i].split(",")) {
					if(!bodyArguments.contains(argument)) {
						bodyArguments.add(argument);
					}
				}
			}
			
			
			
			Map<String, String> argumentMap = new HashMap<String, String>();
			int index = 0;
			for(String part : currentLine.split("\\(|\\)")){
				// If we're not between brackets, just copy this to the outstring
				if(index % 2 == 0) {
					parsedLine += part;
				}
				// Else, deal with arguments
				else {
					parsedLine += "(";
					
					String[] arguments = part.split(",");
					for(String argument : arguments) {
						
						if(!argumentMap.containsKey(argument)) {
							
							//We perform this check to avoid existential variables colliding when we reduce two heads;
							//its unlikely, but possible
							if(bodyArguments.contains(argument)) {
								//TODO: this might fail/look weird if there are more than 26 unique arguments in a line
								argumentMap.put(argument, "?" + Character.toString((char)(bodyArguments.indexOf(argument)+65)));
							}
							else {
								argumentMap.put(argument, "?EX"+existentialVariableIndex);
								existentialVariableIndex++;
							}
						}
						
						parsedLine += argumentMap.get(argument) + ",";
					}
					//Remove the last comma
					parsedLine = parsedLine.substring(0, parsedLine.length()-1);
					parsedLine += ")";
				}
				index++;
			}
			currentLine = parsedLine;
			

			
			//Check against all previously checked lines for a match (with a
			//for loop, rather than a for-each, because we need the index)
			for(int i=0; i < outputLines.size(); i++) {
				//If a match is found, update the match by consolidating it with this line
				if(bodyIsEquivalent(currentLine, outputLines.get(i))) {
					outputLines.set(i, consolidate(currentLine, outputLines.get(i)));
					matchFound = true;
					break;
				}
			}
			//If no match is found, a new line with a unique body is added to the output
			if(!matchFound) {
				outputLines.add(currentLine);
			}
		}
		return outputLines;
	}
	
	
	public static void writeTTGD(Path outPath, List<String> lines) {
		try {
		      File outFile = new File(outPath.toString());
		      outFile.getParentFile().mkdirs();
		      if (outFile.createNewFile()) {
		        System.out.println("File created: " + outFile.getName());
		      } else {
		        System.out.println("File already exists.");
		      }
		    } catch (IOException e) {
		      System.out.println("An error occurred.");
		      e.printStackTrace();
		    }
		
		try {
			FileWriter outWriter = new FileWriter(outPath.toString());
			for (String line : lines) {
				outWriter.write(line+"\n");
			}
			outWriter.close();
			System.out.println("Successfully wrote to the file.");
		} catch (IOException e) {
			System.out.println("An error occurred.");
			e.printStackTrace();
		}
	}

	
	public static void main(String[] args) {
		
		if(args.length > 3) {
			System.out.println("More than 2 arguments given! Ignorning unexpected arguments...");
		}
		
		
		else if(args.length == 2) {
			System.out.println("Attempting to consolidate file: "+args[0]);
			try {
				consolidateTTGDFile(Paths.get(args[0]), Paths.get(args[1]));
			} catch (IOException e) {
				e.printStackTrace();
			}
		}
		else if(args.length == 1) {
			System.out.println("Both input file and output file must be specified in order to run with arguments. Stopping.");
		}
		else {
			System.out.println("No arguments given; defaulting to running across scenario folders...");
			consolidateAllTTGDs();
		}
	}
	
}
