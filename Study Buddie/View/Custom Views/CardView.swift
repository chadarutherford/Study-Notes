//
// CardView.swift
// Study Notes
//
// Created by Chad Rutherford on 8/3/20.
// 
//

import UIKit

class CardView: UIView {
	
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
		stack.alignment = .top
		stack.distribution = .fillProportionally
		stack.spacing = 20
		return stack
	}()
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		configureUI()
	}
	
	@available(*, unavailable)
	required init?(coder: NSCoder) {
		super.init(coder: coder)
		configureUI()
	}
	
	private func configureUI() {
		addSubview(answerLabel)
		addSubview(cluesStackView)
		
		NSLayoutConstraint.activate([
			answerLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor),
			answerLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor),
			
			cluesStackView.topAnchor.constraint(equalTo: self.topAnchor, constant: 20),
			cluesStackView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 8),
			cluesStackView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -8),
		])
	}
}
