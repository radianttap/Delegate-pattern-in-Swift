//**
//	https://github.com/radianttap/Learn-Swift-through-Examples
//
//	© Copyright Aleksandar Vacić, 2017
//	
//	Licensed under: Creative Commons Attribution Share Alike 4.0
//	https://choosealicense.com/licenses/cc-by-sa-4.0/
//**


import Foundation

//	## Learn Swift through examples
//
//	Delegate pattern, modeling real-world problem
//
//	Person needs a Key made. He finds the Keymaker that can make the Key it needs.
//	Person register as next customer (`delegate`) and then waits to be informed that Key is ready.



//	(0) `Key`, DATA MODEL
//	description of work that needs to be done

struct Key {
	var shape: String
}



//	(1) Person, END USER, object that needs some work done
//	(creation of the `key` of type `Key`)

final class Person {
	var name: String = "Me"

	var key: Key?
}



//	(2) SERVICE, Performs some function, here: makes a Key
//	(for anyone who needs a specific Key made)

final class Keymaker {
	//	REGISTRATION point for end users that need this specific work (Key making) done
	weak var delegate: Keymaking?

	//	Can only do work for just one end user, the last one that registered itself as `delegate`.
	//
	//	Note that `Keymaker` does not care what is the real, actual type of the object that needs the `Key` made.
	//	It only cares is the `delegate` compatible with the way `Keymaker` will deliver result of its work
}

//	(2a) Protocol, OUTPUT INTERFACE declared by the Service to describe how it will deliver the result

protocol Keymaking: class {
	func keymaker(_ keymaker: Keymaker, didProduceKey key: Key)
}

//	(2b) Keymaker completes his work internally and then notifies the Person (`delegate`)
//	Note: this part is usually marked as (file)private for the `Keymaker`
//	No object outside the `Keymaker` should know nor care how the `Key` is produced

fileprivate extension Keymaker {
	func didProduceKey(_ key: Key) {
		//	inform the delegate that Key is ready
		delegate?.keymaker(self, didProduceKey: key)
	}
}





//	(1b) End User waits to be informed that Service (Keymaker) has completed its work
//	and receives the result (Key)

extension Person: Keymaking {
	func keymaker(_ keymaker: Keymaker, didProduceKey key: Key) {
		self.key = key
	}
}


//	Note: In actual project, you would place this code in separate files:
//	Key.swift
//	Person.swift
//	Keymaker.swift
//	That way, `fileprivate` will work as intended




//	## Very mocked-up example

//	Me: I lost my house key...
var me = Person()
me.key
//	Me: S*it!


//	Me: need to find someone to make me a new Key
var keymaker = Keymaker()
//	Me: Hey, Mr Keymaker, please do make me a Key
keymaker.delegate = me


//	Keymaker: sure thing!
var key = Key(shape: "Basic")
//	Keymaker: phew, this was tough one. Let me call that guy...
keymaker.didProduceKey(key)

//	Me: Yay, can enter house again! Thanks Mr. Keymaker
me.key

