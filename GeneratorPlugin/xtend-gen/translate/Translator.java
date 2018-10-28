package translate;

import com.google.common.collect.Iterables;
import java.io.File;
import java.util.Collections;
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
import org.eclipse.xtext.xbase.lib.IntegerRange;
import org.eclipse.xtext.xbase.lib.IterableExtensions;
import org.eclipse.xtext.xbase.lib.IteratorExtensions;
import org.slizaa.neo4j.opencypher.OpenCypherStandaloneSetup;
import org.slizaa.neo4j.opencypher.openCypher.Cypher;
import org.slizaa.neo4j.opencypher.openCypher.OpenCypherPackage;
import org.slizaa.neo4j.opencypher.openCypher.SinglePartQuery;
import translate.PostProcessor;

@SuppressWarnings("all")
public class Translator {
  public static void main(final String[] args) {
    OpenCypherPackage.eINSTANCE.eClass();
    Map<String, Object> _extensionToFactoryMap = Resource.Factory.Registry.INSTANCE.getExtensionToFactoryMap();
    XMIResourceFactoryImpl _xMIResourceFactoryImpl = new XMIResourceFactoryImpl();
    _extensionToFactoryMap.put("xmi", _xMIResourceFactoryImpl);
    OpenCypherStandaloneSetup.doSetup();
    final Translator t = new Translator();
    final Function1<Integer, Integer> _function = (Integer it) -> {
      return Integer.valueOf(((it).intValue() * 5));
    };
    Iterable<Integer> _map = IterableExtensions.<Integer, Integer>map(new IntegerRange(1, 10), _function);
    Iterable<Integer> _plus = Iterables.<Integer>concat(_map, Collections.<Integer>unmodifiableList(CollectionLiterals.<Integer>newArrayList(Integer.valueOf(100), Integer.valueOf(150), Integer.valueOf(200))));
    for (final Integer scenario : _plus) {
      for (int i = 1; (i <= 10); i++) {
        {
          final HashMap<File, SinglePartQuery> models = t.loadModels(((("measurementB/models" + scenario) + "/run") + Integer.valueOf(i)));
          t.saveModels(models, ((("measurementB/cyphers" + scenario) + "/run") + Integer.valueOf(i)));
        }
      }
    }
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
        IteratorExtensions.<EObject>toList(resource.getAllContents());
        EObject _head = IterableExtensions.<EObject>head(resource.getContents());
        final SinglePartQuery query = ((SinglePartQuery) _head);
        res.put(file, query);
      }
    }
    return res;
  }
  
  public void saveModels(final HashMap<File, SinglePartQuery> file2Query, final String path) {
    final File folder = new File(path);
    folder.mkdirs();
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
        final long startTime = System.nanoTime();
        final Cypher cypher = new PostProcessor().postProcessModel(model);
        resource.getContents().add(cypher);
        final long postProcessingFinished = System.nanoTime();
        try {
          resource.save(CollectionLiterals.<Object, Object>emptyMap());
          final long saveFinished = System.nanoTime();
          StringConcatenation _builder_1 = new StringConcatenation();
          _builder_1.append("Successfully saved file \"");
          String _absolutePath_1 = original.getAbsolutePath();
          _builder_1.append(_absolutePath_1);
          _builder_1.append(";");
          _builder_1.append((postProcessingFinished - startTime));
          _builder_1.append(";");
          _builder_1.append((saveFinished - postProcessingFinished));
          InputOutput.<String>println(_builder_1.toString());
        } catch (final Throwable _t) {
          if (_t instanceof Exception) {
            final Exception e = (Exception)_t;
            StringConcatenation _builder_2 = new StringConcatenation();
            _builder_2.append("Unable to save file \"");
            String _absolutePath_2 = original.getAbsolutePath();
            _builder_2.append(_absolutePath_2);
            _builder_2.append("\"");
            _builder_2.newLineIfNotEmpty();
            _builder_2.append("--------------------");
            _builder_2.newLine();
            InputOutput.<String>println(_builder_2.toString());
            e.printStackTrace(System.out);
          } else {
            throw Exceptions.sneakyThrow(_t);
          }
        }
      }
    }
  }
}
