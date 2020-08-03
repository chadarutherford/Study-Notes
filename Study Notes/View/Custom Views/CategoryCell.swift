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

    let wrapper: UIView = {
        let view = GradientView()
        view.setupGradient(startColor: .systemTeal, endColor: .systemBlue, startPoint: .init(x: 0, y: 0), endPoint: .init(x: 0, y: 1))
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
	let label: UILabel = {
		let label = UILabel()
		label.translatesAutoresizingMaskIntoConstraints = false
		label.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
		label.textColor = .black
		return label
	}()
	
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
		contentView.addSubview(wrapper)
        wrapper.addSubview(label)
		NSLayoutConstraint.activate([
            wrapper.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 0),
            wrapper.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: 0),
            wrapper.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 12),
            wrapper.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -12),
			label.topAnchor.constraint(equalTo: wrapper.topAnchor, constant: 24),
			label.leadingAnchor.constraint(equalTo: wrapper.leadingAnchor, constant: 8)
		])
		wrapper.layer.cornerRadius = 10
		wrapper.clipsToBounds = true
	}
	
	private func updateViews() {
		guard let category = category else { return }
		label.text = category.title
	}
}

class GradientView: UIView {
    override class var layerClass: AnyClass {
        return CAGradientLayer.self
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupGradient()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupGradient()
    }

    var gradientLayer: CAGradientLayer {
        return layer as! CAGradientLayer
    }

    func setupGradient(startColor: UIColor = .white,
                       endColor: UIColor = .black,
                       startPoint: CGPoint = CGPoint(x: 0.5, y: 0.0),
                       endPoint: CGPoint = CGPoint(x: 0.5, y: 1.0)) {
        backgroundColor = .clear
        gradientLayer.colors = [startColor.cgColor, endColor.cgColor]
        gradientLayer.startPoint = startPoint
        gradientLayer.endPoint = endPoint
    }
}
