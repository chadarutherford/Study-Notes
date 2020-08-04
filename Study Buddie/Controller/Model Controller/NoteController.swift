//
//  NoteController.swift
//  Study Notes
//
//  Created by Chad Rutherford on 7/14/20.
//

import Foundation

class NoteController {
	init() {
		Category(title: "Basic Cell Structure", notes: [
					Note(answer: "Nucleic Acids", clues: NSOrderedSet(array: [
						Clue(text: "A complex organic substance present in living cells"),
						Clue(text: "Includes: RNA & DNA"),
						Clue(text: "Carry out several cellular processes. Especially involved in regulation and expression of genes.")
					] as! [Clue]))!,
					Note(answer: "DNA", clues: NSOrderedSet(array: [
						Clue(text: "A polymer (substance that has a molecular structure consisting of a large number of similar units bonded together. E.g. Protein, cellulose, Nucleic Acids"),
						Clue(text: "Made from a long string of repeating units called nucleotides"),
						Clue(text: "Stores biological information"),
						Clue(text: "Is the hereditary material in all living organisms")
					] as! [Clue] ))! ])
		try! CoreDataStack.shared.save()
	}
}
