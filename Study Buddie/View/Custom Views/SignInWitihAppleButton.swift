//
//  SignInWitihAppleButton.swift
//  Study Buddie
//
//  Created by Chad Rutherford on 9/14/20.
//

import AuthenticationServices
import UIKit

class SignInWithAppleButton: ASAuthorizationAppleIDButton {
	override init(authorizationButtonType type: ASAuthorizationAppleIDButton.ButtonType, authorizationButtonStyle style: ASAuthorizationAppleIDButton.Style) {
		super.init(authorizationButtonType: type, authorizationButtonStyle: style)
		commonInit()
	}
	
	required init?(coder: NSCoder) {
		super.init(coder: coder)
		commonInit()
	}
	private func commonInit() {
		translatesAutoresizingMaskIntoConstraints = false
		isUserInteractionEnabled = true
	}
}

