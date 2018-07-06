
abstract sig EObject{}

abstract sig Module extends EObject{
	provides: set Signal,
	consumes: set Signal
}

sig Composite extends Module{
	submodules: set Module	
}

sig Control extends Module{}

sig Signal extends EObject{}

sig Specialist{
	modifiable: set EObject,
	visible: set EObject,
    responsibility : one Composite
}

fact{ all spec : Specialist  {
	some comp1, comp2 : Composite, control1, control2 : Control, signal : Signal { 
		comp1 in spec.visible and 
		comp1 in spec.responsibility and
		comp2 in spec.visible and 
		control1 in spec.visible  and 
		control2 in spec.modifiable and 
		signal in spec.modifiable 
		}
	}
}

fact { some comp1 : Composite {
	some comp2 : Composite, control : Control,  spec : Specialist {
		comp2 in comp1.submodules and
		control in  comp1.submodules and
		comp1 in spec.responsibility and
		comp1 in spec.modifiable
		}
	}
}

fact { some comp2 : Composite {
	some comp1 : Composite, signal : Signal,  spec : Specialist  {
		comp2 in comp1.submodules and
		signal in comp2.consumes and
		comp2 in spec.visible
		}
	}
}

fact { some control1 : Control {
	some comp : Composite,  spec : Specialist{
		control1 in spec.visible and
		control1 in comp.submodules
		}
	}
}

fact { some control2 : Control {
	some comp : Composite,  spec : Specialist, signal : Signal{
		control2 in spec.modifiable and
		control2 in comp.submodules and
		signal in control2.provides
		}
	}
}

fact { all signal : Signal{
	some control : Control, comp : Composite, spec : Specialist{
		signal in control.provides and
		signal in comp.consumes and
		signal in spec.modifiable
		}
	}
}

run {}
