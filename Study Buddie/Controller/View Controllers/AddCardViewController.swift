//
//  AddCardViewController.swift
//  Study Notes
//
//  Created by Chad Rutherford on 7/15/20.
//

import UIKit

class AddCardViewController: UIViewController {
	
	let answerLabel: UILabel = {
		let label = UILabel()
		label.translatesAutoresizingMaskIntoConstraints = false
		label.text = "Answer:"
		label.textColor = .label
		return label
	}()
	
	let cluesLabel: UILabel = {
		let label = UILabel()
		label.translatesAutoresizingMaskIntoConstraints = false
		label.text = "Clues:"
		label.textColor = .label
		return label
	}()
	
	let answerTextField: UITextField = {
		let textField = UITextField()
		textField.translatesAutoresizingMaskIntoConstraints = false
		textField.placeholder = "Answer:"
		textField.borderStyle = .roundedRect
		textField.contentVerticalAlignment = .center
		return textField
	}()
	
	let clue1TextField: UITextField = {
		let textField = UITextField()
		textField.translatesAutoresizingMaskIntoConstraints = false
		textField.placeholder = "Clue 1:"
		textField.borderStyle = .roundedRect
		textField.contentVerticalAlignment = .center
		return textField
	}()
	
	let clue2TextField: UITextField = {
		let textField = UITextField()
		textField.translatesAutoresizingMaskIntoConstraints = false
		textField.placeholder = "Clue 2:"
		textField.borderStyle = .roundedRect
		textField.contentVerticalAlignment = .center
		return textField
	}()
	
	let clue3TextField: UITextField = {
		let textField = UITextField()
		textField.translatesAutoresizingMaskIntoConstraints = false
		textField.placeholder = "Clue 3:"
		textField.borderStyle = .roundedRect
		textField.contentVerticalAlignment = .center
		return textField
	}()
	
	let clue4TextField: UITextField = {
		let textField = UITextField()
		textField.translatesAutoresizingMaskIntoConstraints = false
		textField.placeholder = "Clue 4:"
		textField.borderStyle = .roundedRect
		textField.contentVerticalAlignment = .center
		return textField
	}()
	
	let clue5TextField: UITextField = {
		let textField = UITextField()
		textField.translatesAutoresizingMaskIntoConstraints = false
		textField.placeholder = "Clue 5:"
		textField.borderStyle = .roundedRect
		textField.contentVerticalAlignment = .center
		return textField
	}()
	
	let saveButton: UIButton = {
		let button = UIButton()
		let attributes: [NSAttributedString.Key : Any] = [
			NSAttributedString.Key.foregroundColor : UIColor.label,
			NSAttributedString.Key.font : UIFont.systemFont(ofSize: 20, weight: .bold)
		]
		button.translatesAutoresizingMaskIntoConstraints = false
		button.setAttributedTitle(NSAttributedString(string: "Save Card", attributes: attributes), for: .normal)
		button.addTarget(self, action: #selector(saveButtonTapped), for: .touchUpInside)
		button.layer.cornerRadius = 10
		button.clipsToBounds = true
		button.backgroundColor = .systemBlue
		return button
	}()
	
	var category: Category?
	var note: Note?
	var clues = [Clue]()
	
	override func viewDidLoad() {
		super.viewDidLoad()
		configureUI()
	}
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		navigationController?.isNavigationBarHidden = false
	}
	
	private func configureUI() {
		clue1TextField.delegate = self
		clue2TextField.delegate = self
		clue3TextField.delegate = self
		clue4TextField.delegate = self
		clue5TextField.delegate = self
		
		title = "Add Card"
		let gradient = CAGradientLayer()
		gradient.frame = view.bounds
		gradient.colors = [UIColor.systemTeal.cgColor, UIColor.systemBlue.cgColor]
		view.layer.insertSublayer(gradient, at: 0)
		view.addSubview(answerLabel)
		view.addSubview(answerTextField)
		view.addSubview(cluesLabel)
		view.addSubview(clue1TextField)
		view.addSubview(clue2TextField)
		view.addSubview(clue3TextField)
		view.addSubview(clue4TextField)
		view.addSubview(clue5TextField)
		view.addSubview(saveButton)
		
		NSLayoutConstraint.activate([
			answerLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
			answerLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
			answerLabel.widthAnchor.constraint(equalToConstant: 65),
			
			answerTextField.leadingAnchor.constraint(equalTo: answerLabel.trailingAnchor, constant: 20),
			answerTextField.centerYAnchor.constraint(equalTo: answerLabel.centerYAnchor),
			answerTextField.heightAnchor.constraint(equalToConstant: 40),
			answerTextField.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
			
			cluesLabel.topAnchor.constraint(equalTo: answerLabel.bottomAnchor, constant: 40),
			cluesLabel.leadingAnchor.constraint(equalTo: answerLabel.leadingAnchor),
			cluesLabel.widthAnchor.constraint(equalToConstant: 65),
			
			clue1TextField.centerYAnchor.constraint(equalTo: cluesLabel.centerYAnchor),
			clue1TextField.leadingAnchor.constraint(equalTo: answerTextField.leadingAnchor),
			clue1TextField.heightAnchor.constraint(equalToConstant: 40),
			clue1TextField.trailingAnchor.constraint(equalTo: answerTextField.trailingAnchor),
			
			clue2TextField.topAnchor.constraint(equalTo: clue1TextField.bottomAnchor, constant: 20),
			clue2TextField.leadingAnchor.constraint(equalTo: answerTextField.leadingAnchor),
			clue2TextField.heightAnchor.constraint(equalToConstant: 40),
			clue2TextField.trailingAnchor.constraint(equalTo: answerTextField.trailingAnchor),
			
			clue3TextField.topAnchor.constraint(equalTo: clue2TextField.bottomAnchor, constant: 20),
			clue3TextField.leadingAnchor.constraint(equalTo: answerTextField.leadingAnchor),
			clue3TextField.heightAnchor.constraint(equalToConstant: 40),
			clue3TextField.trailingAnchor.constraint(equalTo: answerTextField.trailingAnchor),
			
			clue4TextField.topAnchor.constraint(equalTo: clue3TextField.bottomAnchor, constant: 20),
			clue4TextField.leadingAnchor.constraint(equalTo: answerTextField.leadingAnchor),
			clue4TextField.heightAnchor.constraint(equalToConstant: 40),
			clue4TextField.trailingAnchor.constraint(equalTo: answerTextField.trailingAnchor),
			
			clue5TextField.topAnchor.constraint(equalTo: clue4TextField.bottomAnchor, constant: 20),
			clue5TextField.leadingAnchor.constraint(equalTo: answerTextField.leadingAnchor),
			clue5TextField.heightAnchor.constraint(equalToConstant: 40),
			clue5TextField.trailingAnchor.constraint(equalTo: answerTextField.trailingAnchor),
			
			saveButton.topAnchor.constraint(equalTo: clue5TextField.bottomAnchor, constant: 40),
			saveButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
			saveButton.widthAnchor.constraint(equalToConstant: 200),
			saveButton.heightAnchor.constraint(equalTo: saveButton.widthAnchor, multiplier: 0.2)
		])
	}
	
	@objc private func saveButtonTapped() {
		guard let answer = answerTextField.text, !answer.isEmpty else { return }
		if let clue1 = clue1TextField.text,
		   !clue1.isEmpty {
			clues.append(Clue(text: clue1)!)
		}
		if let clue2 = clue2TextField.text,
		   !clue2.isEmpty {
			clues.append(Clue(text: clue2)!)
		}
		if let clue3 = clue3TextField.text,
		   !clue3.isEmpty {
			clues.append(Clue(text: clue3)!)
		}
		if let clue4 = clue4TextField.text,
		   !clue4.isEmpty {
			clues.append(Clue(text: clue4)!)
		}
		if let clue5 = clue5TextField.text,
		   !clue5.isEmpty {
			clues.append(Clue(text: clue5)!)
		}
		guard let category = category else { return }
		let mutableNotes = category.notes?.mutableCopy() as! NSMutableSet
		let note = Note(answer: answer, clues: NSSet(array: clues))!
		mutableNotes.add(note)
		category.notes = (mutableNotes.copy() as! NSSet)
		do {
			try CoreDataCloudKitStack.shared.save()
			navigationController?.popViewController(animated: true)
		} catch {
			let ac = UIAlertController(title: "Error", message: "There was an error saving your note card", preferredStyle: .alert)
			ac.addAction(UIAlertAction(title: "OK", style: .default))
			present(ac, animated: true)
		}
	}
}

extension AddCardViewController: UITextFieldDelegate {
	func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
		textField.resignFirstResponder()
		let textPopoverVC = TextViewPopoverViewController(nibName: nil, bundle: nil)
		textPopoverVC.textField = textField
		textPopoverVC.delegate = self
		textPopoverVC.modalPresentationStyle = .overCurrentContext
		textPopoverVC.modalTransitionStyle = .crossDissolve
		present(textPopoverVC, animated: true)
		return true
	}
}

extension AddCardViewController: TextViewPopoverDelegate {
	func textViewDidSave(text: String, into textField: UITextField) {
		textField.text = text
	}
}
