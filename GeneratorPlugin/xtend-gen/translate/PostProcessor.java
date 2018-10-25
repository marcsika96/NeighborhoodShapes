package translate;

import com.google.common.collect.Iterators;
import java.util.Collections;
import java.util.List;
import java.util.Random;
import org.eclipse.emf.common.util.EList;
import org.eclipse.xtend2.lib.StringConcatenation;
import org.eclipse.xtext.xbase.lib.CollectionLiterals;
import org.eclipse.xtext.xbase.lib.ExclusiveRange;
import org.eclipse.xtext.xbase.lib.IteratorExtensions;
import org.eclipse.xtext.xbase.lib.ObjectExtensions;
import org.eclipse.xtext.xbase.lib.Procedures.Procedure1;
import org.slizaa.neo4j.opencypher.openCypher.AllOptions;
import org.slizaa.neo4j.opencypher.openCypher.Cypher;
import org.slizaa.neo4j.opencypher.openCypher.MapLiteralEntry;
import org.slizaa.neo4j.opencypher.openCypher.NodeLabel;
import org.slizaa.neo4j.opencypher.openCypher.OpenCypherFactory;
import org.slizaa.neo4j.opencypher.openCypher.RelationshipDetail;
import org.slizaa.neo4j.opencypher.openCypher.Return;
import org.slizaa.neo4j.opencypher.openCypher.SinglePartQuery;
import org.slizaa.neo4j.opencypher.openCypher.StringLiteral;
import org.slizaa.neo4j.opencypher.openCypher.VariableDeclaration;

@SuppressWarnings("all")
public class PostProcessor {
  public Cypher postProcessModel(final SinglePartQuery model) {
    final OpenCypherFactory factory = OpenCypherFactory.eINSTANCE;
    final Cypher cypher = factory.createCypher();
    int _hashCode = "Marcsi".hashCode();
    final Random random = new Random(_hashCode);
    cypher.setStatement(model);
    AllOptions _createAllOptions = factory.createAllOptions();
    final Procedure1<AllOptions> _function = (AllOptions it) -> {
      it.setExplain(false);
      it.setProfile(false);
    };
    AllOptions _doubleArrow = ObjectExtensions.<AllOptions>operator_doubleArrow(_createAllOptions, _function);
    cypher.setQueryOptions(_doubleArrow);
    final Procedure1<Return> _function_1 = (Return it) -> {
      it.setReturn("RETURN");
    };
    IteratorExtensions.<Return>forEach(Iterators.<Return>filter(model.eAllContents(), Return.class), _function_1);
    final List<VariableDeclaration> variables = IteratorExtensions.<VariableDeclaration>toList(Iterators.<VariableDeclaration>filter(model.eAllContents(), VariableDeclaration.class));
    int _size = variables.size();
    final ExclusiveRange variableIndexes = new ExclusiveRange(0, _size, true);
    for (final Integer i : variableIndexes) {
      VariableDeclaration _get = variables.get((i).intValue());
      StringConcatenation _builder = new StringConcatenation();
      _builder.append("V");
      _builder.append(((i).intValue() + 1));
      _get.setName(_builder.toString());
    }
    final List<StringLiteral> stringliterals = IteratorExtensions.<StringLiteral>toList(Iterators.<StringLiteral>filter(model.eAllContents(), StringLiteral.class));
    int _size_1 = stringliterals.size();
    final ExclusiveRange stringLiteralIndexes = new ExclusiveRange(0, _size_1, true);
    for (final Integer i_1 : stringLiteralIndexes) {
      StringLiteral _get_1 = stringliterals.get((i_1).intValue());
      StringConcatenation _builder_1 = new StringConcatenation();
      _builder_1.append("\"String");
      _builder_1.append(((i_1).intValue() + 1));
      _builder_1.append("\"");
      _get_1.setValue(_builder_1.toString());
    }
    final List<String> keysToUse = Collections.<String>unmodifiableList(CollectionLiterals.<String>newArrayList("id", "active", "position", "currentPosition", "length", "signal"));
    final List<String> nodeLabelsToUse = Collections.<String>unmodifiableList(CollectionLiterals.<String>newArrayList("Region", "Route", "Segment", "Semaphore", "Sensor", "Switch", "SwitchPosition"));
    final List<String> relTypeNamesToUse = Collections.<String>unmodifiableList(CollectionLiterals.<String>newArrayList("connectsTo", "entry", "exit", "follows", "monitoredBy", "monitors", "requires", "target"));
    final List<MapLiteralEntry> mapkeys = IteratorExtensions.<MapLiteralEntry>toList(Iterators.<MapLiteralEntry>filter(model.eAllContents(), MapLiteralEntry.class));
    int _size_2 = mapkeys.size();
    final ExclusiveRange mapKeyIndexes = new ExclusiveRange(0, _size_2, true);
    for (final Integer i_2 : mapKeyIndexes) {
      MapLiteralEntry _get_2 = mapkeys.get((i_2).intValue());
      _get_2.setKey(this.selectRandomly(keysToUse, random));
    }
    final List<NodeLabel> labels = IteratorExtensions.<NodeLabel>toList(Iterators.<NodeLabel>filter(model.eAllContents(), NodeLabel.class));
    int _size_3 = labels.size();
    final ExclusiveRange labelIndexes = new ExclusiveRange(0, _size_3, true);
    for (final Integer i_3 : labelIndexes) {
      NodeLabel _get_3 = labels.get((i_3).intValue());
      _get_3.setLabelName(this.selectRandomly(nodeLabelsToUse, random));
    }
    final List<RelationshipDetail> relDetails = IteratorExtensions.<RelationshipDetail>toList(Iterators.<RelationshipDetail>filter(model.eAllContents(), RelationshipDetail.class));
    int _size_4 = relDetails.size();
    final ExclusiveRange relDetailsIndexes = new ExclusiveRange(0, _size_4, true);
    for (final Integer i_4 : relDetailsIndexes) {
      EList<String> _relTypeNames = relDetails.get((i_4).intValue()).getRelTypeNames();
      String _selectRandomly = this.selectRandomly(relTypeNamesToUse, random);
      _relTypeNames.add(_selectRandomly);
    }
    return cypher;
  }
  
  protected String selectRandomly(final List<String> collection, final Random random) {
    return collection.get(random.nextInt(collection.size()));
  }
}
