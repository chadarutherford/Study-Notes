//
//  EmptyView.swift
//  Study Notes
//
//  Created by Chad Rutherford on 8/3/20.
//

import UIKit

class EmptyView: UIView {
	
	let emptyLabel: UILabel = {
		let label = UILabel()
		label.translatesAutoresizingMaskIntoConstraints = false
		label.font = UIFont.boldSystemFont(ofSize: 25)
		label.textColor = .black
		label.textAlignment = .center
		label.numberOfLines = 0
		label.text = "There are no cards in this deck,\nclick the add button to add cards"
		return label
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
		addSubview(emptyLabel)
		
		NSLayoutConstraint.activate([
			emptyLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor),
			emptyLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor)
		])
	}
}
