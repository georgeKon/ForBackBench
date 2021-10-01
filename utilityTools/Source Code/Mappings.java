
import org.semanticweb.owlapi.apibinding.OWLManager;
import org.semanticweb.owlapi.model.*;
import uk.ac.ox.cs.chaseBench.model.*;
import uk.ac.ox.cs.chaseBench.parser.CommonParser;
import uk.ac.ox.cs.chaseBench.processors.InputCollector;

import java.io.*;
import java.util.*;
import java.util.stream.Stream;

public class Mappings {

    private static Random random;

    public static void main(String[] args) throws Exception {
        if (args.length == 0) {
            System.out.println("Supported options:");
            System.out.println("-st-tgds    <file>  | the file containing the source-to-target TGDs");
            System.out.println("-out        <file>  | the output file location");
        } else {
            String sttgds = null;
            String outLoc = null;

            for (int i = 0; i < args.length - 1; i += 2) {
                String argument = args[i];
                switch (argument) {
                    case "-st-tgds":
                        sttgds = args[i + 1];
                        break;
                    case "-out":
                        outLoc = args[i + 1];
                        break;
                    default:
                        System.out.println("Unknown option '" + argument + "'.");
                        break;

                }
            }
            if (sttgds == null) {
                System.out.println("Invalid argument setup: No source-to-target TGDs found");
            } else {
                random = new Random();
                //Gets st-tgds from the file
                List<Rule> stRules = getRules(sttgds);
                //Creates and output folder ready to be written to

                PrintStream printer;
                FileOutputStream fileOutputStream = null;
                if (outLoc != null) {
                    File output = new File(outLoc);
                    if (!output.exists()) {
                        output.createNewFile();
                    }
                    fileOutputStream = new FileOutputStream(output);
                    printer = new PrintStream(fileOutputStream);
                } else {
                    printer = System.out;
                }
                generateHeader("http://example.com/example.owl#", printer);
                stRules.forEach(rule -> generateMapping(rule, printer));
                generateBottom(printer);
                printer.close();
                if (fileOutputStream != null) {
                    fileOutputStream.close();
                }
            }
        }

    }

    private static Stream<OWLObjectPropertyDomainAxiom> getDomains(OWLOntology o) {
        return o.axioms().filter(x -> x.isOfType(AxiomType.OBJECT_PROPERTY_DOMAIN)).map(x -> (OWLObjectPropertyDomainAxiom) x);
    }


    private static Stream<OWLObjectPropertyRangeAxiom> getRanges(OWLOntology o) {
        return o.axioms().filter(x -> x.isOfType(AxiomType.OBJECT_PROPERTY_RANGE)).map(x -> (OWLObjectPropertyRangeAxiom) x);
    }

    //Removes the uri part from a property so that it only returns the reduced form
    public static String nameSpaced(Object originalString) {
        return originalString.toString().split("#")[1].split(">")[0];
    }

    static List<Rule> getRules(String file) throws Exception {
        List<Rule> cbRules = new ArrayList<>();
        InputStream resourceStream = new FileInputStream(file);
        Reader input = new InputStreamReader(resourceStream);
        StringBuilder output = new StringBuilder();
        char[] buffer = new char[4096];
        int read;
        while ((read = input.read(buffer)) != -1)
            output.append(buffer, 0, read);
        input.close();
        InputCollector inputCollector = new InputCollector(null, cbRules, null);
        CommonParser parser = new CommonParser(new StringReader(output.toString()));
        parser.parse(inputCollector);
        return cbRules;
    }


    private static void generateHeader(String namespace, PrintStream print) {
        print.println("[PrefixDeclaration]\n" +
                "ns:  " + namespace + "\n" +
                "\n" +
                "[MappingDeclaration] @collection [[");
    }

    private static void generateMapping(Rule rule, PrintStream print) {
        for (Atom atom : rule.getHeadAtoms()) {
            if (atom.getNumberOfArguments() > 2) {
                break;
            }
            String pred = atom.getPredicate().getName();
            print.println("mappingId ID" + random.nextInt());
            if (atom.getNumberOfArguments() == 1) {
                print.println("target  ns:ns/{var0} a ns:" + pred + " . ");
            } else if (atom.getNumberOfArguments() == 2) {
                print.println("target  ns:ns/{var0} ns:" + pred + " ns:ns/{var1} . ");
            }
            print.println("source  " + SQLConverter.addAliases(SQLConverter.queryToSQL(rule, false)));
            print.println();
        }


    }

    private static void generateBottom(PrintStream print) {
        print.println("]]");
    }


}




