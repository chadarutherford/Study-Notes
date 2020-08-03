//
// CategoryCell.swift
// Study Notes
//
// Created by Chad Rutherford on 8/3/20.
// 
//

import UIKit

class CategoryCell: UITableViewCell {
	static let reuseID = String(describing: self)
	
	let label: UILabel = {
		let label = UILabel()
		label.translatesAutoresizingMaskIntoConstraints = false
		label.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
		label.textColor = .black
		return label
	}()
	
	var gradient = CAGradientLayer()
	var category: Category? {
		didSet {
			updateViews()
		}
	}
	
	override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
		super.init(style: style, reuseIdentifier: reuseIdentifier)
		configureUI()
	}
	
	@available(*, unavailable)
	required init?(coder: NSCoder) {
		super.init(coder: coder)
		configureUI()
	}
	
	private func configureUI() {
		contentView.addSubview(label)
		NSLayoutConstraint.activate([
			label.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 24),
			label.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8)
		])
		gradient.colors = [
			UIColor.systemTeal.cgColor,
			UIColor.systemBlue.cgColor
		]
		gradient.locations = [0.0, 1.0]
		contentView.layer.insertSublayer(gradient, at: 0)
		contentView.layer.cornerRadius = 10
		contentView.clipsToBounds = true
	}
	
	override func layoutSubviews() {
		super.layoutSubviews()
		gradient.frame = contentView.frame
	}
	
	private func updateViews() {
		guard let category = category else { return }
		label.text = category.title
	}
}
