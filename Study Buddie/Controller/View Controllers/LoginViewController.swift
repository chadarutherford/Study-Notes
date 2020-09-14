//
//  LoginViewController.swift
//  Study Buddie
//
//  Created by Chad Rutherford on 9/14/20.
//

import AuthenticationServices
import UIKit

typealias AppleSignInBlock = ((_ userInfo: AppleInfoModel?, _ errorMessage: String?) -> Void)?

class LoginViewController: UIViewController {
	
	let imageView: UIImageView = {
		let imageView = UIImageView()
		imageView.translatesAutoresizingMaskIntoConstraints = false
		imageView.contentMode = .scaleAspectFill
		imageView.image = .study
		return imageView
	}()
	
	let welcomeText: UILabel = {
		let label = UILabel()
		label.translatesAutoresizingMaskIntoConstraints = false
		label.text = "Welcome to"
		label.font = UIFont.systemFont(ofSize: 40, weight: .heavy)
		return label
	}()
	
	let studyBuddieText: UILabel = {
		let label = UILabel()
		label.translatesAutoresizingMaskIntoConstraints = false
		label.text = "Study Buddie!"
		label.font = UIFont.systemFont(ofSize: 35, weight: .semibold)
		return label
	}()
	
	let signInButton: SignInWithAppleButton = {
		let button = SignInWithAppleButton(authorizationButtonType: .signIn, authorizationButtonStyle: .black)
		button.addTarget(self, action: #selector(loginTapped), for: .touchUpInside)
		return button
	}()
	
	var appleSignInBlock: AppleSignInBlock!
	var userInfo: AppleInfoModel?
	
	override func viewDidLoad() {
		super.viewDidLoad()
		configureUI()
		addObservers()
	}
	
	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)
		performExistingAccountSetup()
	}
	
	private func addObservers() {
		NotificationCenter.default.addObserver(self, selector: #selector(appleIDStatusChanged), name: ASAuthorizationAppleIDProvider.credentialRevokedNotification, object: nil)
	}
	
	private func configureUI() {
		view.addSubview(imageView)
		view.addSubview(welcomeText)
		view.addSubview(studyBuddieText)
		view.addSubview(signInButton)
		NSLayoutConstraint.activate([
			imageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
			imageView.topAnchor.constraint(equalTo: view.topAnchor),
			imageView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
			imageView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
			
			welcomeText.centerXAnchor.constraint(equalTo: view.centerXAnchor),
			welcomeText.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 40),
			
			studyBuddieText.topAnchor.constraint(equalTo: welcomeText.bottomAnchor, constant: 20),
			studyBuddieText.centerXAnchor.constraint(equalTo: view.centerXAnchor),
			
			signInButton.topAnchor.constraint(equalTo: studyBuddieText.bottomAnchor, constant: 40),
			signInButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
			signInButton.heightAnchor.constraint(equalToConstant: 40),
			signInButton.widthAnchor.constraint(equalToConstant: 180)
		])
	}
	
	@objc private func loginTapped() {
		let provider = ASAuthorizationAppleIDProvider()
		let request = provider.createRequest()
		request.requestedScopes = [.fullName, .email]
		
		let controller = ASAuthorizationController(authorizationRequests: [request])
		controller.delegate = self
		controller.presentationContextProvider = self
		controller.performRequests()
	}
	
	@objc private func appleIDStatusChanged() {
		let provider = ASAuthorizationAppleIDProvider()
		guard let userInfo = userInfo else { return }
		provider.getCredentialState(forUserID: userInfo.userId) { state, error in
			switch state {
			case .authorized:
				self.loginTapped()
			default:
				break
			}
		}
	}
	
	private func performExistingAccountSetup() {
		let requests = [
			ASAuthorizationAppleIDProvider().createRequest(),
			ASAuthorizationPasswordProvider().createRequest()
		]
		
		let authorizationController = ASAuthorizationController(authorizationRequests: requests)
		authorizationController.delegate = self
		authorizationController.presentationContextProvider = self
		authorizationController.performRequests()
	}
	
	private func saveUserInKeychain(_ userID: String) {
		do {
			try KeychainItem(service: "StudyBuddie", account: "userIdentifier").saveItem(userID)
		} catch {
			self.showAlert(title: "Keychain", message: "There was an error saving your information to the keychain, please try again.")
		}
	}
	
	private func showAlert(title: String, message: String) {
		let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
		alertController.addAction(UIAlertAction(title: "Dismiss", style: .cancel))
		present(alertController, animated: true)
	}
	
	private func presentModeController(userInfo: AppleInfoModel) {
		let modePickerVC = ModePickerViewController(nibName: nil, bundle: nil)
		modePickerVC.userInfo = userInfo
		present(modePickerVC, animated: true)
	}
}

extension LoginViewController: ASAuthorizationControllerDelegate {
	func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
		switch authorization.credential {
		case let appleIdCredential as ASAuthorizationAppleIDCredential:
			let userID = appleIdCredential.user
			let firstName = appleIdCredential.fullName?.givenName ?? KeychainItem.firstName ?? ""
			let lastName = appleIdCredential.fullName?.familyName ?? KeychainItem.lastName ?? ""
			let email = appleIdCredential.email ?? KeychainItem.email ?? ""
			
			KeychainItem.userId = userID
			KeychainItem.firstName = firstName
			KeychainItem.lastName = lastName
			KeychainItem.email = email
			
			userInfo = AppleInfoModel(userId: userID, email: email, firstName: firstName, lastName: lastName)
			
			self.saveUserInKeychain(userID)
			presentModeController(userInfo: userInfo!)
		case let passwordCredential as ASPasswordCredential:
			let username = passwordCredential.user
			let password = passwordCredential.password
			DispatchQueue.main.async {
				let message = "credentials, Username: \(username.capitalized), Password: \(password.removingPercentEncoding!)"
				self.showAlert(title: "Keychain", message: message)
			}
		default: break
		}
 	}
	
	func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
		self.showAlert(title: "Sign In Error", message: "There was an error signing you in, please try again")
	}
}

extension LoginViewController: ASAuthorizationControllerPresentationContextProviding {
	func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
		self.view.window!
	}
}
