//
//  Keychain.swift
//  Study Buddie
//
//  Created by Chad Rutherford on 8/7/20.
//

import Foundation

struct KeychainItem {
	
	enum KeychainError: Error {
		case noPassword
		case unexpectedPasswordData
		case unexpectedItemData
		case unhandledError
	}
	
	// MARK: - Properties
	let service: String
	private(set) var account: String
	let accessGroup: String?
	
	// MARK: - Initialization
	init(service: String, account: String, accessGroup: String? = nil) {
		self.service = service
		self.account = account
		self.accessGroup = accessGroup
	}
	
	// MARK: - Keychain Access
	func readItem() throws -> String {
		var query = KeychainItem.keychainQuery(with: service, account: account, accessGroup: accessGroup)
		query[kSecMatchLimit as String] = kSecMatchLimitOne
		query[kSecReturnAttributes as String] = kCFBooleanTrue
		query[kSecReturnData as String] = kCFBooleanTrue
		
		var queryResult: AnyObject?
		let status = withUnsafeMutablePointer(to: &queryResult) { SecItemCopyMatching(query as CFDictionary, UnsafeMutablePointer($0)) }
		
		guard status != errSecItemNotFound else { throw KeychainError.noPassword }
		guard status == noErr else { throw KeychainError.unhandledError }
		
		guard let existingItem = queryResult as? [String: AnyObject],
			  let passwordData = existingItem[kSecValueData as String] as? Data,
			  let password = String(data: passwordData, encoding: .utf8)
		else { throw KeychainError.unexpectedPasswordData }
		
		return password
	}
	
	func saveItem(_ password: String) throws {
		let encodedPassword = password.data(using: .utf8)!
		do {
			try _ = readItem()
			var attributesToUpdate = [String: AnyObject]()
			attributesToUpdate[kSecValueData as String] = encodedPassword as AnyObject?
			
			let query = KeychainItem.keychainQuery(with: service, account: account, accessGroup: accessGroup)
			let status = SecItemUpdate(query as CFDictionary, attributesToUpdate as CFDictionary)
			guard status == noErr else { throw KeychainError.unhandledError }
		} catch KeychainError.noPassword {
			var newItem = KeychainItem.keychainQuery(with: service, account: account, accessGroup: accessGroup)
			newItem[kSecValueData as String] = encodedPassword as AnyObject?
			
			let status = SecItemAdd(newItem as CFDictionary, nil)
			guard status == noErr else { throw KeychainError.unhandledError }
		}
	}
	
	func deleteItem() throws {
		let query = KeychainItem.keychainQuery(with: service, account: account, accessGroup: accessGroup)
		let status = SecItemDelete(query as CFDictionary)
		guard status == noErr || status == errSecItemNotFound else { throw KeychainError.unhandledError }
	}
	
	private static func keychainQuery(with service: String, account: String? = nil, accessGroup: String? = nil) -> [String: AnyObject] {
		var query = [String: AnyObject]()
		query[kSecClass as String] = kSecClassGenericPassword
		query[kSecAttrService as String] = service as AnyObject?
		
		if let account = account {
			query[kSecAttrAccount as String] = account as AnyObject?
		}
		
		if let accessGroup = accessGroup {
			query[kSecAttrAccessGroup as String] = accessGroup as AnyObject?
		}
		
		return query
	}
	
	static var currentUserIdentifier: String {
		do {
			let storedIdentifier = try KeychainItem(service: bundleIdentifier, account: "userIdentifier").readItem()
			return storedIdentifier
		} catch {
			return ""
		}
	}
	
	static func deleteUserIdentifierFromKeychain() {
		do {
			try KeychainItem(service: bundleIdentifier, account: "userIdentifier").deleteItem()
		} catch {
			print("Unable to delete userIdentifier from keychain")
		}
	}
}

extension KeychainItem {
	static var bundleIdentifier: String {
		Bundle.main.bundleIdentifier ?? "io.github.chadarutherford.StudyBuddie"
	}
	
	static var userId: String? {
		get {
			try? KeychainItem(service: bundleIdentifier, account: "userId").readItem()
		}
		
		set {
			guard let value = newValue else {
				try? KeychainItem(service: bundleIdentifier, account: "userId").deleteItem()
				return
			}
			
			do {
				try KeychainItem(service: bundleIdentifier, account: "userId").saveItem(value)
			} catch {
				print("Unable to save userId to keychain")
			}
		}
	}
	
	static var firstName: String? {
		get {
			try? KeychainItem(service: bundleIdentifier, account: "firstName").readItem()
		}
		
		set {
			guard let value = newValue else {
				try? KeychainItem(service: bundleIdentifier, account: "firstName").deleteItem()
				return
			}
			
			do {
				try KeychainItem(service: bundleIdentifier, account: "firstName").saveItem(value)
			} catch {
				print("Unable to save firstName to keychain")
			}
		}
	}
	
	static var lastName: String? {
		get {
			try? KeychainItem(service: bundleIdentifier, account: "lastName").readItem()
		}
		
		set {
			guard let value = newValue else {
				try? KeychainItem(service: bundleIdentifier, account: "lastName").deleteItem()
				return
			}
			
			do {
				try KeychainItem(service: bundleIdentifier, account: "lastName").saveItem(value)
			} catch {
				print("Unable to save lastName to keychain")
			}
		}
	}
	
	static var email: String? {
		get {
			try? KeychainItem(service: bundleIdentifier, account: "email").readItem()
		}
		
		set {
			guard let value = newValue else {
				try? KeychainItem(service: bundleIdentifier, account: "email").deleteItem()
				return
			}
			
			do {
				try KeychainItem(service: bundleIdentifier, account: "email").saveItem(value)
			} catch {
				print("Unable to save email to keychain")
			}
		}
	}
}
