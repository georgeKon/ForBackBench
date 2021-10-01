import uk.ac.ox.cs.chaseBench.model.*;

import java.io.File;
import java.util.*;

public class Schema {
    public static void main(String[] args) throws Exception {

        if (args.length == 0) {
            System.out.println("Supported options:");
            System.out.println("-st-tgds       <file>   | the file containing the source-to-target TGDs");
            System.out.println("-t-tgds        <file>   | the file containing the target-to-target TGDs");
            System.out.println("-s-schema     <file>   | the output file of the source schema");
            System.out.println("-t-schema     <file>   | the output file of the target schema");
        } else {
            String stTgds = null;
            String tTgds = null;
            String sSchema = null;
            String tSchema = null;

            for (int i = 0; i < args.length - 1; i += 2) {
                String argument = args[i];
                switch (argument) {
                    case "-st-tgds":
                        stTgds = args[i + 1];
                        break;
                    case "-t-tgds":
                        tTgds = args[i + 1];
                        break;
                    case "-s-schema":
                        sSchema = args[i + 1];
                        break;
                    case "-t-schema":
                        tSchema = args[i + 1];
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
                List<Rule> tRules = Mappings.getRules(tTgds);
                List<Rule> stRules = Mappings.getRules(stTgds);

                List<Atom> tAtoms = new ArrayList<>();
                List<Atom> sAtoms = new ArrayList<>();
                //Adds all target atom to a list
                tRules.forEach(rule -> getAtoms(rule, sAtoms));
                //Does same for the atoms
                for (Rule stRule : stRules) {
                    tAtoms.addAll(Arrays.asList(stRule.getHeadAtoms()));
                    sAtoms.addAll(Arrays.asList(stRule.getBodyAtoms()));
                }
                //Creates new schema object
                DatabaseSchema schema = new DatabaseSchema();
                tAtoms.forEach(atom -> generateSchema(schema, atom, true));
                sAtoms.forEach(atom -> generateSchema(schema, atom, false));
                if (sSchema != null) {
                    schema.save(new File(sSchema), false);
                }
                if (tSchema != null) {
                    schema.save(new File(tSchema), true);
                }

            }
        }
    }

    //Can be much shorter but is good to check the arity is still correct
    private static void getAtoms(Rule rule, List<Atom> atoms) {
        for (Atom atom : rule.getHeadAtoms()) {
            if (atoms.indexOf(atom) >= 0) {
                Atom already = atoms.get(atoms.indexOf(atom));
                //If the updating of atom arity didnt work in ModifyCB
                if (already.getNumberOfArguments() != atom.getNumberOfArguments()) {
                    System.out.println("Error in tgds");
                    System.out.println(rule);
                    System.out.println(already);
                }
            } else {
                atoms.add(atom);
            }

        }
        for (Atom atom : rule.getBodyAtoms()) {
            if (atoms.indexOf(atom) >= 0) {
                Atom already = atoms.get(atoms.indexOf(atom));
                //If the updating of atom arity didnt work in ModifyCB
                if (already.getNumberOfArguments() != atom.getNumberOfArguments()) {
                    System.out.println("Error in tgds");
                    System.out.println(rule);
                    System.out.println(already);
                }
            } else {
                atoms.add(atom);
            }

        }
    }

    //Creates schema objects from each atom of the list and adds it to teh schema
    private static void generateSchema(DatabaseSchema schema, Atom atom, boolean target) {
        if (!schema.getPredicates().contains(atom.getPredicate())) {
            String[] colName = new String[atom.getNumberOfArguments()];
            Domain[] doms = new Domain[atom.getNumberOfArguments()];
            for (int i = 0; i < atom.getNumberOfArguments(); i++) {
                Term temp = atom.getArgument(i);
                colName[i] = "c" + i;
                if (temp instanceof Constant)
                    doms[i] = ((Constant) temp).getDomain();
                else
                    doms[i] = Domain.STRING;
            }
            //Checks if the predicate is already in the schema
            PredicateSchema ps = schema.getPredicateSchema(atom.getPredicate());
            if (ps == null) {
                schema.addPredicateSchema(atom.getPredicate(), target, colName, doms);
            }
        }
    }

}
