Usine := Object clone do (
	
	DummyObject := Object clone do (
		Suite := Object clone do (
			variantName := nil
			bodyBlock   := nil
			eval 				:= method(x,
				context := Object clone
				context setSlot(variantName, x)
				
				context doMessage(bodyBlock)
			)
		)
		
		suite := method(
			s := Suite clone
			
			s variantName = call argAt(0) name
			s bodyBlock		= call argAt(1)
			
			s
		)
	)
	
  factories := Object clone
	suites		:= Object clone
  
  create    := method (factory,
		dummy := factories getSlot(factory) clone
		parentProto := dummy protos first
		parentProto slotNames foreach(slotName,
			value := nil
			
			if(parentProto getSlot(slotName) type == "Suite",
				if(suites getSlot(slotName),
					value = suites getSlot(slotName) + 1
					suites setSlot(slotName, value)
					,
					value = suites setSlot(slotName, 0)
				)
			
				dummy setSlot(slotName, dummy getSlot(slotName) eval(value))
			)
		)
		
		dummy
  )
  
  declare   := method (factory, 
		object := Object clone	
		call sender setSlot(call argAt(1) name, object)
		call sender appendProto(DummyObject)
		call evalArgAt(2)
    factories setSlot(factory,object)
  )
)

u := Usine clone 

u declare("user", user,
  user firstname := "John"
  user lastname  := "Connor"
  user age			 := suite(a, a+2)
)

a := u create("user") 
b := u create("user") 

a print
b print

