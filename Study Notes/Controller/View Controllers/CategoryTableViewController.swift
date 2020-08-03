//
// CategoryTableViewController.swift
// Study Notes
//
// Created by Chad Rutherford on 8/3/20.
// 
//

import CoreData
import UIKit

class CategoryTableViewController: UITableViewController {
	lazy var fetchedResultsController: NSFetchedResultsController<Category> = {
		let fetchRequest: NSFetchRequest<Category> = Category.fetchRequest()
		fetchRequest.sortDescriptors = [
			NSSortDescriptor(key: "title", ascending: true)
		]
		let context = CoreDataStack.shared.mainContext
		let fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
		fetchedResultsController.delegate = self
		try! fetchedResultsController.performFetch()
		return fetchedResultsController
	}()
	
	// MARK: - Seed Data - For Testing
//	let noteController = NoteController()
	
	override func viewDidLoad() {
		setupTableView()
	}
	
	private func setupTableView() {
		title = "Categories"
		tableView.backgroundColor = .clear
		navigationController?.navigationBar.prefersLargeTitles = true
		tableView.register(CategoryCell.self, forCellReuseIdentifier: CategoryCell.reuseID)
		tableView.rowHeight = 70
		tableView.separatorStyle = .none
	}
	
	override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		fetchedResultsController.fetchedObjects?.count ?? 0
	}
	
	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		guard let cell = tableView.dequeueReusableCell(withIdentifier: CategoryCell.reuseID, for: indexPath) as? CategoryCell else { fatalError("Invalid Cell Dequeued") }
		let category = fetchedResultsController.object(at: indexPath)
		cell.category = category
		return cell
	}
	
	override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		let category = fetchedResultsController.object(at: indexPath)
		let studyModeVC = StudyModeViewController(nibName: nil, bundle: nil)
		studyModeVC.category = category
		navigationController?.pushViewController(studyModeVC, animated: true)
	}
}

extension CategoryTableViewController: NSFetchedResultsControllerDelegate {
	func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
		tableView.beginUpdates()
	}
	
	func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
		tableView.endUpdates()
	}
	
	func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange sectionInfo: NSFetchedResultsSectionInfo, atSectionIndex sectionIndex: Int, for type: NSFetchedResultsChangeType) {
		switch type {
		case .insert:
			tableView.insertSections(IndexSet(integer: sectionIndex), with: .automatic)
		case .delete:
			tableView.deleteSections(IndexSet(integer: sectionIndex), with: .automatic)
		default:
			break
		}
	}
	
	func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
		switch type {
		case .insert:
			guard let newIndexPath = newIndexPath else { return }
			tableView.insertRows(at: [newIndexPath], with: .automatic)
		case .delete:
			guard let indexPath = indexPath else { return }
			tableView.deleteRows(at: [indexPath], with: .automatic)
		case .update:
			guard let indexPath = indexPath else { return }
			tableView.reloadRows(at: [indexPath], with: .automatic)
		case .move:
			guard let fromIndexPath = indexPath, let toIndexPath = newIndexPath else { return }
			tableView.deleteRows(at: [fromIndexPath], with: .automatic)
			tableView.insertRows(at: [toIndexPath], with: .automatic)
		@unknown default:
			break
		}
	}
}
