import uk.ac.ox.cs.chaseBench.model.*;

import java.io.File;
import java.io.FileOutputStream;
import java.io.PrintStream;
import java.util.*;
import java.util.stream.Collectors;
import java.util.stream.IntStream;

public class ModifyChaseBench {
    public static void main(String[] args) throws Exception {


        if (args.length == 0) {
            System.out.println("Supported options:");
            System.out.println("-st-tgds       <file>   | the file containing the source-to-target TGDs");
            System.out.println("-t-tgds        <file>   | the file containing the target-to-target TGDs");
            System.out.println("-q            <folder> | the folder containing queries in chasebench format");
        } else {
            String stTgds = null;
            String tTgds = null;
            String qFolder = null;

            for (int i = 0; i < args.length - 1; i += 2) {
                String argument = args[i];
                switch (argument) {
                    case "-st-tgds":
                        stTgds = args[i + 1];
                        break;
                    case "-t-tgds":
                        tTgds = args[i + 1];
                        break;
                    case "-q":
                        qFolder = args[i + 1];
                        break;
                    default:
                        System.out.println("Unknown option '" + argument + "'.");
                        break;

                }

            }
            if (stTgds == null) {
                System.out.println("Invalid argument setup: No st-tgd file found");
            } else if (tTgds == null) {
                System.out.println("Invalid argument setup: No t-tgd file found found");
            } else {
                File[] queries = null;
               ArrayList<File> queriesList = new ArrayList<File>();
               
                File[] queriesFolders = null;
                //Read in the (s)t-tgds in from file
                List<Rule> tRules = Mappings.getRules(tTgds);
                List<Rule> stRules = Mappings.getRules(stTgds);
                //Convert all the target rules into binary atoms
                stRules.forEach(rule -> {
                    Arrays.stream(rule.getHeadAtoms()).forEach(ModifyChaseBench::binaryConvert);
                    Arrays.stream(rule.getBodyAtoms()).forEach(ModifyChaseBench::binaryConvert);
                });
                List<List<Rule>> queriesRules = new ArrayList<>();
                if (qFolder != null) {
//                    queries = new File(qFolder).listFiles();
                    queriesFolders = new File(qFolder).listFiles();

                    for (File queryFolder : queriesFolders) {
                    	File[] files = queryFolder.listFiles();
                    	if(files.length>0)
                    		queriesList.add(files[0]);
                    }
                     queries = new File[queriesList.size()];
                    queries = queriesList.toArray(queries);
                    for (File query : queries) {
                        queriesRules.add(Mappings.getRules(query.getPath()));
                    }
                    //Do the same for the head of the query and the body elements
                    queriesRules.forEach(x -> x.forEach(rule -> Arrays.stream(rule.getHeadAtoms()).forEach(ModifyChaseBench::binaryConvert)));
                    queriesRules.forEach(x -> x.forEach(rule -> Arrays.stream(rule.getBodyAtoms()).forEach(ModifyChaseBench::binaryConvert)));
                    IntStream.range(0, queriesRules.size()).forEach(i -> queriesRules.set(i, simplifyRules(queriesRules.get(i))));
                }
                for (Rule rule : tRules) {
                    //Then for all elements in the t-tgds
                    Arrays.stream(rule.getHeadAtoms()).forEach(ModifyChaseBench::binaryConvert);
                    Arrays.stream(rule.getBodyAtoms()).forEach(ModifyChaseBench::binaryConvert);
                    //Set one of the atoms to a unary atom
                    if (rule.getNumberOfHeadAtoms() > 1) {
                        Atom middle = rule.getHeadAtom(1);
                        Term[] terms = middle.getArguments();
                        Term[] newTerms = new Term[1];
                        System.arraycopy(terms, 0, newTerms, 0, 1);
                        middle.setArguments(newTerms);
                        //Sets that atom to a unary atom throught the scenarios
                        applyUnary(tRules, middle);
                        applyUnary(stRules, middle);
                        queriesRules.forEach(rules -> applyUnary(rules, middle));
                    }
                }
                queriesRules.forEach(x -> x.forEach(System.out::println));
                //CB variables are complex and contain _ which trash james js parsing so removes it, replases with 0s
                stRules = simplifyRules(stRules);
                tRules = simplifyRules(tRules);
                outToFile(tTgds, tRules.stream().map(Rule::toString).collect(Collectors.toList()));
                outToFile(stTgds, stRules.stream().map(Rule::toString).collect(Collectors.toList()));
                if (queries != null) {
                    queriesRules.forEach(list -> {
                        for (int i = 0; i < list.size(); i++) {
                            list.set(i,ensureValidHead(list.get(i)));
                        }
                    });
                    File[] finalQueries = queries;
                    IntStream.range(0, queries.length).forEach(i -> {
                        try {
                            outToFile(finalQueries[i].getCanonicalPath(), queriesRules.get(i).stream().map(ModifyChaseBench::queryString).collect(Collectors.toList()));
                        } catch (Exception e) {
                            e.printStackTrace();
                        }
                    });
                }
            }


        }
    }


    //Cant have a query head with variables not in the query. so makes sure there are none by removing them
    private static Rule ensureValidHead(Rule query) {
        List<Term> headVars = new ArrayList<>(Arrays.asList(query.getHeadAtom(0).getArguments()));
        List<Boolean> inBody = new ArrayList<>();
        headVars.forEach(var -> inBody.add(false));
        int loc;
        for(Atom body :  query.getBodyAtoms()) {
            for(Term term : body.getArguments()) {
                if ((loc = headVars.indexOf(term)) != -1) {
                    inBody.set(loc,true);
                }
            }
        }
        while((loc = inBody.indexOf(false)) != -1) {
            headVars.remove(loc);
            inBody.remove(loc);
        }
        if(headVars.size() == 0) {
            headVars.add(query.getBodyAtom(0).getArgument(0));
        }
        if(query.getHeadAtom(0).getNumberOfArguments() != headVars.size()) {
            query = query.replaceHead(Atom.create(query.getHeadAtom(0).getPredicate(),headVars.toArray(new Term[0])));
        }
        return  query;
    }

    //Flips the argument order so that the rules are printed q() <- ... so that once again james parser can handle it
    static String queryString(Rule rule) {
        StringBuilder builder = new StringBuilder();
        Atom[] head = rule.getHeadAtoms();
        for (int index = 0; index < head.length; index++) {
            if (index > 0)
                builder.append(",");
            head[index].toString(builder);
        }
        builder.append(" <- ");
        Atom[] body = rule.getBodyAtoms();
        for (int index = 0; index < body.length; index++) {
            if (index > 0)
                builder.append(",");
            body[index].toString(builder);
        }
        builder.append(" .");
        return builder.toString();
    }

    private static void outToFile(String location, List outputArray) throws Exception {
        File output = new File(location);
        FileOutputStream fileOutputStream = new FileOutputStream(output);
        PrintStream printer = new PrintStream(fileOutputStream);
        outputArray.forEach(printer::println);
        printer.close();
        fileOutputStream.close();
    }

    private static List<Rule> simplifyRules(List<Rule> rules) {
        List<Rule> newList = new ArrayList<>();
        rules.forEach(rule -> newList.add(simplifyVariables(rule)));
        return newList;
    }


    //Removes _ from predicate names and sets variable names to a number
    private static Rule simplifyVariables(Rule rule) {
        int counter = 0;
        Map<Variable, Term> substitution = new HashMap<>();
        Atom[] newHead = new Atom[rule.getNumberOfHeadAtoms()];
        Atom[] headAtoms = rule.getHeadAtoms();
        for (int i = 0; i < headAtoms.length; i++) {
            Atom atom = headAtoms[i];
            newHead[i] = atom.replacePredicate(Predicate.create(atom.getPredicate().getName().replace("_", "")));
            for (Term term : atom.getArguments()) {
                if (!substitution.containsKey(term)) {
                    substitution.put((Variable) term, Variable.create(Integer.toString(counter++)));
                }
            }
        }
        Atom[] newBody = new Atom[rule.getNumberOfBodyAtoms()];
        Atom[] bodyAtoms = rule.getBodyAtoms();
        for (int i = 0; i < bodyAtoms.length; i++) {
            Atom atom = bodyAtoms[i];
            newBody[i] = atom.replacePredicate(Predicate.create(atom.getPredicate().getName().replace("_", "")));
            for (Term term : atom.getArguments()) {
                if (!substitution.containsKey(term)) {
                    substitution.put((Variable) term, Variable.create(Integer.toString(counter++)));
                }
            }
        }
        rule = Rule.create(newHead, newBody);
        return rule.applySubstitution(substitution);
    }

    //Updates the rules so that that atom is a unary
    private static void applyUnary(List<Rule> rules, Atom middle) {
        for (Rule changingRule : rules) {
            if (changingRule.getBodyAtom(0).equals(middle)) {
                Atom body = changingRule.getBodyAtom(0);
                Term[] changingTerms = body.getArguments();
                Term[] changingNewTerms = new Term[1];
                System.arraycopy(changingTerms, 0, changingNewTerms, 0, 1);
                body.setArguments(changingNewTerms);
            }
            for (Atom head : changingRule.getHeadAtoms()) {
                if (head.equals(middle)) {
                    Term[] changingTerms = head.getArguments();
                    Term[] changingNewTerms = new Term[1];
                    System.arraycopy(changingTerms, 0, changingNewTerms, 0, 1);
                    head.setArguments(changingNewTerms);
                }
            }
        }
    }

    //Removes all terms apart from the first 2
    private static void binaryConvert(Atom atom) {
        Term[] terms = atom.getArguments();

        if (terms.length > 2) {
            Term[] newTerms = new Term[2];
            System.arraycopy(terms, 0, newTerms, 0, 2);
            atom.setArguments(newTerms);
        }

    }
}
