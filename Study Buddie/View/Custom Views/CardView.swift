//
//  CardView2.swift
//  Study Buddie
//
//  Created by Chad Rutherford on 8/7/20.
//

import UIKit

class CardView: UIView {
	
	var isFaceUp: Bool = true {
		didSet {
			setNeedsDisplay()
		}
	}
	
	let answerLabel: UILabel = {
		let label = UILabel()
		label.translatesAutoresizingMaskIntoConstraints = false
		label.textColor = .black
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
	
	override func draw(_ rect: CGRect) {
		if isFaceUp {
			return
		} else {
			let originX = rect.origin.x
			let originY = rect.origin.y
			
			guard let context = UIGraphicsGetCurrentContext() else { return }
			context.beginPath()
			for i in 0 ..< Int(rect.size.height) {
				context.setLineWidth(2)
				if i == 0 {
					context.move(to: CGPoint(x: originX, y: originY + 40.0))
					context.addLine(to: CGPoint(x: rect.size.width, y: originY + 40.0))
					context.setStrokeColor(UIColor.indexCardRed.cgColor)
					context.strokePath()
				} else {
					context.move(to: CGPoint(x: originX, y: originY + CGFloat((i + 1) * 40)))
					context.addLine(to: CGPoint(x: rect.size.width, y: originY + CGFloat((i + 1) * 40)))
					context.setStrokeColor(UIColor.indexCardBlue.cgColor)
					context.strokePath()
				}
			}
		}
	}
}
