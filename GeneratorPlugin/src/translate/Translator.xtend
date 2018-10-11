package translate

import java.io.File
import java.util.HashMap
import org.eclipse.emf.common.util.URI
import org.eclipse.emf.ecore.resource.Resource
import org.eclipse.emf.ecore.resource.impl.ResourceSetImpl
import org.eclipse.emf.ecore.xmi.impl.XMIResourceFactoryImpl
import org.slizaa.neo4j.opencypher.OpenCypherStandaloneSetup
import org.slizaa.neo4j.opencypher.openCypher.Cypher
import org.slizaa.neo4j.opencypher.openCypher.OpenCypherFactory
import org.slizaa.neo4j.opencypher.openCypher.OpenCypherPackage
import org.slizaa.neo4j.opencypher.openCypher.Return
import org.slizaa.neo4j.opencypher.openCypher.SinglePartQuery
import org.slizaa.neo4j.opencypher.openCypher.VariableDeclaration
import org.slizaa.neo4j.opencypher.openCypher.StringLiteral

class Translator {
	def static void main(String[] args) {
		OpenCypherPackage.eINSTANCE.eClass
		Resource.Factory.Registry.INSTANCE.extensionToFactoryMap.put("xmi",new XMIResourceFactoryImpl)
		OpenCypherStandaloneSetup.doSetup
		
		val t = new Translator
		
		val models = t.loadModels("models")
		println('''Load completed.''')
		t.saveModels(models,"cypher")
		println('''Save completed.''')
	}
	
	def loadModels(String path) {
		val folder = new File(path)
		val files = folder.listFiles
		
		val res = new HashMap
		
		for(file : files.filter[name.endsWith("xmi")]) {
			val uri = URI.createFileURI(file.absolutePath)
			val rs = new ResourceSetImpl
			val resource = rs.getResource(uri,true);
			val SinglePartQuery query = resource.contents.head as SinglePartQuery
			res.put(file,query)
		}
		
		return res
	}
	
	def saveModels(HashMap<File, SinglePartQuery> file2Query, String path) {
		val folder = new File(path)
		
		folder.listFiles.toList.forEach[delete]
		
		for(entry : file2Query.entrySet) {
			val original = entry.key
			val model = entry.value
			
			val rsi = new ResourceSetImpl
			val uri = URI.createFileURI('''«folder.absolutePath»/«original.name.split("\\.").head».cypher''')
			val resource = rsi.createResource(uri)
			
			
			val cypher = postProcessModel(model)
			resource.contents.add(cypher)
			
			try{
				resource.save(emptyMap)
				println('''Successfully saved file "«original.absolutePath»"''')
			} catch(Exception e) {
				println('''
				Unable to save file "«original.absolutePath»"
				--------------------
				''')
				e.printStackTrace(System.out)
			}
		}
	}
	
	protected def Cypher postProcessModel(SinglePartQuery model) {
		val factory = OpenCypherFactory.eINSTANCE
		val cypher = factory.createCypher
		cypher.statement = model
		cypher.queryOptions = factory.createAllOptions => [it.explain = false it.profile = false]
		// return fill "Return"
		model.eAllContents.filter(Return).forEach[it.^return = "RETURN"]
		// variable name filling
		val variables = model.eAllContents.filter(VariableDeclaration).toList
		val variableIndexes = 1..variables.size
		for(i : variableIndexes) {
			variables.get(i-1).name = '''V«i»'''
		}
		// string name literals
		val stringliterals = model.eAllContents.filter(StringLiteral).toList
		val stringLiteralIndexes = 1..stringliterals.size
		for(i : stringLiteralIndexes) {
			stringliterals.get(i-1).value ='''"String«i»"'''
		}
		
		return cypher
	}
}