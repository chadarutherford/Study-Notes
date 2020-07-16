//
//  LoginViewController.swift
//  Study Notes
//
//  Created by Chad Rutherford on 7/14/20.
//

import CoreData
import UIKit

class LoginViewController: UIViewController {
	
	let cardView: UIView = {
		let view = UIView()
		view.translatesAutoresizingMaskIntoConstraints = false
		view.backgroundColor = .systemBackground
		view.layer.borderWidth = 2
		view.layer.borderColor = UIColor.label.cgColor
		view.layer.cornerRadius = 10
		view.layer.masksToBounds = true
		return view
	}()
	
	let answerLabel: UILabel = {
		let label = UILabel()
		label.translatesAutoresizingMaskIntoConstraints = false
		label.textColor = .label
		label.font = UIFont.boldSystemFont(ofSize: 25)
		return label
	}()
	
	let cluesStackView: UIStackView = {
		let stack = UIStackView()
		stack.translatesAutoresizingMaskIntoConstraints = false
		stack.axis = .vertical
		stack.alignment = .center
		stack.distribution = .equalSpacing
		return stack
	}()
	
	let nextButton: UIButton = {
		let button = UIButton()
		button.translatesAutoresizingMaskIntoConstraints = false
		let attributes: [NSAttributedString.Key : Any] = [
			NSAttributedString.Key.font : UIFont.systemFont(ofSize: 17, weight: .semibold),
			NSAttributedString.Key.foregroundColor : UIColor.white
		]
		button.setAttributedTitle(NSAttributedString(string: "Next", attributes: attributes), for: .normal)
		button.addTarget(self, action: #selector(nextButtonTapped), for: .touchUpInside)
		return button
	}()
	
	let newButton: UIButton = {
		let button = UIButton()
		button.translatesAutoresizingMaskIntoConstraints = false
		button.setImage(UIImage(systemName: "plus")?.applyingSymbolConfiguration(UIImage.SymbolConfiguration(pointSize: 17, weight: .semibold)), for: .normal)
		button.tintColor = .white
		button.addTarget(self, action: #selector(addCardTapped), for: .touchUpInside)
		return button
	}()
	
	var showing = true
	var index = 0
	var results: [Note]? {
		didSet {
			updateViews()
		}
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		configureUI()
		updateViews()
		performFetch()
		setupTapGestures()
	}
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		navigationController?.isNavigationBarHidden = true
		index = 0
		performFetch()
		updateViews()
	}
	
	private func configureUI() {
		let gradient = CAGradientLayer()
		gradient.frame = view.bounds
		gradient.colors = [
			UIColor.systemTeal.cgColor,
			UIColor.systemBlue.cgColor
		]
		view.layer.insertSublayer(gradient, at: 0)
		view.addSubview(nextButton)
		view.addSubview(cardView)
		view.addSubview(newButton)
		cardView.addSubview(answerLabel)
		cardView.addSubview(cluesStackView)
		NSLayoutConstraint.activate([
			newButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 8),
			newButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -30),
			cardView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 100),
			cardView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -100),
			cardView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
			cardView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
			
			answerLabel.centerXAnchor.constraint(equalTo: cardView.centerXAnchor),
			answerLabel.centerYAnchor.constraint(equalTo: cardView.centerYAnchor),
			
			cluesStackView.topAnchor.constraint(equalTo: cardView.topAnchor, constant: 20),
			cluesStackView.bottomAnchor.constraint(equalTo: cardView.bottomAnchor, constant: -20),
			cluesStackView.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: 8),
			cluesStackView.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -8),
			nextButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -8),
			nextButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
		])
	}
	
	private func performFetch() {
		let fetchRequest: NSFetchRequest<Note> = Note.fetchRequest()
		let results = try! CoreDataStack.shared.mainContext.fetch(fetchRequest)
		self.results = results
	}
	
	private func updateViews() {
		guard let results = results,
			  index <= results.count - 1 else { return }
		answerLabel.text = results[index].answer
		cluesStackView.isHidden = true
		let clues = results[index].clues?.array as! [Clue]
		for view in cluesStackView.arrangedSubviews {
			view.removeFromSuperview()
		}
		for clue in clues {
			let label = UILabel()
			label.font = UIFont.systemFont(ofSize: 20, weight: .semibold)
			label.textColor = .label
			label.text = clue.text
			label.numberOfLines = 0
			cluesStackView.addArrangedSubview(label)
		}
		cardView.setNeedsLayout()
	}
	
	private func setupTapGestures() {
		let tap = UITapGestureRecognizer(target: self, action: #selector(viewTapped(_:)))
		tap.numberOfTapsRequired = 1
		cardView.addGestureRecognizer(tap)
		cardView.isUserInteractionEnabled = true
	}
	
	@objc private func viewTapped(_ recognizer: UITapGestureRecognizer) {
		if showing {
			UIView.transition(with: self.cardView, duration: 1, options: .transitionFlipFromRight, animations: {
				self.answerLabel.isHidden = true
				self.cluesStackView.isHidden = false
				self.showing = false
			}, completion: nil)
		} else {
			UIView.transition(with: self.cardView, duration: 1, options: .transitionFlipFromRight, animations: {
				self.answerLabel.isHidden = false
				self.cluesStackView.isHidden = true
				self.showing = true
			}, completion: nil)
		}
	}
	
	@objc private func nextButtonTapped() {
		index += 1
		updateViews()
	}
	
	@objc private func addCardTapped() {
		let addCardVC = AddCardViewController(nibName: nil, bundle: nil)
		self.navigationController?.pushViewController(addCardVC, animated: true)
	}
}
