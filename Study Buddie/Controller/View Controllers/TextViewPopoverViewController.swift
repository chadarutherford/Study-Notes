//
//  TextViewPopoverViewController.swift
//  Study Notes
//
//  Created by Chad Rutherford on 8/4/20.
//

import SwiftUI
import UIKit

protocol TextViewPopoverDelegate: AnyObject {
	func textViewDidSave(text: String, into textField: UITextField)
}

class TextViewPopoverViewController: UIViewController {
	let containerView: UIView = {
		let containerView = UIView()
		containerView.translatesAutoresizingMaskIntoConstraints = false
		containerView.backgroundColor = .systemBackground
		containerView.layer.cornerRadius = 15
		containerView.clipsToBounds = true
		return containerView
	}()
	
	let textView: UITextView = {
		let textView = UITextView()
		textView.translatesAutoresizingMaskIntoConstraints = false
		textView.text = "Clue text here:"
		textView.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
		textView.clearsOnInsertion = true
		textView.isEditable = true
		textView.isUserInteractionEnabled = true
		textView.layer.borderColor = UIColor.black.cgColor
		textView.layer.borderWidth = 1
		textView.layer.cornerRadius = 10
		textView.layer.masksToBounds = true
		return textView
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
	
	var textField: UITextField?
	weak var delegate: TextViewPopoverDelegate?
	
	override func viewDidLoad() {
		super.viewDidLoad()
		view.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.5)
		view.addSubview(containerView)
		containerView.addSubview(textView)
		containerView.addSubview(saveButton)
		containerView.addSubview(cancelButton)
		NSLayoutConstraint.activate([
			containerView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 120),
			containerView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
			containerView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
			containerView.heightAnchor.constraint(equalToConstant: 312),
			
			textView.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 16),
			textView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16),
			textView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16),
			textView.bottomAnchor.constraint(equalTo: saveButton.topAnchor, constant: -8),
			
			saveButton.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -40),
			saveButton.leadingAnchor.constraint(equalTo: containerView.centerXAnchor, constant: 40),
			saveButton.heightAnchor.constraint(equalToConstant: 40),
			saveButton.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -8),
			
			cancelButton.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 40),
			cancelButton.trailingAnchor.constraint(equalTo: containerView.centerXAnchor, constant: -40),
			cancelButton.topAnchor.constraint(equalTo: textView.bottomAnchor, constant: 8),
			cancelButton.heightAnchor.constraint(equalToConstant: 40)
		])
	}
	
	@objc private func cancelButtonTapped() {
		dismiss(animated: true)
	}
	
	@objc private func saveButtonTapped() {
		guard let clue = textView.text, !clue.isEmpty, let textField = textField else { return }
		if clue != "Clue text here:" {
			delegate?.textViewDidSave(text: clue, into: textField)
		}
		dismiss(animated: true)
	}
}

struct TextViewPopoverPreview: PreviewProvider {
	static var previews: some View {
		ContainerView().edgesIgnoringSafeArea(.all)
	}
	
	struct ContainerView: UIViewControllerRepresentable {
		func updateUIViewController(_ uiViewController: TextViewPopoverPreview.ContainerView.UIViewControllerType, context: UIViewControllerRepresentableContext<TextViewPopoverPreview.ContainerView>) {
			
		}
		
		func makeUIViewController(context: UIViewControllerRepresentableContext<TextViewPopoverPreview.ContainerView>) -> UIViewController {
			return TextViewPopoverViewController()
		}
	}
}
