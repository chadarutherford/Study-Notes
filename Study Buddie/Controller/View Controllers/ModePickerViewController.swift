//
//  ModePickerViewController.swift
//  Study Buddie
//
//  Created by Chad Rutherford on 9/14/20.
//

import SwiftUI
import UIKit

class ModePickerViewController: UIViewController {
	
	let welcomeText: UILabel = {
		let label = UILabel()
		label.translatesAutoresizingMaskIntoConstraints = false
		label.text = "Welcome"
		label.font = UIFont.systemFont(ofSize: 40, weight: .heavy)
		return label
	}()
	
	let userText: UILabel = {
		let label = UILabel()
		label.translatesAutoresizingMaskIntoConstraints = false
		label.text = "Holly!"
		label.font = UIFont.systemFont(ofSize: 35, weight: .semibold)
		return label
	}()
	
	let instructionText: UILabel = {
		let label = UILabel()
		label.translatesAutoresizingMaskIntoConstraints = false
		label.text = "Please pick a mode below to get started!"
		label.font = UIFont.systemFont(ofSize: 28, weight: .medium)
		label.textAlignment = .center
		label.numberOfLines = 0

		return label
	}()
	
	let studyButton: UIButton = {
		let button = UIButton()
		button.layer.cornerRadius = 15
		button.backgroundColor = .systemBackground
		button.layer.cornerCurve = .continuous
		button.layer.shadowColor = UIColor.black.cgColor
		button.layer.shadowOpacity = 0.5
		button.layer.shadowOffset = .zero
		button.layer.shadowRadius = 10
		button.translatesAutoresizingMaskIntoConstraints = false
		let attributes: [NSAttributedString.Key: Any] = [
			NSAttributedString.Key.foregroundColor: UIColor.label,
			NSAttributedString.Key.font: UIFont.systemFont(ofSize: 30, weight: .semibold)
		]
		button.setAttributedTitle(NSAttributedString(string: "Study Mode", attributes: attributes), for: .normal)
		button.addTarget(self, action: #selector(presentStudyMode), for: .touchUpInside)
		return button
	}()
	
	let testButton: UIButton = {
		let button = UIButton()
		button.layer.cornerRadius = 15
		button.backgroundColor = .systemBackground
		button.layer.cornerCurve = .continuous
		button.layer.shadowColor = UIColor.black.cgColor
		button.layer.shadowOpacity = 0.5
		button.layer.shadowOffset = .zero
		button.layer.shadowRadius = 10
		button.translatesAutoresizingMaskIntoConstraints = false
		let attributes: [NSAttributedString.Key: Any] = [
			NSAttributedString.Key.foregroundColor: UIColor.label,
			NSAttributedString.Key.font: UIFont.systemFont(ofSize: 30, weight: .semibold)
		]
		button.setAttributedTitle(NSAttributedString(string: "Quiz Mode", attributes: attributes), for: .normal)
		button.addTarget(self, action: #selector(presentQuizMode), for: .touchUpInside)
		button.isEnabled = false
		return button
	}()
	
	var userInfo: AppleInfoModel?
	
	override func viewDidLoad() {
		super.viewDidLoad()
		configureUI()
	}
	
	private func configureUI() {
		view = GradientView()
		view.addSubview(welcomeText)
		view.addSubview(userText)
		view.addSubview(instructionText)
		view.addSubview(studyButton)
		view.addSubview(testButton)
		NSLayoutConstraint.activate([
			welcomeText.centerXAnchor.constraint(equalTo: view.centerXAnchor),
			welcomeText.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 40),
			
			userText.topAnchor.constraint(equalTo: welcomeText.bottomAnchor, constant: 20),
			userText.centerXAnchor.constraint(equalTo: view.centerXAnchor),
			
			instructionText.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
			instructionText.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
			instructionText.topAnchor.constraint(equalTo: userText.bottomAnchor, constant: 20),
			
			studyButton.topAnchor.constraint(equalTo: instructionText.bottomAnchor, constant: 20),
			studyButton.widthAnchor.constraint(equalToConstant: 300),
			studyButton.heightAnchor.constraint(equalToConstant: 60),
			studyButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
			
			testButton.topAnchor.constraint(equalTo: studyButton.bottomAnchor, constant: 20),
			testButton.widthAnchor.constraint(equalToConstant: 300),
			testButton.heightAnchor.constraint(equalToConstant: 60),
			testButton.centerXAnchor.constraint(equalTo: view.centerXAnchor)
		])
	}
	
	@objc private func presentStudyMode() {
		let categoryVC = CategoryTableViewController(nibName: nil, bundle: nil)
		let navController = UINavigationController(rootViewController: categoryVC)
		present(navController, animated: true)
	}
	
	@objc private func presentQuizMode() {
		
	}
}

struct ModePickerPreview: PreviewProvider {
	static var previews: some View {
		ContainerView()
			.edgesIgnoringSafeArea(.all)
			.preferredColorScheme(.dark)
	}
	
	struct ContainerView: UIViewControllerRepresentable {
		func updateUIViewController(_ uiViewController: ModePickerPreview.ContainerView.UIViewControllerType, context: UIViewControllerRepresentableContext<ModePickerPreview.ContainerView>) {
			
		}
		
		func makeUIViewController(context: UIViewControllerRepresentableContext<ModePickerPreview.ContainerView>) -> UIViewController {
			return ModePickerViewController()
		}
	}
}
