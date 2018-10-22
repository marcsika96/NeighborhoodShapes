package translate;

import com.google.common.collect.Iterators;
import java.util.List;
import org.eclipse.emf.common.util.EList;
import org.eclipse.xtend2.lib.StringConcatenation;
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
    final List<MapLiteralEntry> mapkeys = IteratorExtensions.<MapLiteralEntry>toList(Iterators.<MapLiteralEntry>filter(model.eAllContents(), MapLiteralEntry.class));
    int _size_2 = mapkeys.size();
    final ExclusiveRange mapKeyIndexes = new ExclusiveRange(0, _size_2, true);
    for (final Integer i_2 : mapKeyIndexes) {
      MapLiteralEntry _get_2 = mapkeys.get((i_2).intValue());
      StringConcatenation _builder_2 = new StringConcatenation();
      _builder_2.append("Key");
      _builder_2.append(((i_2).intValue() + 1));
      _get_2.setKey(_builder_2.toString());
    }
    final List<NodeLabel> labels = IteratorExtensions.<NodeLabel>toList(Iterators.<NodeLabel>filter(model.eAllContents(), NodeLabel.class));
    int _size_3 = labels.size();
    final ExclusiveRange labelIndexes = new ExclusiveRange(0, _size_3, true);
    for (final Integer i_3 : labelIndexes) {
      NodeLabel _get_3 = labels.get((i_3).intValue());
      StringConcatenation _builder_3 = new StringConcatenation();
      _builder_3.append("Label");
      _builder_3.append(((i_3).intValue() + 1));
      _get_3.setLabelName(_builder_3.toString());
    }
    final List<RelationshipDetail> relDetails = IteratorExtensions.<RelationshipDetail>toList(Iterators.<RelationshipDetail>filter(model.eAllContents(), RelationshipDetail.class));
    int _size_4 = relDetails.size();
    final ExclusiveRange relDetailsIndexes = new ExclusiveRange(0, _size_4, true);
    for (final Integer i_4 : relDetailsIndexes) {
      EList<String> _relTypeNames = relDetails.get((i_4).intValue()).getRelTypeNames();
      StringConcatenation _builder_4 = new StringConcatenation();
      _builder_4.append("RelTypeName");
      _builder_4.append(((i_4).intValue() + 1));
      _relTypeNames.add(_builder_4.toString());
    }
    return cypher;
  }
}
