//
//  GradientView.swift
//  Study Buddie
//
//  Created by Chad Rutherford on 9/14/20.
//

import UIKit

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

	func setupGradient(startColor: UIColor = .systemTeal,
					   endColor: UIColor = .systemBlue,
					   startPoint: CGPoint = CGPoint(x: 0.0, y: 0.0),
					   endPoint: CGPoint = CGPoint(x: 0.0, y: 1.0)) {
		backgroundColor = .clear
		gradientLayer.colors = [startColor.cgColor, endColor.cgColor]
		gradientLayer.startPoint = startPoint
		gradientLayer.endPoint = endPoint
	}
}
