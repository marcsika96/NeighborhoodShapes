package translate;

import java.io.File;

import org.eclipse.emf.common.util.URI;
import org.eclipse.emf.ecore.resource.Resource;
import org.eclipse.emf.ecore.resource.impl.ResourceSetImpl;
import org.eclipse.emf.ecore.xmi.impl.XMIResourceFactoryImpl;
import org.slizaa.neo4j.opencypher.OpenCypherStandaloneSetup;
import org.slizaa.neo4j.opencypher.openCypher.OpenCypherPackage;

public class MeasureConcreteSizes {
	public static void main( String... args ) throws Exception
	   {
		
		OpenCypherPackage.eINSTANCE.eClass();
		Resource.Factory.Registry.INSTANCE.getExtensionToFactoryMap().put("xmi",new XMIResourceFactoryImpl());
		OpenCypherStandaloneSetup.doSetup();
		
	       File root = new File("C:\\Users\\user\\ViatraSolver-AllicationWS\\GeneratorPlugin\\measurementB");
	       System.out.println("start");
	       
	       for(File size : root.listFiles()) {
	    	   if(size.isDirectory()) {
	    		   for(File run : size.listFiles()) {
		               if(run.isDirectory()) {
		                   for(File cypher : run.listFiles()) {
		                       if(cypher.getName().endsWith(".cypher")) {
		                    	   
		                    	   ResourceSetImpl resourceSetImpl = new ResourceSetImpl();
		                    	   Resource resource = resourceSetImpl.getResource(URI.createFileURI(cypher.getAbsolutePath()), true);
		                    	   System.out.println(PostProcessor.getSize(resource));
		                       }
		                   }
		               }
		           }
	    	   }
	           
	       }
	       System.out.println("finish");
	   }
}
