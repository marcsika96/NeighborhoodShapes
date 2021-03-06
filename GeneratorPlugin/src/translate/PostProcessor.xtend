package translate

import java.util.List
import java.util.Random
import org.slizaa.neo4j.opencypher.openCypher.Cypher
import org.slizaa.neo4j.opencypher.openCypher.MapLiteralEntry
import org.slizaa.neo4j.opencypher.openCypher.NodeLabel
import org.slizaa.neo4j.opencypher.openCypher.OpenCypherFactory
import org.slizaa.neo4j.opencypher.openCypher.RelationshipDetail
import org.slizaa.neo4j.opencypher.openCypher.RelationshipTypes
import org.slizaa.neo4j.opencypher.openCypher.Return
import org.slizaa.neo4j.opencypher.openCypher.SinglePartQuery
import org.slizaa.neo4j.opencypher.openCypher.StringLiteral
import org.slizaa.neo4j.opencypher.openCypher.VariableDeclaration
import java.util.HashSet
import java.util.LinkedList
import org.slizaa.neo4j.opencypher.openCypher.VariableRef
import org.slizaa.neo4j.opencypher.openCypher.NodePattern
import org.slizaa.neo4j.opencypher.openCypher.MapLiteral
import org.slizaa.neo4j.opencypher.openCypher.RelationshipPattern
import org.eclipse.emf.ecore.resource.Resource

class PostProcessor {
	public def Cypher postProcessModel(SinglePartQuery model) {
		val factory = OpenCypherFactory.eINSTANCE
		val cypher = factory.createCypher
		val random = new Random("Marcsi".hashCode)
		cypher.statement = model
		cypher.queryOptions = factory.createAllOptions => [it.explain = false it.profile = false]
		// return fill "Return"
		model.eAllContents.filter(Return).forEach[it.^return = "RETURN"]
		// variable name filling
		val variables = model.eAllContents.filter(VariableDeclaration).toList
		val variableIndexes = 0..<variables.size
		for(i : variableIndexes) {
			variables.get(i).name = '''V«i+1»'''
		}
		// string name literals
		val stringliterals = model.eAllContents.filter(StringLiteral).toList
		val stringLiteralIndexes = 0..<stringliterals.size
		for(i : stringLiteralIndexes) {
			stringliterals.get(i).value ='''"String«i+1»"'''
		}
	
		
		val keysToUse = #["id", "active", "position", "currentPosition", "length", "signal"]
		
		val nodeLabelsToUse = #["Region", "Route", "Segment", "Semaphore", "Sensor", "Switch", 
								"SwitchPosition"]
		val relTypeNamesToUse = #["connectsTo", "entry", "exit", "follows", "monitoredBy","monitors",
								"requires", "target"]
			
			
				//MapliteralEntry keys
		val mapkeys = model.eAllContents.filter(MapLiteralEntry).toList
		val mapKeyIndexes = 0..<mapkeys.size
		for(i : mapKeyIndexes){
			mapkeys.get(i).key = keysToUse.selectRandomly(random)
		}
								
		//NodeLabelNames keys
		val labels = model.eAllContents.filter(NodeLabel).toList
		val labelIndexes = 0..<labels.size
		for(i : labelIndexes){
			labels.get(i).labelName = nodeLabelsToUse.selectRandomly(random)
		}

		//RelationshipDetail.relTypeNames
		val relDetails = model.eAllContents.filter(RelationshipDetail).toList
		val relDetailsIndexes = 0..<relDetails.size
		for(i : relDetailsIndexes){
			relDetails.get(i).relTypeNames += relTypeNamesToUse.selectRandomly(random)
		}
		
		//Filter returns
		for(ret : model.eAllContents.filter(Return).toList) {
			val usedVariables = new HashSet
			val itemToDelete = new LinkedList
			
			for(i : ret.body.returnItems.items) {
				val valRef = i.expression as VariableRef
				val declaration = valRef.variableRef
				if(usedVariables.contains(declaration)) {
					itemToDelete += i
				} else {
					usedVariables += declaration
				}			
			}
			
			ret.body.returnItems.items.removeAll(itemToDelete)
			
 		}
 		
 		
 		//filter mapliterals
 		
 		cypher.eAllContents.filter(NodePattern).forEach[
 			if(it.properties instanceof MapLiteral) {
 				it.properties = null
 			}
 		]
 		cypher.eAllContents.filter(RelationshipDetail).forEach[
 			if(it.properties instanceof MapLiteral) {
 				it.properties = null
 			}
 		]
 		
 		println(cypher.eAllContents.filter(StringLiteral).size)
		
		return cypher
	}
	
	protected def String selectRandomly(List<String> collection, Random random) {
		collection.get(random.nextInt(collection.size))
	}
	
	def public static getSize(Resource r) {
		r.allContents.size
	}
}