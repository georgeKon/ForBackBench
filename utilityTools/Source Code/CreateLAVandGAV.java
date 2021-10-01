

import java.io.*;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.ArrayList;
import java.util.Collections;
import java.util.List;
import java.util.Random;
import java.util.UUID;
import java.util.concurrent.ThreadLocalRandom;
import java.util.stream.Collectors;

public class CreateLAVandGAV {

	
	
	public static void loopThroughScenarios(List<String> scenarios, String createMode) {
		try {
            List<File> dirs = Files.list(Paths.get("scenarios").toAbsolutePath())
            			.filter(Files::isDirectory)
                        .map(Path::toFile)
                        .collect(Collectors.toList());
             
            for (File dir : dirs) {
    			if(scenarios.size() == 0 || scenarios.contains(dir.toString())) {
    				System.out.println("Getting scenario directory "+dir);
            		try {
	        			if(createMode.toLowerCase().equals("lav") || createMode.toLowerCase().equals("both")) {
	        				System.out.println("Creating LAV");
	            			createComplexLAV(Paths.get(dir.getPath()));
	        			}
            		} catch (IOException e) {
            			e.printStackTrace();
            		}
            		catch (Exception e) {
            			e.printStackTrace();
            		}
            		try {
	        			if(createMode.toLowerCase().equals("gav") || createMode.toLowerCase().equals("both")) {
	        				System.out.println("Creating GAV");
	            			createGAV(Paths.get(dir.getPath()));
	        			}
            		} catch (IOException e) {
            			e.printStackTrace();
            		}
            		catch (Exception e) {
            			e.printStackTrace();
            		}
    			}
			}
        } catch (IOException e) {
        	e.printStackTrace();
        }
	}
	

	
	public static void createComplexLAV(Path scenarioPath) throws IOException {
		
		Random random = new Random();
		List<String> lines = Files.readAllLines(scenarioPath.resolve(Paths.get("dependencies", "oneToOne-st-tgds.txt")));

		ArrayList<String> outputs = new ArrayList<String>();

		for (int lineIndex=0; lineIndex<lines.size(); lineIndex++) {
	
			List<String> batch = new ArrayList<String>();
			batch.add(lines.get(lineIndex));
			for(int i=0; i < random.nextInt(5) + 5; i++){ //Random int between 4 and 9;
			
				String l = lines.get(random.nextInt(lines.size()));
				while(l == null || l.equals("") || batch.contains(l)) {
					l = lines.get(random.nextInt(lines.size()));
				}
				batch.add(l);
			}

			
			// Process each batch
			List<String> headAttributes = new ArrayList<String>();
			List<String> bodyAttributes = new ArrayList<String>();
			String newHead = "";
			String bodyName = "";
			for (int batchIndex=0; batchIndex<batch.size(); batchIndex++) {
				String line = batch.get(batchIndex);

				line = line.trim();
				String name = line.split("\\(")[0];
				//Take the name of the first body in the batch
				if(batchIndex == 0) {
					bodyName = name;
				}
				
				for(String function : line.split(" -> ")[1].split(", | .")) {
					newHead += function.split("\\(")[0]+"(";
					for (String attribute : function.split("\\(|\\)")[1].split(","))
					{
						
						//Leave the variables of the initial mapping untouched to ensure we can resolve queries later down the line
						String newAtt = attribute;
						if(batchIndex == 0) {
							bodyAttributes.add(newAtt);
						}
						else {
							//TODO: Should these attributes by unique between each other?
							//TODO: Consider making this a lower change than 50%
							newAtt = random.nextBoolean() ? attribute+ (UUID.randomUUID().toString().replace("-", "")) : attribute;
						}
						
						newHead += newAtt+",";
						if(!headAttributes.contains(newAtt)) {
							headAttributes.add(newAtt);
						}
					}
					newHead = newHead.substring(0, newHead.length()-1);
					
					newHead += "), ";
				}
			}
			newHead = newHead.substring(0, newHead.length()-2)+" .";
			
			//Include a random 30% of the head attributes in the body
			Collections.shuffle(headAttributes);
			float slicePercentage = 0.3f;
			int sliceRange = ((int) (headAttributes.size()*slicePercentage)) >= 1 ? (int) (headAttributes.size()*slicePercentage) : 1;
			headAttributes = headAttributes.subList(0, sliceRange);
			for (String headAttribute : headAttributes) {
				if(!bodyAttributes.contains(headAttribute)) {
					bodyAttributes.add(headAttribute);
				}
			}
			Collections.sort(headAttributes);
			String output = bodyName+"("+String.join(",", bodyAttributes)+") -> "+newHead;
			outputs.add(output);
		}
		
		writeToFile(scenarioPath.resolve(Paths.get("dependencies", "lav.txt")), outputs);
		writeToFile(scenarioPath.resolve(Paths.get("schema", "LAV", "s-schema.txt")), createSchema(outputs));
		
	}
	
	
	public static void createGAV(Path scenarioPath) throws IOException {
	
		Random random = new Random();
		List<String> lines = Files.readAllLines(scenarioPath.resolve(Paths.get("dependencies", "oneToOne-st-tgds.txt")));
		List<String> outputs = new ArrayList<String>(); 
		
		for(int lineNumber=0; lineNumber<lines.size(); lineNumber++) {
			String line = lines.get(lineNumber);
			
			//Get a random batch of 1-4 OTHER bodies
			int batchSize = ThreadLocalRandom.current().nextInt(1, 4 + 1);
			List<Integer> batch = new ArrayList<Integer>(); //Need to use a list for easy .contains checking
			for(int i=0; i<batchSize; i++) {
				
				//Don't duplicate additional bodies (or the original)
				int bodyIndex = random.nextInt(lines.size());
				while(bodyIndex == lineNumber || batch.contains(bodyIndex)) {
					bodyIndex = random.nextInt(lines.size());
					//TODO: This could loop infinitely if the input file only has one line
				}
				batch.add(bodyIndex);
				
				//For each extra line in this batch, strip off the body, and prepend it to the original line
				line = lines.get(bodyIndex).split(" -> ")[0] + " , " + line;
			}
			outputs.add(line);
		}
		
		writeToFile(scenarioPath.resolve(Paths.get("dependencies", "gav.txt")), outputs);
		//TODO: How should GAV schemas be formatted?
		//writeToFile(scenarioPath.resolve(Paths.get("schema", "GAV", "s-schema.txt")), createSchema(outputs));
	}
	
	
	public static void writeToFile(Path outPath, List<String> lines) {
		try {
	      File outFile = new File(outPath.toString());
	      outFile.getParentFile().mkdirs();
	      if (outFile.createNewFile()) {
	        System.out.println("File created: " + outFile.getName());
	      } else {
	        System.out.println("File already exists.");
	      }
	    } catch (IOException e) {
	      System.out.println("An error occurred. Aborting.");
	      e.printStackTrace();
	      return;
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
	
	public static List<String> createSchema(List<String> lines) {
		return createSchema(lines, false);
	}
	
	public static List<String> createSchema(List<String> lines, boolean overwriteNames) {
		List<String> output = new ArrayList<String>();
		int nameIndex = 0;
		for (String line : lines) {
			
			String name = line.split("\\(")[0];
			String[] attributes = line.split("\\(")[1].split("\\)")[0].split(",");
			
			if(overwriteNames) {
				output.add("v"+nameIndex+"{");
			}
			else {
				output.add(name+"{");
			}
			//TODO: Should this take into account variables in the body but not the head (and vice versa)?
			for (int i = 0; i < attributes.length; i++) {
				output.add("\tc"+i+" : STRING,");
			}
			
			String lastLine = output.remove(output.size()-1);
			output.add(lastLine.substring(0, lastLine.length()-1));
			
			output.add("}");
			output.add("");
			nameIndex++;
		}
		return output;
	}
	

	
	public static void main(String[] args) {
		
		List<String> scenarios = new ArrayList<String>();
		String createMode = null;
		
		for(int i=0; i<args.length; i++) {	
			switch(args[i]) {
			
			case "--create":
				createMode = args[i+1];
				break;
			case "--scenario":
				int j = i+1;
				while(j < args.length && !args[j].startsWith("--")) {
					scenarios.add(args[j]);
					j++;
				}
				break;
			}			
		}
		
		
		if(scenarios.size() == 0) {
			System.out.println("No scenario(s) specified; defaulting to running across all.");
		}
		
		if(createMode == null) {
			System.out.println("No create-mode specified; defaulting to creating both LAV and GAV");
			createMode = "both";
		}
		createMode = createMode.toLowerCase();
		if(!(createMode.equals("both") || createMode.equals("gav") || createMode.equals("lav"))) {
			System.out.println("Unknown create-mode \""+createMode+"\" specified. Valid create-modes are \"lav\", \"gav\", or \"both\". Stopping.");
			return;
		}
		
		loopThroughScenarios(scenarios, createMode);
		
	}
	
	
}


