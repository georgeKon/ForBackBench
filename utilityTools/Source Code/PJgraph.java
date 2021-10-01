import java.util.Iterator;
import java.util.List;
import java.util.Set;

import org.jgrapht.Graph;
import org.jgrapht.alg.cycle.CycleDetector;
import org.jgrapht.graph.DefaultDirectedGraph;
import org.jgrapht.graph.DefaultEdge;

import uk.ac.ox.cs.chaseBench.model.Atom;
import uk.ac.ox.cs.chaseBench.model.Rule;
import uk.ac.ox.cs.chaseBench.model.Term;


public class PJgraph {

	public static void main(String[] args) {
		// TODO Auto-generated method stub
		//P(X,Y) -> R1(X,Z), R2(W,X),R3(W,Y), R4(Y,C),R5(C).
		String tgdRuleFile = "/Users/afnanalhazmi/Desktop/tgdRule.txt";
		 
		List<Rule> tgdRuleList = null;
		try {
			tgdRuleList = Mappings.getRules(tgdRuleFile);
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		Rule tgdRule = tgdRuleList.get(0);
		
		boolean hasCycle = 	drawPJgraph( tgdRule);
		System.out.println("has Cycles :"+hasCycle);
	}
	
	 /**
	  * Method that draw a PJ graph for a TGD and check if contains cycle or not 
     * Input: A TGD rule in chasebench format Output: (true) if this TGD
     * translatable to DL-Lite, (false) if this TGD is not translatable.
     *
     * @return a boolean (true) if this TGD does not have a cycle (translatable to DL-Lite), 
     * (false) if this TGD is  have a cycle (not translatable).
     * 
     */
	public static boolean drawPJgraph(Rule tgdRule) {
		boolean hasCycle=false;
		
		//get all atoms of the rule
		Atom[] ruleAtoms = UndirectedGraph.getAllAtoms(tgdRule);
		
		//Initialize the graph object 
		CycleDetector<String, DefaultEdge> cycleDetector;
	    Graph<String, DefaultEdge> g = new DefaultDirectedGraph<String, DefaultEdge>(DefaultEdge.class);

	    // for every atom create a predicate node, arguments nodes, and edges. 
		for(Atom atom: ruleAtoms) {
			 
			//get predicate name and create node
			String predicateName = atom.getPredicate().getName();
			g.addVertex(predicateName);
			//get argument names and check if it already has a node or not
			Term[] args = atom.getArguments();
			for(int i=0;i<args.length; i++) {
				String argName = args[i].toString();
				//check if argument already has a node or not.
				if(!g.containsVertex(argName)){
					g.addVertex(argName);
				}
				// draw edges between predicate and argument node. 
				if(i==0)
					g.addEdge(predicateName, argName);
				else
					g.addEdge(argName, predicateName);
			}
		}//end for each atom
		
		  // Printing the vetrices and the edges
        System.out.println(g.toString());
        
		// Checking for cycles in the TGD
        cycleDetector = new CycleDetector<String, DefaultEdge>(g);

        // Cycle(s) detected.
        if (cycleDetector.detectCycles()) {
        	hasCycle= true;
            Iterator<String> iterator;
            Set<String> cycleVertices;
            Set<String> subCycle;
            String cycle;

            System.out.println("Cycles detected.");

            // Get all vertices involved in cycles.
            cycleVertices = cycleDetector.findCycles();

            // Loop through vertices trying to find disjoint cycles.
            while (!cycleVertices.isEmpty()) {
                System.out.println("Cycle:");

                // Get a vertex involved in a cycle.
                iterator = cycleVertices.iterator();
                cycle = iterator.next();

                // Get all vertices involved with this vertex.
                subCycle = cycleDetector.findCyclesContainingVertex(cycle);
                for (String sub : subCycle) {
                    System.out.println("   " + sub);
                    // Remove vertex so that this cycle is not encountered again
                    cycleVertices.remove(sub);
                }
            }
        }
      
		return hasCycle;
		
	}
	
	

}
