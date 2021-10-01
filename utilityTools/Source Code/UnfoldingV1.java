
import java.io.IOException;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Collections;
import java.util.HashMap;
import java.util.HashSet;
import java.util.LinkedHashMap;
import java.util.LinkedHashSet;
import java.util.List;
import java.util.Map;
import java.util.Map.Entry;
import java.util.Set;

import com.sun.tools.javac.util.ArrayUtils;

import uk.ac.ox.cs.chaseBench.model.Atom;
import uk.ac.ox.cs.chaseBench.model.Rule;
import uk.ac.ox.cs.chaseBench.model.Term;

public class UnfoldingV1 {
	
	//static String query;
	static List<Rule> rules;
	List<Rule> queries;
	
	public static void main(String[] args) throws Exception {
		//query = args[0]+" .";
		String queriesAsString = args[0];
		queriesAsString =queriesAsString.replaceAll("\\?X", "\\?");
		List<Rule> queries = DataLogToUCQ.getRuleString(queriesAsString);
		rules= Mappings.getRules(args[1]);
		
		int i=1;
		for(Rule query: queries) {
			Set<Rule> unfoldQueries = unfoldQuery(query, rules);
//			System.out.println("Set size:" + unfoldQueries.size());
			if(unfoldQueries != null) {
				
				for(Rule unfoldQuery : unfoldQueries) {
				  System.out.println(ModifyChaseBench.queryString(unfoldQuery));
				  i++;
				}
			}
		}
		
		
			
	}
	
	public static Set<Rule> unfoldQuery(Rule queryRule, List<Rule> rules) throws IOException {

		ArrayList<Rule> allSubstitedQueries = new ArrayList<Rule>();
		Atom[] queryHead = queryRule.getHeadAtoms();
		Atom[] queryBodyAtoms = queryRule.getBodyAtoms();
		
		ArrayList<Atom> queryBodyAtomslist = new ArrayList<Atom>();
	    Collections.addAll(queryBodyAtomslist, queryBodyAtoms);
		Collections.sort(queryBodyAtomslist, Atom.AtomPredicateNameComparator);
		queryBodyAtoms = toArray(queryBodyAtomslist);
		
		ArrayList<ArrayList<ArrayList<Atom>>> substitedAtomsPerSubQ = new ArrayList<ArrayList<ArrayList<Atom>>>(); 
 		int renameingCount = 0;
		for(Atom qAtom: queryBodyAtoms) {// T1, T2, T3 in query
			ArrayList<ArrayList<Atom>> substitedAtomsPerRule = new ArrayList<ArrayList<Atom>>();

//			System.out.println("query: "+qAtom.toString()+" -- ");

			for(Rule tgdRule : rules) {
				ArrayList<Atom> substitedQueryAtom = new ArrayList<Atom>();
//				System.out.println("TGD Rule: "+tgdRule.toString());
				
				Atom tgdHeadAtom = tgdRule.getHeadAtom(0);
//				System.out.println("Atom Rulee:" +tgdHeadAtom.toString());
				
				Substitution substitution = Utils.findUnification(tgdHeadAtom, qAtom);
				if(substitution!=null) {
//					System.out.println("TGD Rule:" +tgdRule.toString());
//					System.out.println("Subsut:" +substitution.toString());

					if(!qAtom.getPredicate().getName().contains("Temp")) {
//						 System.out.println("NOT Temp");
						Map<Term, Term> substitutiomMap = substitution.getMapping();
						Term[] freeVariable = findFreeVariable(tgdRule);
						for(int i=0; i<freeVariable.length; i++) {
								//check if it is map to existential var.
								for (Map.Entry<Term, Term> entry : substitutiomMap.entrySet()) {
									if (freeVariable[i].equals(entry.getKey())) {
//										 System.out.println(entry.getKey()+ "NOT Temp map to !");
											return null;									}
							    }
						}
					}
//					Map<Term, Term> m = substitution.getMapping();
//					for (Map.Entry<Term, Term> entry : m.entrySet()) {
//					    System.out.println("-"+entry.getKey() + ":" + entry.getValue().toString());
//					}
					Atom[] tgdBodyAtoms = tgdRule.getBodyAtoms();
					for(Atom bodyAtom : tgdBodyAtoms) {
						Atom substitutedAtom = substitution.renameApply(bodyAtom, renameingCount);
						renameingCount = substitution.renameingCount;
						substitedQueryAtom.add(substitutedAtom);
//						System.out.println("Subs Atom: "+substitutedAtom.toString());
					}//end loop of body Atoms
					
					
				}//if  Substitution not null
			
				Rule substitedQuery = null;
			
				if(!substitedQueryAtom.isEmpty()) {//if there is substitution 
					if(queryBodyAtoms.length == 1) {//if the query has single atom
						Atom[] substitedQueryAtomArray = toArray(substitedQueryAtom);
						substitedQuery = new Rule(queryHead, substitedQueryAtomArray);
//						System.out.println("**"+substitedQuery.toString());
						allSubstitedQueries.add(substitedQuery);
					}else {//if the query is CQs
						//add complete body of the rule as a substitution
						if(!substitedAtomsPerRule.contains(substitedQueryAtom)) {
							substitedAtomsPerRule.add(substitedQueryAtom);
//							System.out.println("-----CQs -----"+substitedQueryAtom);
						}	
					}
				}
				
			}//end loop through tgds rules.
			
			// add all substitution rules for each T
			if(!substitedAtomsPerRule.isEmpty()) {
//				if(!substitedAtomsPerSubQ.contains(substitedAtomsPerRule)) {
					substitedAtomsPerSubQ.add(substitedAtomsPerRule);
//					System.out.println("query : "+qAtom.toString()+" -- ");
//					System.out.println(substitedAtomsPerRule.toString());
//				}
			}else {
//				System.out.println("query: "+qAtom.toString()+" -- Null");
//				System.out.println(substitedAtomsPerRule.toString());
				if(allSubstitedQueries.isEmpty())
					return null;
			}
		}//end loop through query Atoms.
					
		
		//made the CQs with the substitution 
		ArrayList<ArrayList<Atom>> CQsSubstitedAtomList = new ArrayList<ArrayList<Atom>>();
		if(!substitedAtomsPerSubQ.isEmpty()) {
			ArrayList<ArrayList<Atom>> copy  = null;
			for(int i=0; i< substitedAtomsPerSubQ.size(); i++) {
				ArrayList<ArrayList<Atom>> targetAtomList = substitedAtomsPerSubQ.get(i);
				if(i==0) {
					for(ArrayList<Atom> atomList : targetAtomList) {
							CQsSubstitedAtomList.add(atomList);
					}
					copy = new ArrayList<ArrayList<Atom>>();
					for (ArrayList<Atom> obj : CQsSubstitedAtomList) {
					    copy.add((ArrayList<Atom>)obj.clone());
					}
				}else {					
					for(int k=0 ; k< targetAtomList.size(); k++) {
						for(int r=0; r< copy.size();r++) {
							if(k==0) {
								ArrayList<Atom> currentAtoms = CQsSubstitedAtomList.get(r);
								currentAtoms.addAll(targetAtomList.get(k));
								CQsSubstitedAtomList.set(r, currentAtoms);

							}else {
								ArrayList<Atom> currentAtoms1 = copy.get(r);
								currentAtoms1.addAll(targetAtomList.get(k));
								CQsSubstitedAtomList.add(currentAtoms1);
							}
						}
					}
					copy = new ArrayList<ArrayList<Atom>>();
					for (ArrayList<Atom> obj : CQsSubstitedAtomList) {
					    copy.add((ArrayList<Atom>)obj.clone());
					}
				}//end else

			}//end loop
		}//!substitedAtomsPerSubQ.isEmpty()

		for(ArrayList<Atom> list: CQsSubstitedAtomList) {
			 //sort the atoms to ensure there are no duplicates
			  Collections.sort(list, Atom.AtomPredicateNameComparator);
			  Set<Atom> set = new HashSet<>(list);
			  list.clear();
			  list.addAll(set);
			Atom[] substitedQueryAtomArray = toArray(list);
			Rule substitedQuery = new Rule(queryHead, substitedQueryAtomArray);
//			System.out.println("**"+substitedQuery.toString());
			allSubstitedQueries.add(substitedQuery);
		}
		
	    Set<Rule> allSubstitedQueriesSet = new HashSet<Rule>();
	    allSubstitedQueriesSet.addAll(allSubstitedQueries);   
//	    System.out.println("------------------------------------------------  ");
		return allSubstitedQueriesSet;
	}
	
	public static Atom[] toArray(ArrayList<Atom> listOfAtoms) {
		Atom[] atomArray = new Atom[listOfAtoms.size()];
		
		for(int i=0; i < atomArray.length; i++) {
			atomArray[i] = listOfAtoms.get(i);
		}
		
		return  atomArray;
	}

	public static Term[] toArrayTerm(ArrayList<Term> listOfTerms) {
		Term[] termArray = new Term[listOfTerms.size()];
		
		for(int i=0; i < termArray.length; i++) {
			termArray[i] = listOfTerms.get(i);
		}
		
		return  termArray;
	}
	public static Term[] findFreeVariable(Rule rule) {
		Term[] freeVariablesArr = null;
		
		Atom[] headAtoms = rule.getHeadAtoms();
		ArrayList<Term> headArgs =  new ArrayList<Term>();
		for(Atom headAtom : headAtoms) {
			Term[] args = headAtom.getArguments();
			for(Term t: args) {
				headArgs.add(t);
			}
		}
		
		Atom[] bodyAtoms = rule.getBodyAtoms();
		ArrayList<Term> bodyArgs =  new ArrayList<Term>();
		for(Atom bodyAtom : bodyAtoms) {
			Term[] args = bodyAtom.getArguments();
			for(Term t: args) {
				bodyArgs.add(t);
			}
		}
		
		ArrayList<Term> freeVariables =  new ArrayList<Term>();
		for(Term arg : headArgs) {
			if(!bodyArgs.contains(arg)) {
				freeVariables.add(arg);
//				System.out.println("I'm free : " +arg.toString());
			}
		}
		
		freeVariablesArr = toArrayTerm(freeVariables);
		return freeVariablesArr;
	}
	
}
