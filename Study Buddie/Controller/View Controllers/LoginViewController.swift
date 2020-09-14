//
//  LoginViewController.swift
//  Study Buddie
//
//  Created by Chad Rutherford on 9/14/20.
//

import SwiftUI
import UIKit

class LoginViewController: UIViewController {
	override func viewDidLoad() {
		super.viewDidLoad()
		view = GradientView()
	}
}

struct LoginPreview: PreviewProvider {
	static var previews: some View {
		ContainerView()
			.edgesIgnoringSafeArea(.all)
			.preferredColorScheme(.dark)
	}
	
	struct ContainerView: UIViewControllerRepresentable {
		func updateUIViewController(_ uiViewController: LoginPreview.ContainerView.UIViewControllerType, context: UIViewControllerRepresentableContext<LoginPreview.ContainerView>) {
			
		}
		
		func makeUIViewController(context: UIViewControllerRepresentableContext<LoginPreview.ContainerView>) -> UIViewController {
			return LoginViewController()
		}
	}
}
