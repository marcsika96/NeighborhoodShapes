
abstract sig EObject{}

abstract sig Module extends EObject{
	provides: set Signal,
	consumes: set Signal
}

sig Composite extends Module{
	submodules: set Module,
	protectedIP: one ProtectedIP	
}

sig Control extends Module{
	type: one ControlUnitType
}

sig Signal extends EObject{}

abstract sig Specialist{
	modifiable: set EObject,
	visible: set EObject,
    responsibility : one Composite
}

sig  FanSpecialist, HeaterSpecialist, PumpSpecialist extends Specialist {}

abstract sig ProtectedIP {}
one sig True, False extends ProtectedIP {}

abstract sig ControlUnitType {}
one sig FanCtrl, HeaterCtrl, PumpCtrl extends ControlUnitType {}
-----------------------------------
//constraints

fact{
	all spec : Specialist{
		all comp : Composite{
			comp not in spec.responsibility implies comp.submodules not in spec.modifiable
		}
	}
}


//modifiability constraint
fact {
	all o: EObject, s: Specialist {
		(s->o in modifiable)
			<=>
		(some control : Control {
			(control in s.responsibility.^submodules) 
				and
			(o = control or o in control.provides)
				and
			((control.type=FanCtrl and s in FanSpecialist)
				or
			 (control.type=PumpCtrl and s in PumpSpecialist)
				or
		   	 (control.type=HeaterCtrl and s in HeaterSpecialist))
		})
	}
}

//visiblity constraint
fact{
	all s: Specialist, o : EObject{
			(s->o in visible)    
				<=> 
			(s.responsibility.protectedIP in False)
				and			
			((o in s.responsibility)
			    or 
			(o in s.responsibility.^submodules)
			    or 
			(o in s.responsibility.provides)
		   	    or 
			(o in s.responsibility.^submodules.provides))

}
}

//other constraints
--egy modul providol minden signalt
fact{
	all signal : Signal { one myModule : Module | signal in myModule.provides }
}

//other constraints
--egy modul providol minden signalt
fact{
	all signal : Signal { one myModule : Module | signal in myModule.provides }
}

--minden kontrol egy kompozit submodulja
fact {
	all control : Control { one composit : Composite | control in composit.submodules }
}

-- minden kontorolnak pontosan egy őse van csak egy kopozit submodulja
fact {
	all m: Module, c1,c2: Composite {m in c1.submodules and m in c2.submodules implies c1 = c2 }
}

--egy kontol valakinek a submodulja akkor valaki másnak már nem lehet a submodulja
fact{
	all comp1, comp2 : Composite{
		all control : Control |
			(control in comp1.submodules  and comp1 != comp2)implies
				control not in comp2.submodules
		
	}
}

--senki nem lehet önmaga submoduljai között
fact{
	no mod : Module | mod in mod.^submodules 
}

--egy sugnal csak akkor providolhat és fogyaszthat két mudul ha ugyanaz az ősük
fact{
	all mod1, mod2 : Module{
		all signal : Signal {
			(signal in mod1.provides and signal in mod2.consumes) implies 
				mod1.~submodules = mod2.~submodules
		}
	} 
}

//shape constraints

abstract sig NodeShape {
	objects : set EObject
}
one sig S2,S3,S4,S5 extends NodeShape {

}
fact {
	all o:EObject {
		(o in S2.objects <=> S2[o])
	and (o in S3.objects <=> S3[o])
	and (o in S4.objects <=> S4[o])
	and (o in S5.objects <=> S5[o])

}
}


pred S1[spec: Specialist]{
	spec in Specialist and
	some comp : Composite, control : Control, signal : Signal { 
		comp in spec.responsibility and
		control in spec.modifiable and 
		signal in spec.modifiable 
		}
}

pred S2 [comp : EObject]{
	comp in Composite and
	comp.protectedIP in True and
	some comp2 : Composite {
		comp2 in comp.submodules and 
		comp.provides = none and
		comp.consumes = none 
		}
}

pred S3 [comp : EObject]{
	comp in Composite and
	comp.protectedIP in False and
	some comp2 : Composite, spec : Specialist, control : Control {
		comp in comp2.submodules and 
		comp in spec.responsibility and
		control in comp.submodules and 
		comp.provides = none and
		comp.consumes = none 
		}
}

pred S4 [control : EObject] {
	control in Control and
	some comp : Composite , spec : Specialist, signal : Signal{
		control in spec.modifiable and
		control in comp.submodules and 
		signal in control.provides and 
 		control.consumes = none 
		}
}

pred S5 [signal : EObject]{
	signal in Signal and
	(some control : Control{
		signal in control.provides 
	})and
	(no modul : Module { 
		signal in modul.consumes
	 })
}

fact { some object : EObject |
	 !(S2[object]) and !(S3[object]) and !(S4[object]) and !(S5[object])
}

fact { all spec : Specialist | 	S1[spec]}

 

run {} for exactly 5 EObject, exactly 1 Specialist
run {} for exactly 6 EObject, exactly 1 Specialist
run {} for exactly 7 EObject, exactly 1 Specialist
run {} for exactly 8 EObject, exactly 1 Specialist
run {} for exactly 9 EObject, exactly 1 Specialist
run {} for exactly 10 EObject, exactly 1 Specialist
run {} for exactly 11 EObject, exactly 1 Specialist
run {} for exactly 12 EObject, exactly 1 Specialist
run {} for exactly 13 EObject, exactly 1 Specialist
run {} for exactly 14 EObject, exactly 1 Specialist
run {} for exactly 15 EObject, exactly 1 Specialist
run {} for exactly 16 EObject, exactly 1 Specialist
run {} for exactly 17 EObject, exactly 1 Specialist
run {} for exactly 18 EObject, exactly 1 Specialist
run {} for exactly 19 EObject, exactly 1 Specialist
