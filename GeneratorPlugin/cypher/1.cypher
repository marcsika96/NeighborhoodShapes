MATCH ( V1 : Label1 { Key1 : "String1" , Key2 : "String2" } ) ,
( V2 : Label3 { Key3 : "String3" , Key4 : "String4" } ) ,
( V3 : Label6 { Key5 : "String5" , Key6 : "String6" } )
	- [ V4 : RelTypeName1 { Key7 : "String7" , Key8 : "String8" } ] -
	( V5 : Label11 { Key9 : "String9" , Key10 : "String10" } ) -
	[ V6 : RelTypeName2 { Key11 : "String11" , Key12 : "String12" } ] -
	( V7 : Label16 { Key13 : "String13" , Key14 : "String14" } ) ,
( V8 : Label19 { Key15 : "String15" , Key16 : "String16" } ) ,
( V9 : Label22 { Key17 : "String17" , Key18 : "String18" } )
RETURN V6 , V9 , V2 , V2 , V3 , V3 , V5