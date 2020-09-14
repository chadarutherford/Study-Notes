//
//  AppleInfoModel.swift
//  Study Buddie
//
//  Created by Chad Rutherford on 9/14/20.
//

import Foundation

struct AppleInfoModel {
	let userId: String
	let email: String
	let firstName: String
	let lastName: String
	var fullName: String {
		"\(firstName) \(lastName)"
	}
	
	init(userId: String, email: String, firstName: String, lastName: String) {
		self.userId = userId
		self.email = email
		self.firstName = firstName
		self.lastName = lastName
	}
}
