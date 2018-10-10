package translate;

import java.io.File;
import java.util.HashMap;
import java.util.Map;
import java.util.Set;
import java.util.function.Consumer;
import org.eclipse.emf.common.util.URI;
import org.eclipse.emf.ecore.EObject;
import org.eclipse.emf.ecore.resource.Resource;
import org.eclipse.emf.ecore.resource.impl.ResourceSetImpl;
import org.eclipse.emf.ecore.xmi.impl.XMIResourceFactoryImpl;
import org.eclipse.xtend2.lib.StringConcatenation;
import org.eclipse.xtext.xbase.lib.CollectionLiterals;
import org.eclipse.xtext.xbase.lib.Conversions;
import org.eclipse.xtext.xbase.lib.Exceptions;
import org.eclipse.xtext.xbase.lib.Functions.Function1;
import org.eclipse.xtext.xbase.lib.InputOutput;
import org.eclipse.xtext.xbase.lib.IterableExtensions;
import org.eclipse.xtext.xbase.lib.ObjectExtensions;
import org.eclipse.xtext.xbase.lib.Procedures.Procedure1;
import org.slizaa.neo4j.opencypher.OpenCypherStandaloneSetup;
import org.slizaa.neo4j.opencypher.openCypher.AllOptions;
import org.slizaa.neo4j.opencypher.openCypher.Cypher;
import org.slizaa.neo4j.opencypher.openCypher.OpenCypherFactory;
import org.slizaa.neo4j.opencypher.openCypher.OpenCypherPackage;
import org.slizaa.neo4j.opencypher.openCypher.SinglePartQuery;

@SuppressWarnings("all")
public class Translator {
  public static void main(final String[] args) {
    OpenCypherPackage.eINSTANCE.eClass();
    Map<String, Object> _extensionToFactoryMap = Resource.Factory.Registry.INSTANCE.getExtensionToFactoryMap();
    XMIResourceFactoryImpl _xMIResourceFactoryImpl = new XMIResourceFactoryImpl();
    _extensionToFactoryMap.put("xmi", _xMIResourceFactoryImpl);
    OpenCypherStandaloneSetup.doSetup();
    final Translator t = new Translator();
    final HashMap<File, SinglePartQuery> models = t.loadModels("models");
    StringConcatenation _builder = new StringConcatenation();
    _builder.append("Load completed.");
    InputOutput.<String>println(_builder.toString());
    t.saveModels(models, "cypher");
    StringConcatenation _builder_1 = new StringConcatenation();
    _builder_1.append("Save completed.");
    InputOutput.<String>println(_builder_1.toString());
  }
  
  public HashMap<File, SinglePartQuery> loadModels(final String path) {
    final File folder = new File(path);
    final File[] files = folder.listFiles();
    final HashMap<File, SinglePartQuery> res = new HashMap<File, SinglePartQuery>();
    final Function1<File, Boolean> _function = (File it) -> {
      return Boolean.valueOf(it.getName().endsWith("xmi"));
    };
    Iterable<File> _filter = IterableExtensions.<File>filter(((Iterable<File>)Conversions.doWrapArray(files)), _function);
    for (final File file : _filter) {
      {
        final URI uri = URI.createFileURI(file.getAbsolutePath());
        final ResourceSetImpl rs = new ResourceSetImpl();
        final Resource resource = rs.getResource(uri, true);
        EObject _head = IterableExtensions.<EObject>head(resource.getContents());
        final SinglePartQuery query = ((SinglePartQuery) _head);
        res.put(file, query);
      }
    }
    return res;
  }
  
  public void saveModels(final HashMap<File, SinglePartQuery> file2Query, final String path) {
    final File folder = new File(path);
    final Consumer<File> _function = (File it) -> {
      it.delete();
    };
    IterableExtensions.<File>toList(((Iterable<File>)Conversions.doWrapArray(folder.listFiles()))).forEach(_function);
    Set<Map.Entry<File, SinglePartQuery>> _entrySet = file2Query.entrySet();
    for (final Map.Entry<File, SinglePartQuery> entry : _entrySet) {
      {
        final File original = entry.getKey();
        final SinglePartQuery model = entry.getValue();
        final ResourceSetImpl rsi = new ResourceSetImpl();
        StringConcatenation _builder = new StringConcatenation();
        String _absolutePath = folder.getAbsolutePath();
        _builder.append(_absolutePath);
        _builder.append("/");
        String _head = IterableExtensions.<String>head(((Iterable<String>)Conversions.doWrapArray(original.getName().split("\\."))));
        _builder.append(_head);
        _builder.append(".cypher");
        final URI uri = URI.createFileURI(_builder.toString());
        final Resource resource = rsi.createResource(uri);
        final OpenCypherFactory factory = OpenCypherFactory.eINSTANCE;
        final Cypher cypher = factory.createCypher();
        cypher.setStatement(model);
        AllOptions _createAllOptions = factory.createAllOptions();
        final Procedure1<AllOptions> _function_1 = (AllOptions it) -> {
          it.setExplain(false);
          it.setProfile(false);
        };
        AllOptions _doubleArrow = ObjectExtensions.<AllOptions>operator_doubleArrow(_createAllOptions, _function_1);
        cypher.setQueryOptions(_doubleArrow);
        resource.getContents().add(cypher);
        try {
          resource.save(CollectionLiterals.<Object, Object>emptyMap());
        } catch (final Throwable _t) {
          if (_t instanceof Exception) {
            final Exception e = (Exception)_t;
            StringConcatenation _builder_1 = new StringConcatenation();
            _builder_1.append("Unable to save file \"");
            String _absolutePath_1 = original.getAbsolutePath();
            _builder_1.append(_absolutePath_1);
            _builder_1.append("\"");
            _builder_1.newLineIfNotEmpty();
            _builder_1.append("--------------------");
            _builder_1.newLine();
            InputOutput.<String>println(_builder_1.toString());
            e.printStackTrace();
          } else {
            throw Exceptions.sneakyThrow(_t);
          }
        }
      }
    }
  }
}