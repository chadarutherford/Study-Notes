//
//  AddCategoryViewController.swift
//  Study Notes
//
//  Created by Chad Rutherford on 8/3/20.
//

import UIKit

class AddCategoryViewController: UIViewController {
	
	let containerView: UIView = {
		let containerView = UIView()
		containerView.translatesAutoresizingMaskIntoConstraints = false
		containerView.backgroundColor = .systemBackground
		containerView.layer.cornerRadius = 15
		containerView.clipsToBounds = true
		return containerView
	}()
	
	let label: UILabel = {
		let label = UILabel()
		label.translatesAutoresizingMaskIntoConstraints = false
		label.text = "Category Name:"
		label.font = UIFont.systemFont(ofSize: 17, weight: .semibold)
		label.textColor = .label
		return label
	}()
	
	let categoryTextField: UITextField = {
		let textField = UITextField()
		textField.translatesAutoresizingMaskIntoConstraints = false
		textField.borderStyle = .roundedRect
		textField.placeholder = "Category Name:"
		return textField
	}()
	
	let cancelButton: UIButton = {
		let button = UIButton()
		button.translatesAutoresizingMaskIntoConstraints = false
		let attributes = [
			NSAttributedString.Key.foregroundColor : UIColor.label,
			NSAttributedString.Key.font : UIFont.systemFont(ofSize: 18, weight: .semibold)
		]
		button.layer.borderColor = UIColor.label.cgColor
		button.layer.borderWidth = 2
		button.layer.cornerRadius = 10
		button.layer.masksToBounds = true
		button.setAttributedTitle(NSAttributedString(string: "Cancel", attributes: attributes), for: .normal)
		button.addTarget(self, action: #selector(cancelButtonTapped), for: .touchUpInside)
		return button
	}()
	
	let saveButton: UIButton = {
		let button = UIButton()
		button.translatesAutoresizingMaskIntoConstraints = false
		let attributes = [
			NSAttributedString.Key.foregroundColor : UIColor.label,
			NSAttributedString.Key.font : UIFont.systemFont(ofSize: 18, weight: .semibold)
		]
		button.layer.borderColor = UIColor.label.cgColor
		button.layer.borderWidth = 2
		button.layer.cornerRadius = 10
		button.layer.masksToBounds = true
		button.setAttributedTitle(NSAttributedString(string: "Save", attributes: attributes), for: .normal)
		button.addTarget(self, action: #selector(saveButtonTapped), for: .touchUpInside)
		return button
	}()
	
	override func viewDidLoad() {
		super.viewDidLoad()
		configureUI()
	}
	
	private func configureUI() {
		view.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.5)
		view.addSubview(containerView)
		containerView.addSubview(label)
		containerView.addSubview(categoryTextField)
		containerView.addSubview(saveButton)
		containerView.addSubview(cancelButton)
		NSLayoutConstraint.activate([
			containerView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 120),
			containerView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
			containerView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
			containerView.bottomAnchor.constraint(equalTo: saveButton.bottomAnchor, constant: 8),
			
			label.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 20),
			label.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 8),
			
			categoryTextField.topAnchor.constraint(equalTo: label.bottomAnchor, constant: 8),
			categoryTextField.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 8),
			categoryTextField.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -8),
			categoryTextField.heightAnchor.constraint(equalToConstant: 40),
			
			saveButton.topAnchor.constraint(equalTo: categoryTextField.bottomAnchor, constant: 8),
			saveButton.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -40),
			saveButton.heightAnchor.constraint(equalToConstant: 40),
			saveButton.leadingAnchor.constraint(equalTo: containerView.centerXAnchor, constant: 40),
			
			cancelButton.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 40),
			cancelButton.trailingAnchor.constraint(equalTo: containerView.centerXAnchor, constant: -40),
			cancelButton.topAnchor.constraint(equalTo: categoryTextField.bottomAnchor, constant: 8),
			cancelButton.heightAnchor.constraint(equalToConstant: 40)
		])
	}
	
	@objc private func cancelButtonTapped() {
		dismiss(animated: true)
	}
	
	@objc private func saveButtonTapped() {
		guard let title = categoryTextField.text, !title.isEmpty else { return }
		Category(title: title, notes: [])
		try! CoreDataStack.shared.save()
	}
}
