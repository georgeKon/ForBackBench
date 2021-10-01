import org.semanticweb.owlapi.apibinding.OWLManager;
import org.semanticweb.owlapi.model.*;

import com.sun.tools.javac.util.ArrayUtils;

import uk.ac.manchester.cs.owl.owlapi.OWLDataFactoryImpl;
import uk.ac.ox.cs.chaseBench.model.Atom;
import uk.ac.ox.cs.chaseBench.model.Predicate;
import uk.ac.ox.cs.chaseBench.model.Rule;
import uk.ac.ox.cs.chaseBench.model.Term;

import java.io.*;
import java.util.*;
import java.util.stream.Collectors;
import java.util.stream.Stream;
// Convert  L-TGDs to DL-Lite

public class TGDsToOwlConverter {
	private static boolean illegalRule = false;
    public static void main(String[] args) throws Exception {
        if (args.length == 0) {
            System.out.println("Supported options:");
            System.out.println("-t-tgds    <file>  | the file containing the target-to-target TGDs");
            System.out.println("-out       <file>  | the file to print out the owl ontology");
            System.out.println("-stSrc     <file>  | print a file containing 1-1 st-tgds");
        } else {
            String ttgds = null;
            String out = null;
            String stSrc = null;

            for (int i = 0; i < args.length - 1; i += 2) {
                String argument = args[i];
                switch (argument) {
                    case "-t-tgds":
                        ttgds = args[i + 1];
                        break;
                    case "-out":
                        out = args[i + 1];
                        break;
                    case "-stSrc":
                        stSrc = args[i + 1];
                        break;
                    default:
                        System.out.println("Unknown option '" + argument + "'.");
                        break;

                }
            }
            if (out == null) {
                System.out.println("Invalid argument setup: No output location found");
            } else if (ttgds == null) {
                System.out.println("Invalid arguments : No target-to-target TGDs found");
            } else {
                //Gets t-tgds from the file
                List<Rule> tRules = Mappings.getRules(ttgds);
                //Creates and output folder ready to be written to
                File output = new File(out);
                if (!output.exists()) {
                    output.createNewFile();
                }
                FileOutputStream fileOutputStream = new FileOutputStream(output);
                PrintStream printer = new PrintStream(fileOutputStream);
                createHeader(printer);
                Map<Atom, AtomWrapper> atomsMap = new HashMap<>();
                //Adds all atoms from the tgds file
                tRules.forEach(rule -> collectAtoms(atomsMap, rule));

                if (stSrc != null) {
                    FileOutputStream srcOutput = new FileOutputStream(stSrc);
                    PrintStream srcPrinter = new PrintStream(srcOutput);
                    atomsMap.keySet().forEach(atom -> printGenSrc(atom, srcPrinter));
                    srcPrinter.close();
                    srcOutput.close();
                }
                for (Atom name: atomsMap.keySet()){
                    String key = name.toString();
                   // String value = atomsMap.get(name).atom.getPredicate().toString();  
                   // System.out.println(key + " " );  
                } 
                atomsMap.values().forEach(atomWrapper -> printOWLs(atomWrapper, printer));
                createFooter(printer);
                printer.close();
                fileOutputStream.close();
            }
        }
        System.out.println("OWL file created Successfully.");

    }

    static void getAtoms(Rule rule, Set<Atom> atoms) {
        atoms.addAll(Arrays.asList(rule.getBodyAtoms()));
        atoms.addAll(Arrays.asList(rule.getHeadAtoms()));
    }

    private static void printGenSrc(Atom head, PrintStream printer) {
        Predicate predicate = new Predicate("src_" + head.getPredicate().getName());
        Atom body = new Atom(predicate, head.getArguments());
        Rule rule = new Rule(new Atom[]{head}, new Atom[]{body});
        printer.println(rule);
    }

    private static void createHeader(PrintStream printer) {
        printer.println("<?xml version=\"1.0\"?>\n" +
                "<rdf:RDF xmlns=\"http://example.com/example.owl#\" xml:base=\"http://example.com/example.owl\" xmlns:owl=\"http://www.w3.org/2002/07/owl#\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema#\" xmlns:rdf=\"http://www.w3.org/1999/02/22-rdf-syntax-ns#\" xmlns:rdfs=\"http://www.w3.org/2000/01/rdf-schema#\">  \n" +
                "\n" +
                "<owl:Ontology rdf:about=\"http://example.com/example.owl\"/>\n");
    }

    private static void createFooter(PrintStream printer) {
        printer.println("</rdf:RDF>\n");
    }

    //Collect the elements of a rule
    static void collectAtoms(Map<Atom, AtomWrapper> atoms, Rule rule) {

    	Atom body = rule.getBodyAtom(0);
        Atom[] heads = rule.getHeadAtoms();
    	
//       System.out.println("Rule :" +rule.toString());
//       System.out.println("	  body :" +body.toString());
       AtomWrapper wrapper;
       
        if (atoms.containsKey(body))
            wrapper = atoms.get(body);
        else {
            wrapper = new AtomWrapper();
            wrapper.atom = body;
            atoms.put(body, wrapper);
        }
        for (Atom head : heads) {
            if (!atoms.containsKey(head)) {
                wrapper = new AtomWrapper();
                wrapper.atom = head;
                atoms.put(head, wrapper);
            }
        }

        Term bodyDomVar = body.getArgument(0);
        Term bodyRanVar = null;
        if (body.getNumberOfArguments() == 2) {
            bodyRanVar = body.getArgument(1);
        }
        
//  -------- Check if the rule is translatable to OWL or not ------
        boolean isTranslatable = isRuleTranslatable(rule);
        if(!isTranslatable) {
        	System.out.println("The TGDs contains illegal Rule. The owl File can not be created.");
        	System.out.println("The rule: "+rule);
        	System.exit(1);
        }
       
        
// --------------------------------- Check for joins and parts of the rule -----------------------       
    if(heads.length > 1 ) { // if head contains joins, defined part that contains X and Y, part contains only X, part that contain only Y.
    	//System.out.println("Head contains #"+heads.length);
    	
    	Set<Atom> partXY=new HashSet<Atom>();
		Set<Atom> partX= new HashSet<Atom>();
		Set<Atom> partY=new HashSet<Atom>();
		
		Set<Term> partYArgs=new HashSet<Term>();
		Set<Term> partXArgs=new HashSet<Term>();
		
        for (Atom atom : heads) {
        	//System.out.println("Head  #"+atom.toString());

        		//define the part of X , part of Y, part of XY
        		if(atom.getNumberOfArguments()==2) {
        			if ( bodyRanVar != null && (
                		    (atom.getArgument(0).toString().equals(bodyDomVar.toString()) && atom.getArgument(1).toString().equals(bodyRanVar.toString())  ) ||     
                		    (atom.getArgument(1).toString().equals(bodyDomVar.toString()) && atom.getArgument(0).toString().equals(bodyRanVar.toString())  ) )  ){
//                	 System.out.println("I have args X and Y  "+atom.getPredicate().toString()); 
                	 partXY.add(atom);
        			}else if (atom.getArgument(0).toString().equals(bodyDomVar.toString()) || atom.getArgument(1).toString().equals(bodyDomVar.toString())) {
//                     	System.out.println("I have first args X  " +atom.getPredicate().toString());
                     	partX.add(atom);
                     	for(Term t:atom.getArguments())
                     		partXArgs.add(t);

                     }else if (bodyRanVar != null && ( atom.getArgument(0).toString().equals(bodyRanVar.toString()) || atom.getArgument(1).toString().equals(bodyRanVar.toString()) )) {
//                     	System.out.println("I have second args Y  "+atom.getPredicate().toString());
                     	partY.add(atom);
                     	for(Term t:atom.getArguments())
                     		partYArgs.add(t);
                     }
        		}else{
        			if (atom.getArgument(0).toString().equals(bodyDomVar.toString()) ) {
//                     	System.out.println("I have first args X  " +atom.getPredicate().toString());
                     	partX.add(atom);
                     	for(Term t:atom.getArguments())
                     		partXArgs.add(t);

                     }else if (bodyRanVar != null && ( atom.getArgument(0).toString().equals(bodyRanVar.toString())) ) {
//                     	System.out.println("I have second args Y  "+atom.getPredicate().toString());
                     	partY.add(atom);
                     	for(Term t:atom.getArguments())
                     		partYArgs.add(t);
                     }
        			
        		}//if number args ==2
            
        	}//end defined the parts
        
//       //check for illegall rule cases
//        for(Term t: partXArgs) {
//        	if(partYArgs.contains(t)) {
//        		System.out.println("The TGDs contains illegal Rule. The owl File can not be created.");
//       		 	System.out.println(" --two parts that contain x and y share at least a variable with each other");
//       		 	System.exit(1);
//       		 	illegalRule =true;
//        	}
//        }
//        	
        //search for joins
        //get all atoms of the heads except the ones that contains both X and Y
        ArrayList<Atom> headsWithoutXY  = new ArrayList<Atom>();
        for(Atom atom:heads) {
        	if(!partXY.contains(atom)) {
        		headsWithoutXY.add(atom);
        	}
        }
        Atom[] headsWithoutXYAsArr = new Atom[headsWithoutXY.size()];
        headsWithoutXY.toArray(headsWithoutXYAsArr);
        
        if(!partX.isEmpty()) {
        	Atom[] singleXRule = bulidPart(partX, headsWithoutXYAsArr, body, atoms, 1 );
        	if(singleXRule.length>0)
        		collectSingleRuleAtoms( singleXRule,  body,  atoms,  wrapper,  bodyDomVar,  bodyRanVar);

//        	if(illegalRule) {
//    			return;
//    		}
       }
        if(!partY.isEmpty()) {
        	Atom[] singleYRule =bulidPart(partY,  headsWithoutXYAsArr, body, atoms, 2 );
        	
        	if(singleYRule.length>0)
        		collectSingleRuleAtoms( singleYRule,  body,  atoms,  wrapper,  bodyDomVar,  bodyRanVar);

//        	if(illegalRule) {
//    			return;
//    		}
        }
// 
// ------------- END .. Check for joins and illegal Rules ----------------           
//        
//
//       
        Atom[] partXYAsArr = new Atom[partXY.size()];
        partXY.toArray(partXYAsArr);
        collectSingleRuleAtoms( partXYAsArr,  body,  atoms,  wrapper,  bodyDomVar,  bodyRanVar);
//        
//        for (Atom atom : partX) {
//      	   System.out.println("Xxxxxx Atoms :: " +atom.toString());
//      	   // build intersect in domain
//        }
//        for (String s : atoms.get(body).nestedDomRestriction) {
//       	   System.out.println("Xxxxxx s :: " +s);
//       	   // build intersect in domain
//         }
//        for (Atom atom : partY) {
//       	   System.out.println("Yyyyyy Atoms :: " +atom.toString());
//       	   //Build intersect in Range
//         }
//      
    }//END..  if head contains joins
        	
 
    
 // --------------------------------- Rule that don't contains joins -----------------------       
        if(heads.length == 1 || body.getNumberOfArguments() == 1) {
        	collectSingleRuleAtoms( heads,  body,  atoms,  wrapper,  bodyDomVar,  bodyRanVar);
    	}
   
    }
    
    private static void collectSingleRuleAtoms(Atom[] heads, Atom body, Map<Atom, AtomWrapper> atoms, AtomWrapper wrapper, Term bodyDomVar, Term bodyRanVar) {
        for (Atom atom : heads) { 	
//        	System.out.println("	head :" +atom.toString());
            if (atom.getNumberOfArguments() == 2) {
            	
        
            	
                if (subClassOf(atom, body)) {
                
                    atoms.get(body).subProperty.add(atom.getPredicate().getName());

                	//System.out.println("atoms.body: " + atoms.get(body).atom.getPredicate().getName()+ "-- subclass: "+atoms.get(body).subProperty);
                }
                
                if (inverseOf(atom, body)) {
                
                   atoms.get(body).inverseOf.add( atom.getPredicate().getName() );
               		createInverseProperty(atom, atoms );
                 
                	//System.out.println("atoms.body: " + atoms.get(body).atom.getPredicate().getName()+ "-- has inverse: "+atoms.get(body).inverseOf);
                //	System.out.println("wrapper.inverseOf: " + wrapper.inverseOf + "-- has inverse: "+body.getPredicate().getName());

                }
                
                if(atom.getNumberOfArguments() > body.getNumberOfArguments()) {
                    if (atom.getArgument(0).toString().equals(bodyDomVar.toString())) {//A(x) -> P(x,y)
                    	 atoms.get(body).subClassWtihRestriction.add( atom.getPredicate().getName());
                    	 
                    	 String ran = atom.getArgument(1).toString();
                         for (Atom atom2 : heads) {
                             if (atom2.getNumberOfArguments() == 1 && atom2.getArgument(0).toString().equals(ran)) {
                            	 atoms.get(body).subClassWtihRestrictionSomeValues.add( atom2.getPredicate().getName() );
                            // 	System.out.println("atom2 arg 0 == atom range var 2nd args: " + wrapper.ranSomValues + "-- some values: "+atom2.getPredicate().getName());


                             }
                         }
                    //	 System.out.println("yes"+ atoms.get(body).subClassWtihRestriction);
                    }else {
                    	
                    } if (atom.getArgument(1).toString().equals(bodyDomVar.toString())) {//A(x) -> P(y, x) .
                    	atoms.get(body).subClassWtihRestriction.add( "io_"+atom.getPredicate().getName());
                    }
                }
                
//           
                if (bodyRanVar != null) {
                    if (atom.getArgument(0).toString().equals(bodyRanVar.toString())) {
                    	//System.out.println("atom arg 0 = body range var: " + wrapper.ranOnProp + "-- has range on prob: "+atom.getPredicate().getName());

                        String ran = atom.getArgument(1).toString();
                        for (Atom atom2 : heads) {
                            if (atom2.getNumberOfArguments() == 1 && atom2.getArgument(0).toString().equals(ran)) {
                                wrapper.ranSomValues.add( atom2.getPredicate().getName() );
                           // 	System.out.println("atom2 arg 0 == atom range var 2nd args: " + wrapper.ranSomValues + "-- some values: "+atom2.getPredicate().getName());


                            }
                        }
                    }
                    
                    if( atom.getArgument(0).toString().equals(bodyDomVar.toString()) && 
                        !atom.getArgument(1).toString().equals(bodyRanVar.toString())) { //R(x,y) -> P(x,z).
                          atoms.get(body).domRestriction.add(atom.getPredicate().getName());
                        }
                    
                    if( !atom.getArgument(0).toString().equals(bodyDomVar.toString()) &&
                    	!atom.getArgument(0).toString().equals(bodyRanVar.toString()) &&
                            atom.getArgument(1).toString().equals(bodyDomVar.toString()) ) { //R(x,y) -> P(z,x).
                              atoms.get(body).domRestriction.add("io_"+atom.getPredicate().getName());
                            }
                    
                    if( atom.getArgument(0).toString().equals(bodyRanVar.toString()) && 
                    	! atom.getArgument(1).toString().equals(bodyDomVar.toString()) ) {  //R(y,x) -> P(x, z) .
                           atoms.get(body).ranRestriction.add(atom.getPredicate().getName());
                    }
                    
                  
                    if(!atom.getArgument(0).toString().equals(bodyDomVar.toString()) &&
                       !atom.getArgument(0).toString().equals(bodyRanVar.toString()) &&
                       !atom.getArgument(1).toString().equals(bodyDomVar.toString())  &&
                       atom.getArgument(1).toString().equals(bodyRanVar.toString()) ) {  //R(y,x) -> P(z,x) .
                               atoms.get(body).ranRestriction.add("io_"+atom.getPredicate().getName());
                        }
                    
                }
                
               


            } else {
                if (atom.getArgument(0).toString().equals(bodyDomVar.toString())) {//R(x,y) -> B(x) .
                	 
                	atoms.get(body).regDom.add( atom.getPredicate().getName());
                }else if (bodyRanVar != null && atom.getArgument(0).toString().equals(bodyRanVar.toString())) { //R(y,x) -> B(x) .
                	atoms.get(body).regRan.add( atom.getPredicate().getName());
                	
                }
                if (subClassOf(atom, body)) {             
                	atoms.get(body).subProperty.add(atom.getPredicate().getName());
                }
                
            }//else
        }
    	
    }


	private static boolean subClassOf(Atom atom, Atom body) {
        Term[] atomArgs = atom.getArguments();
        Term[] bodyArgs = body.getArguments();
        if (atomArgs.length != bodyArgs.length) {
            return false;
        } else {
            for (int i = 0; i < atomArgs.length; i++) {
                if (atomArgs[i] != bodyArgs[i])
                    return false;
            }
        }
        return true;
    }

    private static boolean inverseOf(Atom atom, Atom body) {
        Term[] atomArgs = atom.getArguments();
        Term[] bodyArgs = body.getArguments();
        if (atomArgs.length != bodyArgs.length) {
            return false;
        } else {
            for (int i = 0; i < atomArgs.length; i++) {
                if (atomArgs[i] != bodyArgs[bodyArgs.length-1-i])
                    return false;
            }
        }
        return true;
    }
    
   private static void createInverseProperty(Atom atom, Map<Atom, AtomWrapper> atoms ) {
		 //create an inverse property for the atom. 
	   	Term[] predTerms =atom.getArguments();
	   	List<Term> invTermsAsList = Arrays.asList(predTerms);
	    Collections.reverse(invTermsAsList);
	    Term[] invTerms = new Term[invTermsAsList.size()];
	    invTerms = invTermsAsList.toArray(invTerms);

	   	Predicate invPred = new Predicate("io_"+atom.getPredicate().getName());
	   	Atom invAtom = new Atom(invPred, invTerms);
	   	AtomWrapper invWrapper;
	   	if(atoms.containsKey(invAtom)) {
	       	invWrapper = atoms.get(invAtom);
	        invWrapper.invProperty.add(atom.getPredicate().getName());
	   	}else {
	   		invWrapper = new AtomWrapper();
	   		invWrapper.atom = invAtom;
	        invWrapper.invProperty.add(atom.getPredicate().getName());
	        atoms.put(invAtom, invWrapper);
	   	}
   	
   }
    
    private static Atom[] bulidPart(Set<Atom> part, Atom[] heads, Atom body, Map<Atom, AtomWrapper> atoms, int partName) {
    	Set<Atom> joinAtoms = new HashSet<Atom>();
    	ArrayList<Atom> singleAtomRule = new ArrayList<Atom>();
    	
//    	for (Atom atom : part) {
//    		System.out.println("-------: "+ atom.getPredicate().getName());
//
//    	}
    	for (Atom atom : part) {
//    		System.out.println("I am the 1st : "+ atom.getPredicate().getName());
    		Set<Atom> joinAtoms1 = checKJoins(atom, part,  heads, body, atoms, partName, 1  );
//    		System.out.println("newPartatoms : "+ joinAtoms1.size());

    		if(!joinAtoms1.isEmpty()) {
    			joinAtoms.addAll(joinAtoms1);
//    			System.out.println("newXatoms : "+ joinAtoms.size());

    		}else {//check if the atom already is added to the newPartAtoms
    			if(!joinAtoms.contains(atom)) {
    				//return this atom to treat it as single atom rule  
    				singleAtomRule.add(atom);
//    				System.out.println("single : "+ atom.getPredicate().getName());
    			}
    		}
//    		if(illegalRule) {
//    			return;
//    		}
    	}
		

//		System.out.println("------------------------------ loop : ");

    	while(!joinAtoms.isEmpty()) {
//    		System.out.println("--- newXAtom loop : ");

    		for (Atom atom : joinAtoms) {
//        		System.out.println("I am the 2nd : "+ atom.getPredicate().getName());

//    			if(atom.getNumberOfArguments()==2) {
    				joinAtoms = checKJoins(atom, part,  heads, body, atoms, partName, 2 ) ;
//    				joinAtoms.remove(atom);
//    				if(illegalRule) {
//    	    			return;
//    	    		}
//    			}else {
//    				joinAtoms.remove(atom);
//    			}
    		}
    	}
//    	System.out.println("========================================= loop : ");
//    	for(String sub: atoms.get(body).nestedRanRestriction) {
//    		System.out.println("======="+sub);
//    	}
    	  Atom[] singleAtomRuleAsArray = new Atom[singleAtomRule.size()];
    	  singleAtomRule.toArray(singleAtomRuleAsArray);
    	  return singleAtomRuleAsArray;
    }
    
    private static Set<Atom> checKJoins(Atom atom, Set<Atom> part, Atom[] heads, Atom body, Map<Atom, AtomWrapper> atoms, int partName, int atomLocation ) {
    	Set<Atom> newPartAtom=new HashSet<Atom>();

    	String atomName = atom.getPredicate().getName();
    	String atomArg1 = atom.getArgument(0).toString();
    	String atomArg2=null;
    	if(atom.getNumberOfArguments()>1)
    		 atomArg2= atom.getArgument(1).toString();
    	outerLoop://Label
    	for (Atom atom2 : heads) {
//	  	   System.out.println(atom.toString()+": looking for joins  with " +atom2.toString());
 	    	String atom2Name =  atom2.getPredicate().getName();

	  	    if(atom2.getNumberOfArguments()==2) { 
//	  	    	 System.out.println("inside");
//		        	 if (inverseOf(atom, atom2)) {
//		        		 System.out.println("The TGDs contains illegal Rule. The owl File can not be created.");
//		        		 System.out.println(" --contains a join of two binary atoms in both attribute positions ("+ atom+", "+atom2+")");
//		        		 System.exit(1);
//		        		 illegalRule =true;
//		        		 break outerLoop;
//		        	 }
	  	    	if (atom2.getArgument(0).toString().equals(atomArg2) && !atom2Name.equals(atomName)) {
//	 	  	    	System.out.println("yes, they joins " +atom2.toString());
//	 	  	        part.add(atom2);
	 	  	        newPartAtom.add(atom2);
	 	  	       
		 	  	    if(partName == 1) {
//		 	  	    	atoms.get(body).nestedDomRestriction.add(atom.getPredicate().toString());
//		 	    		atoms.get(body).nestedDomRestriction.add(atom2.getPredicate().toString());
//		 	    		
		 	    		if(atomLocation == 1) {//if it is the first atom in the join list
		 	    			Set<String> temp =   new LinkedHashSet();
		 	    			temp.add(atom.getPredicate().toString());
		 	    			temp.add(atom2.getPredicate().toString());
		 	    			atoms.get(body).nestedDomRestriction1.add(temp);
			 	    		
		 	    		}else if(atomLocation == 2) {
		 	    		for(Set<String> tempSet : atoms.get(body).nestedDomRestriction1) {
		 	    			if(tempSet.contains(atom.getPredicate().toString())) {
		 	    				tempSet.add(atom2.getPredicate().toString());
				 	    		
		 	    			}
		 	    		}
		 	    		}
				
		 	    		
		 	    	}else if(partName==2) {
//		 	    		atoms.get(body).nestedRanRestriction.add(atom.getPredicate().toString());
//		 	    		atoms.get(body).nestedRanRestriction.add(atom2.getPredicate().toString());
		 	    		if(atomLocation == 1) {//if it is the first atom in the join list
		 	    			Set<String> temp =   new LinkedHashSet();
		 	    			temp.add(atom.getPredicate().toString());
		 	    			temp.add(atom2.getPredicate().toString());
		 	    			
		 	    			atoms.get(body).nestedRanRestriction1.add(temp);
			 	    		
		 	    		}else if(atomLocation == 2) {
		 	    		for(Set<String> tempSet : atoms.get(body).nestedRanRestriction1) {
		 	    			if(tempSet.contains(atom.getPredicate().toString())) {
		 	    				tempSet.add(atom2.getPredicate().toString());
				 	    		
		 	    			}
		 	    		}
		 	    		}
//		 	    		System.out.println("adww" );
		 	    	}
	 	  	    }
	  	    }else {//if atom2 is unary
//	  	    	if ( (atom2.getArgument(0).toString().equals(atomArg1) || atom2.getArgument(0).toString().equals(atomArg2) ) 
//	  	    			&&  !atom2Name.equals(atomName)) {
	  	     	if ( ( atom2.getArgument(0).toString().equals(atomArg2) ) 
	  	    			&&  !atom2Name.equals(atomName)) {
//	 	  	      System.out.println("yes, they joins unary" +atom2.toString());
//	 	  	        part.add(atom2);
	 	  	        newPartAtom.add(atom2);

		 	  	     if(partName==1) {
//		 	    		atoms.get(body).nestedDomIntersect.add(atom2.getPredicate().toString());
//		 	    		if(atoms.get(body).nestedDomRestriction.isEmpty()) {
//			 	  	    atoms.get(body).nestedDomRestriction.add(atom.getPredicate().toString());
//		 	    		}
		 	  			Set<String> temp =   new LinkedHashSet();
		 	    		temp.add(atom2.getPredicate().toString());
		 	    		temp.add(atom.getPredicate().toString());
		 	    		atoms.get(body).nestedDomIntersect1.add(temp);
		 	    		if(atoms.get(body).nestedDomRestriction1.isEmpty()) {
		 	    			Set<String> temp1 =   new LinkedHashSet();
		 	    			temp1.add(atom.getPredicate().toString());
		 	    			atoms.get(body).nestedDomRestriction1.add(temp1);
		 	    		}
	 	    				
		 	    	}else if(partName==2) {
		 	    		Set<String> temp =   new LinkedHashSet();
		 	    		temp.add(atom2.getPredicate().toString());
		 	    		temp.add(atom.getPredicate().toString());
		 	    		atoms.get(body).nestedRanIntersect1.add(temp);
		 	    		if(atoms.get(body).nestedRanRestriction1.isEmpty()) {
		 	    			Set<String> temp1 =   new LinkedHashSet();
		 	    			temp1.add(atom.getPredicate().toString());
		 	    			atoms.get(body).nestedRanRestriction1.add(temp1);
		 	    		}
//		 	    	   atoms.get(body).nestedRanIntersect.add(atom2.getPredicate().toString());
		 	    	
//		 	    	  System.out.println("ad" );
//		 	    	 if(atoms.get(body).nestedRanRestriction.isEmpty()) {
//			 	  	    atoms.get(body).nestedRanRestriction.add(atom.getPredicate().toString());
//		 	    		}
		 	    	}
	 	  	    }
	  	    }
	  	   
	    }
	  return  newPartAtom;  	     	   
	    
    }

    
    //Prints the atoms out
    private static void printOWLs(AtomWrapper atomWrapper, PrintStream print) {
        Atom body = atomWrapper.atom;
       // System.out.println("print body " +body);
        if (body.getNumberOfArguments() == 2) {
            print.println("<owl:ObjectProperty rdf:about=\"#" + body.getPredicate().getName() + "\">");
            if ( !atomWrapper.subProperty.isEmpty()) {
            	 for(String sub: atomWrapper.subProperty) 
            		 print.println("<rdfs:subPropertyOf rdf:resource=\"#" + sub + "\"/>");
            }
            if (!atomWrapper.inverseOf.isEmpty()) {
            	
            	for(String sub: atomWrapper.inverseOf) {
//            		 print.println("<owl:inverseOf rdf:resource=\"#" + sub + "\"/>");
            		print.println("<rdfs:subPropertyOf rdf:resource=\"#io_" + sub + "\"/>");
            		//System.out.println(sub);
            	}
            }
           
            //if (atomWrapper.regDom != null) {
            if (!atomWrapper.regDom.isEmpty()) {
            	for(String sub: atomWrapper.regDom) 
            		print.println("<rdfs:domain rdf:resource=\"#" + sub + "\"/>");
       //     } else if (atomWrapper.domOnProp != null) {
            } else if (!atomWrapper.domOnProp.isEmpty()) {
                print.println("<rdfs:domain>");
                print.println("<owl:Restriction>");
                for(String sub: atomWrapper.domOnProp) {
                	print.println("<owl:onProperty rdf:resource=\"#" + sub + "\"/>");
                	print.println("<owl:someValuesFrom rdf:resource=\"http://www.w3.org/2002/07/owl#Thing\"/>");
                }
                print.println("</owl:Restriction>");
                print.println("</rdfs:domain>");
            }

            if (!atomWrapper.regRan.isEmpty()) {
            	for(String sub: atomWrapper.regRan) 
            		print.println("<rdfs:range rdf:resource=\"#" + sub + "\"/>");
            } else if (!atomWrapper.ranOnProp.isEmpty()) {
                print.println("<rdfs:range>");
                print.println("<owl:Restriction>");
                
                for(String sub: atomWrapper.ranOnProp) 
                	print.println("<owl:onProperty rdf:resource=\"#" + sub + "\"/>");
                
                if ( !atomWrapper.ranSomValues.isEmpty() ) {
                	for(String sub: atomWrapper.ranSomValues) 
                		print.println("<owl:someValuesFrom rdf:resource=\"#" + sub + "\"/>");
                }
                print.println("</owl:Restriction>");
                print.println("</rdfs:range>");
            }
            
            if (!atomWrapper.subClassWtihRestriction.isEmpty()) {
            	for(String sub: atomWrapper.subClassWtihRestriction) {
	                print.println("<rdfs:subClassOf>");
	                print.println("<owl:Restriction>");  
                	print.println("<owl:onProperty rdf:resource=\"#" + sub + "\"/>");
                	print.println("<owl:someValuesFrom rdf:resource=\"http://www.w3.org/2002/07/owl#Thing\"/>");
                	print.println("</owl:Restriction>");
                	print.println("</rdfs:subClassOf>");
            	}
            	
            
            }
           
//            if (!atomWrapper.nestedDomRestriction.isEmpty()) {
//            	print.println("<rdfs:domain>");
//            	int domCount =0;
//                	for(String sub: atomWrapper.nestedDomRestriction) {
//    	                print.println("<owl:Restriction>");  
//                    	print.println("<owl:onProperty rdf:resource=\"#" + sub + "\"/>");
//                    	if (!atomWrapper.nestedDomIntersect.isEmpty() || domCount < atomWrapper.nestedDomRestriction.size()-1) {
//                    		print.println("<owl:someValuesFrom>");
//                    	}else {
//                        	print.println("<owl:someValuesFrom rdf:resource=\"http://www.w3.org/2002/07/owl#Thing\">");
//                    	}
//                    	domCount++;
//                	}
//                	 if (!atomWrapper.nestedDomIntersect.isEmpty()) {
//                		 
//                		 if (atomWrapper.nestedDomIntersect.size()>1) {
//                			 print.println("<owl:intersectionOf>");
//                		 }
//                		 
//                		 for(String sub: atomWrapper.nestedDomIntersect) {
//                			 print.println("<owl:Class rdf:about=\"#" + sub + "\"/>");
//                     	}
//                		 if (atomWrapper.nestedDomIntersect.size()>1) {
//                			print.println("</owl:intersectionOf>");  
//                		 }
//
//    	            		
//                	 }
//                	domCount =0;
//                	for(String sub: atomWrapper.nestedDomRestriction) {
//                    	if (!atomWrapper.nestedDomIntersect.isEmpty() || domCount < atomWrapper.nestedDomRestriction.size()) { 
//                    		print.println("</owl:someValuesFrom>");
//                    	}
//                    	print.println("</owl:Restriction>");
//                    	domCount++;
//                	}
//                	print.println("</rdfs:domain>");
//            	}//end nestedDom
//            	
            
        	 if (!atomWrapper.nestedDomRestriction1.isEmpty() ) {
         		 for(Set<String> innerSet: atomWrapper.nestedDomRestriction1 ) {
         			 print.println("<rdfs:domain>");
         			int domCount=0;
                 	for(String sub: innerSet) {
     	                print.println("<owl:Restriction>");  
                     	print.println("<owl:onProperty rdf:resource=\"#" + sub + "\"/>");
                     	if (!atomWrapper.nestedDomIntersect1.isEmpty() || domCount < innerSet.size()-1) {
                     		print.println("<owl:someValuesFrom>");
                     	}else {
                         	print.println("<owl:someValuesFrom rdf:resource=\"http://www.w3.org/2002/07/owl#Thing\">");
                     	}
                     	domCount++;
                 	}
                 	
                 	if (!atomWrapper.nestedDomIntersect1.isEmpty()) {
                 		boolean hasIntersection = false;
                 		 Set<String> intersectClasses = new HashSet<String>();
                		//check if this related to the current range element
                		 for(Set<String> innerIntersectSet: atomWrapper.nestedDomIntersect1 ) {
                			 Set<String> intersection = new HashSet<String>(innerSet); 
                			 intersection.retainAll(innerIntersectSet);

                			 if(!intersection.isEmpty()) {
                				 innerIntersectSet.removeAll(intersection);
                				 intersectClasses.addAll(innerIntersectSet);
                			 }
                		}
                		 if (intersectClasses.size()>1) {
                			 print.println("<owl:intersectionOf>");
                		 }
                		 
                		 for(String sub: intersectClasses) {
                			 print.println("<owl:Class rdf:about=\"#" + sub + "\"/>");
                			 hasIntersection = true;
                     	}
                		 
                		if (intersectClasses.size()>1) {
    	            		print.println("</owl:intersectionOf>");  
                		}
                		 if(!hasIntersection) {
            				 print.println("<owl:Class rdf:about=\"http://www.w3.org/2002/07/owl#Thing\"/>"); 

                		 }
                 		
                   }//end if nestedRanIntersect1
                	 domCount=0;
                	for(String sub: innerSet) {
                		if (!atomWrapper.nestedDomIntersect1.isEmpty() || domCount < innerSet.size() )
                			print.println("</owl:someValuesFrom>");
                    	print.println("</owl:Restriction>");
                	}
                	print.println("</rdfs:domain>");
         		 }    	 
             }
            
            
            
         	if(!atomWrapper.domRestriction.isEmpty()) {
         		
        		for(String sub: atomWrapper.domRestriction) {
        			print.println("<rdfs:domain>");
	                print.println("<owl:Restriction>");  
                	print.println("<owl:onProperty rdf:resource=\"#" + sub + "\"/>");
                	print.println("<owl:someValuesFrom rdf:resource=\"http://www.w3.org/2002/07/owl#Thing\">");
                	print.println("</owl:someValuesFrom>");
                	print.println("</owl:Restriction>");
                	print.println("</rdfs:domain>");
        		}
        		
        	}
        	
        	
         		
        	
//            if (!atomWrapper.nestedRanRestriction.isEmpty() ) {
//            	print.println("<rdfs:range>");
//            	int ranCount=0;
//                	for(String sub: atomWrapper.nestedRanRestriction) {
//    	                print.println("<owl:Restriction>");  
//                    	print.println("<owl:onProperty rdf:resource=\"#" + sub + "\"/>");
//                    	if (!atomWrapper.nestedRanIntersect.isEmpty() || ranCount < atomWrapper.nestedRanRestriction.size()-1) {
//                    		print.println("<owl:someValuesFrom>");
//                    	}else {
//                        	print.println("<owl:someValuesFrom rdf:resource=\"http://www.w3.org/2002/07/owl#Thing\">");
//                    	}
//                    	ranCount++;
//                	}
//                	
//                	 if (!atomWrapper.nestedRanIntersect.isEmpty()) {
//                		 if (atomWrapper.nestedRanIntersect.size()>1) {
//                			 print.println("<owl:intersectionOf>");
//                		 }
//                		 
//                		 for(String sub: atomWrapper.nestedRanIntersect) {
//                			 print.println("<owl:Class rdf:about=\"#" + sub + "\"/>");
//                     	}
//                		 
//                		if (atomWrapper.nestedRanIntersect.size()>1) {
//    	            		print.println("</owl:intersectionOf>");  
//                		}
//                	 }
//                	 ranCount=0;
//                	for(String sub: atomWrapper.nestedRanRestriction) {
//                		if (!atomWrapper.nestedRanIntersect.isEmpty() || ranCount < atomWrapper.nestedRanRestriction.size() )
//                			print.println("</owl:someValuesFrom>");
//                    	print.println("</owl:Restriction>");
//                	}
//                	print.println("</rdfs:range>");
//            }
         	
         	 if (!atomWrapper.nestedRanRestriction1.isEmpty() ) {
         		 for(Set<String> innerSet: atomWrapper.nestedRanRestriction1 ) {
         			 print.println("<rdfs:range>");
         			int ranCount=0;
                 	for(String sub: innerSet) {
     	                print.println("<owl:Restriction>");  
                     	print.println("<owl:onProperty rdf:resource=\"#" + sub + "\"/>");
                     	if (!atomWrapper.nestedRanIntersect1.isEmpty() || ranCount < innerSet.size()-1) {
                     		print.println("<owl:someValuesFrom>");
                     	}else {
                         	print.println("<owl:someValuesFrom rdf:resource=\"http://www.w3.org/2002/07/owl#Thing\">");
                     	}
                     	ranCount++;
                 	}
                 	
                	if (!atomWrapper.nestedRanIntersect1.isEmpty()) {
                 		boolean hasIntersection = false;
                 		 Set<String> intersectClasses = new HashSet<String>();
                		//check if this related to the current range element
                		 for(Set<String> innerIntersectSet: atomWrapper.nestedRanIntersect1 ) {
                			 Set<String> intersection = new HashSet<String>(innerSet); 
                			 intersection.retainAll(innerIntersectSet);

                			 if(!intersection.isEmpty()) {
                				 innerIntersectSet.removeAll(intersection);
                				 intersectClasses.addAll(innerIntersectSet);
                			 }
                		}
                		 if (intersectClasses.size()>1) {
                			 print.println("<owl:intersectionOf>");
                		 }
                		 
                		 for(String sub: intersectClasses) {
                			 print.println("<owl:Class rdf:about=\"#" + sub + "\"/>");
                			 hasIntersection = true;
                     	}
                		 
                		if (intersectClasses.size()>1) {
    	            		print.println("</owl:intersectionOf>");  
                		}
                		 if(!hasIntersection) {
            				 print.println("<owl:Class rdf:about=\"http://www.w3.org/2002/07/owl#Thing\"/>"); 

                		 }
                 		
                   }//end if nestedRanIntersect1
                	 ranCount=0;
                	for(String sub: innerSet) {
                		if (!atomWrapper.nestedRanIntersect1.isEmpty() || ranCount < innerSet.size() )
                			print.println("</owl:someValuesFrom>");
                    	print.println("</owl:Restriction>");
                	}
                	print.println("</rdfs:range>");
         		 }    	 
             }
            
        	if(!atomWrapper.ranRestriction.isEmpty()) {
        		for(String sub: atomWrapper.ranRestriction) {
        			print.println("<rdfs:range>");
	                print.println("<owl:Restriction>");  
                	print.println("<owl:onProperty rdf:resource=\"#" + sub + "\"/>");
                	print.println("<owl:someValuesFrom rdf:resource=\"http://www.w3.org/2002/07/owl#Thing\">");
                	print.println("</owl:someValuesFrom>");
                	print.println("</owl:Restriction>");
                	print.println("</rdfs:range>");
        		}
        	}
            
            if (!atomWrapper.invProperty.isEmpty()) {
            	for(String sub: atomWrapper.invProperty) {
            		 print.println("<owl:inverseOf rdf:resource=\"#" + sub + "\"/>");
            	}
            		
          }
            
            print.println("</owl:ObjectProperty>");



        } else {
            print.println("<owl:Class rdf:about=\"#" + body.getPredicate().getName() + "\">");

            if (!atomWrapper.subProperty.isEmpty()) {
                for(String sub: atomWrapper.subProperty) {
                    print.println("<rdfs:subClassOf rdf:resource=\"#" + sub + "\"/>");
                }
            } 
//    
            if (!atomWrapper.subClassWtihRestriction.isEmpty()) {
            	for(String sub: atomWrapper.subClassWtihRestriction) {
	                print.println("<rdfs:subClassOf>");
	                print.println("<owl:Restriction>");  
                	print.println("<owl:onProperty rdf:resource=\"#" + sub + "\"/>");
                	if ( !atomWrapper.subClassWtihRestrictionSomeValues.isEmpty() ) {
                       for(String sub1: atomWrapper.subClassWtihRestrictionSomeValues) 
                         		print.println("<owl:someValuesFrom rdf:resource=\"#" + sub1 + "\"/>");
                     }else {
                     	print.println("<owl:someValuesFrom rdf:resource=\"http://www.w3.org/2002/07/owl#Thing\"/>");

                     }
                	print.println("</owl:Restriction>");
                	print.println("</rdfs:subClassOf>");
            	}
            }
            print.println("</owl:Class>");
            
        }
    }
    
/**
* Method that check conditions of translating TGDs to DL-Lite
   * Input: The TGD rule  
   * Output: (true) if the rule is translatable 
   *        (false) if the rule is not translatable 
   *
   * @return a boolean (true) if the rule is translatable 
   *               (false) if the rule is not translatable 
   *  
   */
   public static boolean isRuleTranslatable(Rule rule ) {
	   boolean isTranslatable = true; 
	   Atom body = rule.getBodyAtom(0);
	  
	   //--First condition: does not contain cycles that go through existential nodes 
	    boolean hasCycle = 	UndirectedGraph.drawUndirectedPJgraph(rule);
//	   System.out.println("Body:"+body);
//	   System.out.println("Cycle Nodes:"+UndirectedGraph.cycleNodes);
	    if(hasCycle) {
	    	boolean isArgsExistential = checkCycleArgruments(UndirectedGraph.cycleNodes, body);
	    	if(isArgsExistential) {
	    		isTranslatable = false;
	    		System.out.println("The rule contains cycle with Existentail Argument. ");
	    	}
	    	
	    }else {
	    	 //--Second condition: contains at least one universal variable node in the head.
		    
			Atom[] heads = rule.getHeadAtoms();
		    boolean isHeadContainsUniversal = checkUniversalArgsInHead(body, heads);
			if(!isHeadContainsUniversal) {
				isTranslatable = false;
	    		System.out.println("The head of the rule does not contain universal Argument. ");
			}
	    }
	    
	   return isTranslatable;
	    
   }
    
   
    
    /**
	* Method that check if the nodes that form a cycle are existential or not
    * Input: the node of the cycle and the body atom  
    * Output: (true) if the cycle contains an existential variable 
    *        (false) if the cycle does not contain an existential variable 
    *
    * @return a boolean (true) if the cycle contains an existential variable 
    *                  (false) if the cycle does not contain an existential variable
    * 
    */
    public static boolean checkCycleArgruments(LinkedHashSet<String> cycleNodes, Atom body) {
    	boolean  isArgsExistential = false; 
    	System.out.println("CYCLE");
    	Term[] bodyArgs = body.getArguments();
    	String bodyAtomName = body.getPredicate().getName();
    	List<String> bodyArgsList = new ArrayList<String>();
    	for(Term arg : bodyArgs) {
    		bodyArgsList.add(arg.toString());
    	}

    	for(String nodeName: cycleNodes) {
    		if(!bodyArgsList.contains(nodeName) && bodyAtomName!=nodeName) {
    			System.out.println("Existentail Arg: "+nodeName);
    			return true;
    		}
    	}
    	
    	return isArgsExistential;
    }
    
    /**
  	* Method that check if head contains at least one universal variable
      * Input: the body atom and array of head atoms 
      * Output: (true) if head contains at least one universal variable 
      *        (false) if head does not contain at least one universal variable 
      *
      * @return a boolean (true) if head contains at least one universal variable 
      *                  (false) if head does not contain at least one universal variable
      * 
      */
      public static boolean checkUniversalArgsInHead(Atom body, Atom[] heads) {
      	boolean  isHeadHasUniversal = false; 
      	
//    	System.out.println("Body  "+ body.getPredicate().getName());

      	Term[] bodyArgs = body.getArguments();
      	List<Term> bodyArgsList = new ArrayList<>(Arrays.asList(bodyArgs));
           	
      	for(Atom head:heads) {
      		for(Term headArg: head.getArguments()) {
      			if(bodyArgsList.contains(headArg)) {
//      		    	System.out.println("head arg "+ headArg);

      				return true;
      			}
      		}
      	}
      	
      
      	return isHeadHasUniversal;
      }
}

//Quick class that contains info to create the properties of the atom in the ontology
class AtomWrapper {
    Atom atom = null;
   // String ranOnProp = null;
    Set<String> ranOnProp = new HashSet<String>();
  //  String ranSomValues = null;
    Set<String> ranSomValues = new HashSet<String>();
   // String domOnProp = null;
    Set<String> domOnProp = new HashSet<String>();
   // String regDom = null;
    Set<String> regDom = new HashSet<String>();
   // String regRan = null;
    Set<String> regRan = new HashSet<String>();
   // String subProperty = null;
    Set<String> subProperty = new HashSet<String>();
   // String inverseOf =null;
    Set<String> inverseOf = new HashSet<String>();
   
    Set<String> subClassWtihRestriction = new HashSet<String>();
    Set<String> subClassWtihRestrictionSomeValues = new HashSet<String>();

    Set<String> nestedDomRestriction = new LinkedHashSet();
    Set<String> nestedDomIntersect = new LinkedHashSet();
    Set<String> domRestriction = new LinkedHashSet();

    Set<Set<String>> nestedDomRestriction1 = new LinkedHashSet();
    Set<Set<String>> nestedDomIntersect1 = new LinkedHashSet();
    
    Set<String> nestedRanRestriction = new LinkedHashSet();
    Set<String> nestedRanIntersect = new LinkedHashSet();
    Set<String> ranRestriction = new LinkedHashSet();
    
    Set<Set<String>> nestedRanRestriction1 = new LinkedHashSet();
    Set<Set<String>> nestedRanIntersect1 = new LinkedHashSet();

    Set<String> invProperty = new HashSet<String>();
    
    
}


