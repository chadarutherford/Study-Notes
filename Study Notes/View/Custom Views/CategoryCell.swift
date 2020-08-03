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
	
	let containerView: UIView = {
		let containerView = UIView()
		containerView.translatesAutoresizingMaskIntoConstraints = false
		return containerView
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
		contentView.addSubview(containerView)
		containerView.addSubview(label)
		NSLayoutConstraint.activate([
			containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
			containerView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
			containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
			containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
			
			label.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 24),
			label.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 8)
		])
		gradient.colors = [
			UIColor.systemTeal.cgColor,
			UIColor.systemBlue.cgColor
		]
		gradient.locations = [0.0, 1.0]
		containerView.layer.insertSublayer(gradient, at: 0)
	}
	
	override func layoutSubviews() {
		super.layoutSubviews()
		
		gradient.frame = containerView.frame
		containerView.layer.cornerRadius = 10
		containerView.clipsToBounds = true
		gradient.masksToBounds = true
	}
	
	private func updateViews() {
		guard let category = category else { return }
		label.text = category.title
	}
}
