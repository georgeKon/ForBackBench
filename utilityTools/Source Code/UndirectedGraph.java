import java.util.ArrayDeque;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.LinkedHashSet;
import java.util.List;
import java.util.Map;
import java.util.Queue;

import uk.ac.ox.cs.chaseBench.model.Atom;
import uk.ac.ox.cs.chaseBench.model.Rule;
import uk.ac.ox.cs.chaseBench.model.Term;

	 
// A class to store a graph edge
class Edge{
    String source, dest;
 
    public Edge(String source, String dest)
    {
        this.source = source;
        this.dest = dest;
    }
}//end Edge class
	 
// A class to represent a graph object
class Graph{
    // A list of lists to represent an adjacency list
    List<List<String>> adjList = null;
    Map<String, Integer> indexOfVertex = new HashMap<>();
    List<Edge> edges = null;
    // Constructor
    Graph(List<Edge> edges, int N)
    {
    	this.edges = edges;
        adjList = new ArrayList<>();
	 
        for (int i = 0; i < N; i++) {
            adjList.add(new ArrayList<>());
        }
 
        // add edges to the undirected graph
        int count=0;
        for (Edge edge: edges)
        {
            String src = edge.source;
            String dest = edge.dest;
           
            
            if(!indexOfVertex.containsKey(src)) {
            	indexOfVertex.put(src, count);  
            	count++;
            }
            if(!indexOfVertex.containsKey(dest)) {
            	indexOfVertex.put(dest, count);  
            	count++;
            }
            

//            System.out.println(src+" -- "+ indexOfVertex.get(src));
            adjList.get(indexOfVertex.get(src)).add(dest);
            adjList.get(indexOfVertex.get(dest)).add(src);
        }
    }
    
    public void printGraphEdges() {
          	System.out.println("---------------------------");
          	for(Edge s: edges) {
          		System.out.println(s.source + "--> "+ s.dest);
          	}
          	System.out.println("---------------------------");
          
    }
}//End graph class
 
// Node to store vertex and its parent info in BFS
class Node
{
    int v, parent;
 
    Node(int v, int parent)
    {
        this.v = v;
        this.parent = parent;
    }
}
 
class UndirectedGraph{
	
//	 static ArrayList<String> cycleNodes = new ArrayList<String>();
	 static LinkedHashSet<String> cycleNodes = new LinkedHashSet<String>();
	 static LinkedHashSet<String> predicatNames = new LinkedHashSet<String>();
	 
    // Perform BFS on the graph starting from vertex `src` and
    // return true if a cycle is found in the graph
    public static boolean BFS(Graph graph, String src, int N)
    {
    	boolean hasCycle=false; 
        // to keep track of whether a vertex is discovered or not
        boolean[] discovered = new boolean[N];
 
        // mark the source vertex as discovered
        discovered[graph.indexOfVertex.get(src)] = true;
        
        // create a queue for doing BFS and
        // enqueue source vertex
        Queue<Node> q = new ArrayDeque<>();
        q.add(new Node(graph.indexOfVertex.get(src), -1));
 
        // loop till queue is empty
        while (!q.isEmpty())
        {
            // dequeue front node and print it
            Node node = q.poll();
 
            // do for every edge `v —> u`
            for (String u: graph.adjList.get(node.v))
            {
                if (!discovered[graph.indexOfVertex.get(u)])
                {
                    // mark it as discovered
                    discovered[graph.indexOfVertex.get(u)] = true;
 
                    // construct the queue node containing info
                    // about vertex and enqueue it
                    q.add(new Node(graph.indexOfVertex.get(u), node.v));
                }
 
                // `u` is discovered, and `u` is not a parent
                else if (graph.indexOfVertex.get(u) != node.parent)
                {
                    // we found a cross-edge, i.e., the cycle is found
                	if(!predicatNames.contains(graph.adjList.get(node.v).get(0)))
                		cycleNodes.add(graph.adjList.get(node.v).get(0));
                	if(!predicatNames.contains(graph.adjList.get(node.v).get(1)))
                		cycleNodes.add(graph.adjList.get(node.v).get(1));
                	
                	if(!predicatNames.contains(graph.adjList.get(graph.indexOfVertex.get(u)).get(0)))
                		cycleNodes.add(graph.adjList.get(graph.indexOfVertex.get(u)).get(0));
                	if(!predicatNames.contains(graph.adjList.get(graph.indexOfVertex.get(u)).get(1)))
                		cycleNodes.add(graph.adjList.get(graph.indexOfVertex.get(u)).get(1));
                	
                	System.out.println("From : "+graph.adjList.get(node.v)+"--"+graph.adjList.get(graph.indexOfVertex.get(u)));
                	 hasCycle=true;
                }
            }
        }
 
        // no cross-edges were found in the graph
        return hasCycle;
    }
 
    
    public static boolean drawUndirectedPJgraph(Rule tgdRule) {
    	boolean hasCycle=false;
 	   UndirectedGraph.cycleNodes = new LinkedHashSet<String>();

    	 List<Edge> edges = new ArrayList<Edge>();
    	
    	//get all atoms of the rule
    	Atom[] ruleAtoms = getAllAtoms(tgdRule);
    	 
    	// total number of nodes in the graph
    	int nodeNumber = tgdRule.getNumberOfBodyAtoms() +tgdRule.getNumberOfHeadAtoms();
    	
    	ArrayList<String> argsNames = new ArrayList<String>();
    	 // for every atom create a predicate node, arguments nodes, and edges. 
		for(Atom atom: ruleAtoms) {
			 
			//get predicate name and create node
			String predicateName = atom.getPredicate().getName();
			predicatNames.add(predicateName);
			
			//get argument names and check if it already has a node or not
			Term[] args = atom.getArguments();
			for(int i=0;i<args.length; i++) {
				String argName = args[i].toString();
				
				// draw edges between predicate and argument node. 
				Edge edge = new Edge(predicateName, argName);
				edges.add(edge);
				//count number of nodes
				if(!argsNames.contains(argName)) {
					argsNames.add(argName);
				}
			}
		}//end for each atom
		
		// total number of nodes in the graph
		nodeNumber +=argsNames.size();
 
        // build a graph from the given edges
        Graph graph = new Graph(edges, nodeNumber);
    	
        // Perform BFS traversal in connected components of a graph
//        System.out.println(ruleAtoms[0].getPredicate().getName());
        if (BFS(graph, ruleAtoms[0].getPredicate().getName(), nodeNumber)) {
            System.out.println("The graph contains a cycle");
           
            hasCycle=true;
        }
        else {
            System.out.println("The graph doesn't contain any cycle");
            hasCycle=false;
        }
       
//        graph.printGraphEdges();
        
    	return hasCycle;
    }
    
    /**
	  * Method that combine atoms of head and body in one array 
   * Input: A TGD rule in chasebench format Output: array of atoms 
   *
   * @return a Atom[] of both body and head.
   * 
   */
	public static Atom[] getAllAtoms(Rule tgdRule) {
		Atom[] headAtoms = tgdRule.getHeadAtoms();
		Atom[] bodyAtoms = tgdRule.getBodyAtoms();
		

       int hLen = headAtoms.length;
       int bLen = bodyAtoms.length;
     
       Atom[] bodyAndHeadAtoms = new Atom[hLen + bLen];

       System.arraycopy(bodyAtoms , 0, bodyAndHeadAtoms, 0, bLen);
       System.arraycopy(headAtoms, 0, bodyAndHeadAtoms, bLen, hLen);

     
		return bodyAndHeadAtoms;
		
	}
    
    public static void main(String[] args) {
    	
    	
    	String tgdRuleFile = "/Users/afnanalhazmi/Desktop/tgdRule.txt";
		 
		List<Rule> tgdRuleList = null;
		try {
			tgdRuleList = Mappings.getRules(tgdRuleFile);
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		Rule tgdRule = tgdRuleList.get(0);
		
		boolean hasCycle = 	drawUndirectedPJgraph( tgdRule);
		System.out.println("has Cycles :"+hasCycle);
//		Atom[] heads =tgdRule.getHeadAtoms();
//		Atom body = tgdRule.getBodyAtom(0);
//		boolean ss = TGDsToOwlConverter.checkCycleArgruments(cycleNodes, body);
//		System.out.println("has univ :"+ss);
		
//        // List of graph edges as per the above diagram
//        List<Edge> edges = Arrays.asList(
//                                new Edge("a", "b"), new Edge("a", "c"), new Edge("a", "d"),
//                                new Edge("b", "e"), new Edge("b", "f"), new Edge("e", "i"),
//                                new Edge("e", "j"), new Edge("d", "g"), new Edge("d", "h"),
//                                new Edge("g", "k"), new Edge("g", "l")
//                                // edge `6 —> 10` introduces a cycle in the graph
//                            );
// 
//        // total number of nodes in the graph
//        final int N = 12;
// 
//        // build a graph from the given edges
//        Graph graph = new Graph(edges, N);
// 
        // Perform BFS traversal in connected components of a graph
//        if (BFS(graph, "a", N)) {
//            System.out.println("The graph contains a cycle");
//        }
//        else {
//            System.out.println("The graph doesn't contain any cycle");
//        }
    }//end main
}






	
	

//	// No. of vertices
//    private int V;   
//   
//    // Adjacency List Represntation
//    private LinkedList<Integer> adj[]; 
// 
//    // Constructor
//    UndirectedGraph(int v) 
//    {
//        V = v;
//        adj = new LinkedList[v];
//        for(int i=0; i<v; ++i)
//            adj[i] = new LinkedList();
//    }
// 
//    // Function to add an edge 
//    // into the graph
//    void addEdge(int v,int w) 
//    {
//        adj[v].add(w);
//        adj[w].add(v);
//    }
// 
//    // A recursive function that 
//    // uses visited[] and parent to detect
//    // cycle in subgraph reachable 
//    // from vertex v.
//    Boolean isCyclicUtil(int v, 
//                 Boolean visited[], int parent)
//    {
//        // Mark the current node as visited
//        visited[v] = true;
//        Integer i;
// 
//        // Recur for all the vertices 
//        // adjacent to this vertex
//        Iterator<Integer> it = 
//                adj[v].iterator();
//        while (it.hasNext())
//        {
//            i = it.next();
// 
//            // If an adjacent is not 
//            // visited, then recur for that
//            // adjacent
//            if (!visited[i])
//            {
//                if (isCyclicUtil(i, visited, v))
//                    return true;
//            }
// 
//            // If an adjacent is visited 
//            // and not parent of current
//            // vertex, then there is a cycle.
//            else if (i != parent)
//                return true;
//        }
//        return false;
//    }
// 
//    // Returns true if the graph 
//    // contains a cycle, else false.
//    Boolean isCyclic()
//    {
//         
//        // Mark all the vertices as 
//        // not visited and not part of
//        // recursion stack
//        Boolean visited[] = new Boolean[V];
//        for (int i = 0; i < V; i++)
//            visited[i] = false;
// 
//        // Call the recursive helper 
//        // function to detect cycle in
//        // different DFS trees
//        for (int u = 0; u < V; u++)
//        {  
//         
//            // Don't recur for u if already visited
//            if (!visited[u]) 
//                if (isCyclicUtil(u, visited, -1))
//                    return true;
//        }
// 
//        return false;
//    }
// 
//    public static boolean drawUndirectedPjGraph(Rule tgdRule) {
//    	Atom[] ruleAtoms = PJgraph.getAllAtoms(tgdRule);
//    	
//    	
//    	 // for every atom create a predicate node, arguments nodes, and edges. 
//		for(Atom atom: ruleAtoms) {
//			 
//			//get predicate name and create node
//			String predicateName = atom.getPredicate().getName();
//			g.addVertex(predicateName);
//			//get argument names and check if it already has a node or not
//			Term[] args = atom.getArguments();
//			for(int i=0;i<args.length; i++) {
//				String argName = args[i].toString();
//				//check if argument already has a node or not.
//				if(!g.containsVertex(argName)){
//					g.addVertex(argName);
//				}
//				// draw edges between predicate and argument node. 
//				if(i==0)
//					g.addEdge(predicateName, argName);
//				else
//					g.addEdge(argName, predicateName);
//			}
//		}//end for each atom
//    	
//    	return true;
//    }
// 
//    // Driver method to test above methods
//    public static void main(String args[])
//    {
//         
//    	String tgdRuleFile = "/Users/afnanalhazmi/Desktop/tgdRule.txt";
//		 
//		List<Rule> tgdRuleList = null;
//		try {
//			tgdRuleList = Mappings.getRules(tgdRuleFile);
//		} catch (Exception e) {
//			// TODO Auto-generated catch block
//			e.printStackTrace();
//		}
//		Rule tgdRule = tgdRuleList.get(0);
//		
//		boolean hasCycle = 	drawUndirectedPjGraph( tgdRule);
//		System.out.println("has Cycles :"+hasCycle);
//    	
//        // Create a graph given 
//        // in the above diagram
//    	UndirectedGraph g1 = new UndirectedGraph(5);
//        g1.addEdge(1, 0);
//        g1.addEdge(0, 2);
//        g1.addEdge(2, 1);
//        g1.addEdge(0, 3);
//        g1.addEdge(3, 4);
//        if (g1.isCyclic())
//            System.out.println("Graph contains cycle");
//        else
//            System.out.println("Graph doesn't contains cycle");
// 
//        UndirectedGraph g2 = new UndirectedGraph(3);
//        g2.addEdge(0, 1);
//        g2.addEdge(1, 2);
//        if (g2.isCyclic())
//            System.out.println("Graph   contains cycle");
//        else
//            System.out.println("Graph    doesn't contains cycle");
//    }
//}
