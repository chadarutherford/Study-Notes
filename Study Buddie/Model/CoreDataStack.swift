//
//  CoreDataStack.swift
//  Study Notes
//
//  Created by Chad Rutherford on 7/14/20.
//

import CoreData
import Foundation

class CoreDataStack {
	static let shared = CoreDataStack()
	
	private init() {}
	
	lazy var container: NSPersistentContainer = {
		let container = NSPersistentContainer(name: "StudyBuddie")
		container.loadPersistentStores { _, error in
			if let error = error {
				fatalError("Failed to load persistent stores: \(error.localizedDescription)")
			}
			container.viewContext.automaticallyMergesChangesFromParent = true
		}
		return container
	}()
	
	var mainContext: NSManagedObjectContext {
		container.viewContext
	}
	
	var backgroundContext: NSManagedObjectContext {
		container.newBackgroundContext()
	}
	
	func save(context: NSManagedObjectContext = CoreDataStack.shared.mainContext) throws {
		var error: Error?
		
		context.performAndWait {
			do {
				try context.save()
			} catch let saveError as NSError {
				error = saveError
			}
		}
		if let error = error { throw error }
	}
}
