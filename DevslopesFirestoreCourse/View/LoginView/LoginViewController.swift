//
//  LoginViewController.swift
//  DevslopesFirestoreCourse
//
//  Created by Julian Worden on 8/7/22.
//

import Firebase
import UIKit

class LoginViewController: UIViewController {
    lazy var contentStack = UIStackView(arrangedSubviews: [loginStack, signUpStack])
    lazy var loginStack = UIStackView(arrangedSubviews: [emailTextField, passwordTextField, logInButton])
    let emailTextField = UITextField()
    let passwordTextField = UITextField()
    let logInButton = RoundedButton(title: "Log In", color: Constants.yellowColor)
    lazy var signUpStack = UIStackView(arrangedSubviews: [noAccountLabel, createUserButton])
    let noAccountLabel = UILabel()
    let createUserButton = RoundedButton(title: "Create User", color: Constants.yellowColor)

    override func viewDidLoad() {
        super.viewDidLoad()

        configureViews()
        layoutViews()
    }

    func configureViews() {
        view.backgroundColor = .white

        contentStack.axis = .vertical
        contentStack.spacing = 20

        loginStack.axis = .vertical
        loginStack.spacing = 10

        emailTextField.placeholder = "Email Address"
        emailTextField.font = UIFont(name: "Avenir Next Regular", size: 14)
        emailTextField.backgroundColor = .lightGray.withAlphaComponent(0.2)

        passwordTextField.isSecureTextEntry = true
        passwordTextField.placeholder = "Password"
        passwordTextField.font = UIFont(name: "Avenir Next Regular", size: 14)
        passwordTextField.backgroundColor = .lightGray.withAlphaComponent(0.2)

        logInButton.addTarget(self, action: #selector(logInButtonTapped), for: .touchUpInside)

        signUpStack.axis = .vertical
        signUpStack.spacing = 10

        noAccountLabel.text = "Don't have an account?"
        noAccountLabel.font = UIFont(name: "Avenir Next Regular", size: 12)

        createUserButton.addTarget(self, action: #selector(createUserButtonTapped), for: .touchUpInside)
    }

    @objc func logInButtonTapped() {
        guard let email = emailTextField.text,
              let password = passwordTextField.text else { return }

        Auth.auth().signIn(withEmail: email, password: password) { [weak self] _, error in
            if let error = error {
                debugPrint("Error signing in: \(error)")
            } else {
                self?.dismiss(animated: true)
            }
        }
    }

    @objc func createUserButtonTapped() {
        let createUserViewController = CreateUserViewController()
        present(createUserViewController, animated: true)
    }
}

// MARK: - Constraints

extension LoginViewController {
    func layoutViews() {
        view.addSubview(contentStack)

        contentStack.translatesAutoresizingMaskIntoConstraints = false
        emailTextField.translatesAutoresizingMaskIntoConstraints = false
        passwordTextField.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            contentStack.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            contentStack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            contentStack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),

            emailTextField.heightAnchor.constraint(equalToConstant: 44),
            passwordTextField.heightAnchor.constraint(equalToConstant: 44)
        ])
    }
}
