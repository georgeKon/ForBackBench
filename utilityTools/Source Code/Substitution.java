
import uk.ac.ox.cs.chaseBench.model.Atom;
import uk.ac.ox.cs.chaseBench.model.LabeledNull;
import uk.ac.ox.cs.chaseBench.model.Term;
import uk.ac.ox.cs.chaseBench.model.Variable;

import java.util.HashMap;
import java.util.Map;
import java.util.Objects;

/**
 * Holds a mapping from terms to terms and keeps track of the
 * null count for creating new labelled nulls
 *
 * @author Adam Putland
 */
public class Substitution {
    protected Map<Term, Term> mapping;
    protected int nullCount;
    protected int renameingCount;

    public Substitution(Map<Term, Term> mapping) {
        this.mapping = new HashMap<>(mapping);
    }

    public Substitution(Map<Term, Term> mapping, int nullCount) {
        this.mapping = new HashMap<>(mapping);
        this.nullCount = nullCount;
    }

    public  Substitution(Substitution substitution){
        this.mapping = new HashMap<>(substitution.getMapping());
        this.nullCount = substitution.getNullCount();
    }

    /**
     * Applies substitution to an atom
     * If no mapping, creates a labelled null
     * @param atom
     * @return
     */
    public Atom apply(Atom atom) {
        Term[] newTerms = new Term[atom.getNumberOfArguments()];

        for(int i = 0; i < newTerms.length; ++i) {
            Term term = atom.getArgument(i);

            if(!mapping.containsKey(term)) {
                mapping.put(term,  LabeledNull.create(String.valueOf(nullCount)));
                nullCount++;
            }

            newTerms[i] = mapping.get(term);
        }

        return Atom.create(atom.getPredicate(), newTerms);
    }

    /**
     * Applies substitution to an atom, leaves term as
     * original if not in mapping
     * @param atom
     * @return
     */
    public Atom exactApply(Atom atom){
        Term[] newTerms = new Term[atom.getNumberOfArguments()];

        for(int i = 0; i < newTerms.length; ++i) {
            Term term = atom.getArgument(i);

            if(mapping.containsKey(term)) {
                newTerms[i] = mapping.get(term);
            }else{
                newTerms[i] = term;
            }
        }

        return Atom.create(atom.getPredicate(), newTerms);
    }

    /**
     * Applies substitution to an atom, rename term
     * if not in mapping
     * @param atom
     * @return
     */
    public Atom renameApply(Atom atom, int renameingCount){
        Term[] newTerms = new Term[atom.getNumberOfArguments()];

        for(int i = 0; i < newTerms.length; ++i) {
            Term term = atom.getArgument(i);

            if(mapping.containsKey(term)) {
                newTerms[i] = mapping.get(term);
            }else{
            	//mapping.put(term,  Variable.create(term.toString()+"9"));
                newTerms[i] = Variable.create(term.toString().replaceAll("\\?", "")+renameingCount);
                renameingCount++;
            }
        }
        this.renameingCount = renameingCount;
        return Atom.create(atom.getPredicate(), newTerms);
    }
    
    /**
     * Extends the current substitution mapping with a new mapping
     * @param extension
     */
    public void extend(Map<Term, Term> extension){
        for (Map.Entry me: extension.entrySet()) {
            this.mapping.put((Term) me.getKey(), (Term) me.getValue());
        }
    }

    public void extend(Substitution substitution){
        extend(substitution.getMapping());
    }



    public Map<Term, Term> getMapping() {
        return mapping;
    }
    public int getNullCount() { return nullCount; }

    @Override
    public String toString() {
        return "Homomorphism{" +
                "mapping=" + mapping +
                '}';
    }

    @Override
    public boolean equals(Object o) {
        if (this == o) return true;
        if (o == null || getClass() != o.getClass()) return false;
        Substitution that = (Substitution) o;
        return Objects.equals(mapping, that.mapping);
    }

    @Override
    public int hashCode() {
        return Objects.hash(mapping);
    }
}

class Utils{

    /**
     * Finds the mgu between two atoms, treats LabeledNull as a variable
     * @param first
     * @param second
     * @return
     */
    public static Substitution findUnification(Atom first, Atom second){
        Map<Term, Term> mapping = new HashMap<>();

        if (!first.getPredicate().equals(second.getPredicate())
                || first.getNumberOfArguments()!=second.getNumberOfArguments()) return null;

        for (int i=0;i<first.getNumberOfArguments();i++){
            Term firstTerm = mapping.getOrDefault(first.getArgument(i), first.getArgument(i));
            Term secondTerm = mapping.getOrDefault(second.getArgument(i), second.getArgument(i));

            if (firstTerm.equals(secondTerm)) continue;

            if (firstTerm instanceof Variable || firstTerm instanceof LabeledNull){
                mapping.put(firstTerm, secondTerm);
            }else if (secondTerm instanceof Variable || secondTerm instanceof LabeledNull){
                mapping.put(secondTerm, firstTerm);
            }else{
                //Both are constants
                return null;
            }
        }

        return new Substitution(mapping);
    }
}
