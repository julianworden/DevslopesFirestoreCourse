//
//  CreateUserViewController.swift
//  DevslopesFirestoreCourse
//
//  Created by Julian Worden on 8/7/22.
//

import Firebase
import UIKit

class CreateUserViewController: UIViewController {
    lazy var contentStack = UIStackView(
        arrangedSubviews: [
            emailTextField,
            passwordTextField,
            usernameTextField,
            createUserButton,
            cancelButton
        ]
    )
    let emailTextField = UITextField()
    let passwordTextField = UITextField()
    let usernameTextField = UITextField()
    let createUserButton = RoundedButton(title: "Create User", color: Constants.yellowColor)
    let cancelButton = RoundedButton(title: "Cancel", color: .black)

    override func viewDidLoad() {
        super.viewDidLoad()

        configureViews()
        layoutViews()
    }

    func configureViews() {
        view.backgroundColor = .white

        contentStack.axis = .vertical
        contentStack.spacing = 10

        emailTextField.placeholder = "Email Address"
        emailTextField.font = UIFont(name: "Avenir Next Regular", size: 14)
        emailTextField.backgroundColor = .lightGray.withAlphaComponent(0.2)

        passwordTextField.isSecureTextEntry = true
        passwordTextField.placeholder = "Password"
        passwordTextField.font = UIFont(name: "Avenir Next Regular", size: 14)
        passwordTextField.backgroundColor = .lightGray.withAlphaComponent(0.2)

        usernameTextField.placeholder = "Username (Visible to Public)"
        usernameTextField.font = UIFont(name: "Avenir Next Regular", size: 14)
        usernameTextField.backgroundColor = .lightGray.withAlphaComponent(0.2)

        createUserButton.addTarget(self, action: #selector(createUserButtonTapped), for: .touchUpInside)

        cancelButton.addTarget(self, action: #selector(cancelButtonTapped), for: .touchUpInside)
    }

    @objc func createUserButtonTapped() {
        guard let email = emailTextField.text,
              let password = passwordTextField.text,
              let username = usernameTextField.text else { return }

        Auth.auth().createUser(withEmail: email, password: password) { result, error in
            if let error = error {
                debugPrint(error)
                return
            } else {
                guard let result = result else { return }
                let user = result.user
                let changeRequest = user.createProfileChangeRequest()

                changeRequest.displayName = username
                changeRequest.commitChanges { error in
                    if let error = error {
                        debugPrint(error)
                    }
                }

                Firestore.firestore()
                    .collection(Constants.fbUsers)
                    .document(user.uid).setData(
                        [
                            Constants.fbUsername: username,
                            Constants.fbDateCreated: FieldValue.serverTimestamp()
                        ]
                    ) { [weak self] error in
                        if let error = error {
                            debugPrint(error)
                            return
                        } else {
                            self?.dismiss(animated: true)
                        }
                    }
            }
        }
    }

    @objc func cancelButtonTapped() {
        dismiss(animated: true)
    }
}

// MARK: - Constraints

extension CreateUserViewController {
    func layoutViews() {
        view.addSubview(contentStack)

        contentStack.translatesAutoresizingMaskIntoConstraints = false
        emailTextField.translatesAutoresizingMaskIntoConstraints = false
        passwordTextField.translatesAutoresizingMaskIntoConstraints = false
        usernameTextField.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            contentStack.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            contentStack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            contentStack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),

            emailTextField.heightAnchor.constraint(equalToConstant: 44),
            passwordTextField.heightAnchor.constraint(equalToConstant: 44),
            usernameTextField.heightAnchor.constraint(equalToConstant: 44)
        ])
    }
}
