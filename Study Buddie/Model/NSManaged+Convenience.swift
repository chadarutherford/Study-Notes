//
//  Note+Convenience.swift
//  Study Notes
//
//  Created by Chad Rutherford on 7/14/20.
//

import CoreData
import Foundation

extension Category {
	@discardableResult convenience init?(title: String, notes: NSSet, context: NSManagedObjectContext = CoreDataCloudKitStack.shared.mainContext) {
		self.init(context: context)
		self.title = title
		self.notes = notes
	}
}

extension Note {
	@discardableResult convenience init?(answer: String,
										 clues: NSSet,
										 context: NSManagedObjectContext = CoreDataCloudKitStack.shared.mainContext) {
		self.init(context: context)
		self.answer = answer
		self.clues = clues
	}
}

extension Clue {
	@discardableResult convenience init?(text: String,
										 context: NSManagedObjectContext = CoreDataCloudKitStack.shared.mainContext) {
		self.init(context: context)
		self.text = text
	}
}
