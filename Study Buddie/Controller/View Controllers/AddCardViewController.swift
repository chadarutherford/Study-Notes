//
//  AddCardViewController.swift
//  Study Notes
//
//  Created by Chad Rutherford on 7/15/20.
//

import UIKit

class AddCardViewController: UIViewController {
	
	let frontLabel: UILabel = {
		let label = UILabel()
		label.translatesAutoresizingMaskIntoConstraints = false
		label.text = "Front of Card:"
		label.textColor = .label
		return label
	}()
	
	let backLabel: UILabel = {
		let label = UILabel()
		label.translatesAutoresizingMaskIntoConstraints = false
		label.text = "Back of Card:"
		label.textColor = .label
		return label
	}()
	
	let frontTextView: UITextView = {
		let textView = UITextView()
		textView.autocapitalizationType = .words
		textView.translatesAutoresizingMaskIntoConstraints = false
		textView.layer.cornerRadius = 15
		textView.layer.cornerCurve = .continuous
		textView.isEditable = true
		return textView
	}()
	
	let backTextView: UITextView = {
		let textView = UITextView()
		textView.autocapitalizationType = .words
		textView.translatesAutoresizingMaskIntoConstraints = false
		textView.layer.cornerRadius = 15
		textView.layer.cornerCurve = .continuous
		textView.isEditable = true
		return textView
	}()
	
	let scroll: UIScrollView = {
		let scroll = UIScrollView()
		scroll.translatesAutoresizingMaskIntoConstraints = false
		return scroll
	}()
	
	var category: Category?
	var note: Note?
	var clues = [Clue]()
	
	override func viewDidLoad() {
		super.viewDidLoad()
		configureUI()
		setupNavController()
	}
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		navigationController?.isNavigationBarHidden = false
	}
	
	override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
		view.endEditing(true)
	}
	
	private func setupNavController() {
		navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(saveButtonTapped))
	}
	
	private func configureUI() {
		let bar = UIToolbar()
		let done = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(endEditing))
		bar.items = [done]
		bar.sizeToFit()
		frontTextView.inputAccessoryView = bar
		backTextView.inputAccessoryView = bar
		title = "Add Card"
		frontTextView.delegate = self
		backTextView.delegate = self
		view = GradientView()
		view.addSubview(scroll)
		scroll.contentSize = CGSize(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height + 300)
		scroll.addSubview(frontLabel)
		scroll.addSubview(frontTextView)
		scroll.addSubview(backLabel)
		scroll.addSubview(backTextView)
		NotificationCenter.default.addObserver(self, selector: #selector(adjustForKeyboard(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
		NotificationCenter.default.addObserver(self, selector: #selector(adjustForKeyboard(_:)), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
		
		NSLayoutConstraint.activate([
			scroll.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
			scroll.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
			scroll.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
			scroll.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
			
			frontLabel.topAnchor.constraint(equalTo: scroll.topAnchor, constant: 20),
			frontLabel.leadingAnchor.constraint(equalTo: scroll.leadingAnchor, constant: 16),
			frontLabel.trailingAnchor.constraint(greaterThanOrEqualTo: scroll.trailingAnchor, constant: -16),
			
			frontTextView.leadingAnchor.constraint(equalTo: scroll.leadingAnchor, constant: 16),
			frontTextView.topAnchor.constraint(equalTo: frontLabel.bottomAnchor, constant: 8),
			frontTextView.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -140),
			frontTextView.heightAnchor.constraint(equalToConstant: 120),
			
			backLabel.topAnchor.constraint(equalTo: frontTextView.bottomAnchor, constant: 28),
			backLabel.leadingAnchor.constraint(equalTo: frontLabel.leadingAnchor),
			backLabel.trailingAnchor.constraint(greaterThanOrEqualTo: scroll.trailingAnchor, constant: -16),
			
			backTextView.leadingAnchor.constraint(equalTo: scroll.leadingAnchor, constant: 16),
			backTextView.topAnchor.constraint(equalTo: backLabel.bottomAnchor, constant: 8),
			backTextView.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -140),
			backTextView.heightAnchor.constraint(equalToConstant: 120),
			backTextView.bottomAnchor.constraint(equalTo: scroll.bottomAnchor, constant: -16),
		])
	}
	
	@objc private func saveButtonTapped() {
		guard var frontText = frontTextView.text, !frontText.isEmpty else { return }
		guard let backText = backTextView.text, !backText.isEmpty else { return }
		guard let category = category else { return }
		let backTextItems = backText.split(separator: "\n")
		frontText = frontText.trimmingCharacters(in: .whitespacesAndNewlines)
		self.clues = backTextItems.compactMap { Clue(text: String($0)) }
		let mutableNotes = category.notes?.mutableCopy() as! NSMutableSet
		let note = Note(answer: frontText, clues: NSSet(array: clues))!
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
	
	@objc private func endEditing() {
		view.endEditing(true)
	}
	
	@objc private func adjustForKeyboard(_ notification: Notification) {
		guard let keyboardValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return }
		let keyboardScreenEndFrame = keyboardValue.cgRectValue
		let keyboardViewEndFrame = view.convert(keyboardScreenEndFrame, from: view.window)
		if backTextView.isFirstResponder {
			if notification.name == UIResponder.keyboardWillHideNotification {
				scroll.contentInset = .zero
			} else {
				scroll.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardViewEndFrame.height - view.safeAreaInsets.bottom, right: 0)
				scroll.scrollToBottom(animated: true)
			}
		}
	}
}

extension AddCardViewController: UITextViewDelegate {
	func textViewDidBeginEditing(_ textView: UITextView) {
		if textView != frontTextView {
			textView.text = "\n \u{2022} "
		} else {
			textView.text = "\n"
		}
	}
	func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
		if textView != frontTextView {
			if text == "\n" {
				if range.location == textView.text.count {
					let updatedText = textView.text!.appending("\n \u{2022} ")
					textView.text = updatedText
				} else {
					let beginning: UITextPosition = textView.beginningOfDocument
					let start: UITextPosition = textView.position(from: beginning, offset: range.location)!
					let end: UITextPosition = textView.position(from: start, offset: range.length)!
					let textRange: UITextRange = textView.textRange(from: start, to: end)!
					textView.replace(textRange, withText: "\n \u{2022} ")
					let cursor: NSRange = NSRange(location: range.location + "\n \u{2022} ".count, length: 0)
					textView.selectedRange = cursor
				}
				return false
			}
			return true
		}
		return true
	}
}
