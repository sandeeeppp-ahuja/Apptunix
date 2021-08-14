//
//  SignupViewController.swift
//  Apptunix
//
//  Created by Sandeep Ahuja on 14/08/21.
//

import UIKit

class SignupViewController: UIViewController {
  // MARK: - Properties
  lazy var createAccountLabel = UILabel()
  lazy var phoneNumberLabel = UILabel()
  lazy var phoneNumberPlaceHolderImage = UIImageView()
  lazy var phoneNumberTextField = UITextField()
  lazy var phoneNumberBottomView = UIView()
  lazy var passwordLabel = UILabel()
  lazy var passwordTextField = UITextField()
  lazy var passwordBottomView = UIView()
  lazy var confirmPasswordLabel = UILabel()
  lazy var confirmPasswordTextField = UITextField()
  lazy var confirmPasswordBottomView = UIView()
  lazy var signupButton = UIButton()
  lazy var loginButton = UIButton()

  lazy var inputToolbar: UIToolbar = {
    var toolbar = UIToolbar()
    toolbar.barStyle = .default
    toolbar.isTranslucent = true
    toolbar.sizeToFit()

    var doneButton = UIBarButtonItem(
      title: "Done",
      style: .plain,
      target: self,
      action: #selector(doneButtonTapped)
    )
    toolbar.setItems([doneButton], animated: false)
    toolbar.isUserInteractionEnabled = true

    return toolbar
  }()

  private let viewModel: SignupViewModel

  // MARK: - LifeCycle
  init(viewModel: SignupViewModel) {
    self.viewModel = viewModel
    super.init(nibName: nil, bundle: nil)
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    navigationController?.interactivePopGestureRecognizer?.isEnabled = false
    configureViews()
    configureConstraints()
  }

  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    configureBindings()
  }

  // MARK: - Helpers
  func configureBindings() {
    viewModel.activityIndicatorClosure = { [weak self] () in
      DispatchQueue.main.async {
        let isLoading = self?.viewModel.isLoading ?? false
        if isLoading == false {
          self?.view.stopActivityIndicator()
        } else {
          self?.view.startActivityIndicator()
        }
      }
    }

    viewModel.showAlertClosure = { [weak self] title, message, completionHandler in
      DispatchQueue.main.async {
        self?.showAlertOK(title: title, message: message, completionHandler: completionHandler)
      }
    }
  }

  // MARK: - Actions
  @objc func doneButtonTapped() {
    view.endEditing(true)
  }

  @objc func toggleButtonTapped(_ sender: UIButton) {
    if sender.tag == 1 {
      if sender.isSelected {
        passwordTextField.isSecureTextEntry = true
        sender.isSelected = false
      } else {
        passwordTextField.isSecureTextEntry = false
        sender.isSelected = true
      }
    } else {
      if sender.isSelected {
        confirmPasswordTextField.isSecureTextEntry = true
        sender.isSelected = false
      } else {
        confirmPasswordTextField.isSecureTextEntry = false
        sender.isSelected = true
      }
    }
  }

  @objc func loginButtonTapped() {
    view.endEditing(true)
    let viewModel = LoginViewModel(apiService: APILoginAndSignupService())
    let viewController = LoginViewController(viewModel: viewModel)
    navigationController?.pushViewController(viewController, animated: true)
  }

  @objc func signUpButtonTapped() {
    view.endEditing(true)
    let phoneNumber = viewModel.getSetPhoneNumber
    let password = viewModel.getSetPassword

    viewModel.signupUser(phoneNumber: phoneNumber, password: password) { [weak self] status in
      if status {
        let viewModel = HomeViewModel(apiService: APIHomeService())
        let viewController = HomeViewController(viewModel: viewModel)
        self?.navigationController?.pushViewController(viewController, animated: true)
      }
    }
  }

}

extension SignupViewController: UITextFieldDelegate {
  func textFieldDidEndEditing(_ textField: UITextField) {
    guard let textFieldText = textField.text else { return }
    viewModel.validateTextFields(textData: textFieldText, tag: textField.tag)
  }
}

extension SignupViewController {
  func configureViews() {
    view.backgroundColor = .white
    createAccountLabel = {
      let label = UILabel()
      label.text = "Welcome back!"
      label.textColor = .black
      label.font = UIFont.systemFont(ofSize: 30)
      label.translatesAutoresizingMaskIntoConstraints = false
      return label
    }()

    phoneNumberLabel = {
      let label = UILabel()
      label.text = "Phone Number"
      label.font = UIFont.systemFont(ofSize: 13)
      label.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
      label.translatesAutoresizingMaskIntoConstraints = false
      return label
    }()

    phoneNumberPlaceHolderImage = {
      let image = UIImage(named: "flag")
      let imageView = UIImageView(image: image)
      imageView.contentMode = .scaleAspectFit
      imageView.translatesAutoresizingMaskIntoConstraints = false
      return imageView
    }()

    phoneNumberTextField = {
      let textField = UITextField()
      textField.placeholder = "Enter Phone Number"
      textField.font = UIFont.systemFont(ofSize: 16)
      textField.borderStyle = .none
      textField.autocapitalizationType = .none
      textField.delegate = self
      textField.autocorrectionType = .no
      textField.keyboardType = .phonePad
      textField.textContentType = .telephoneNumber
      textField.clearButtonMode = .whileEditing
      textField.inputAccessoryView = inputToolbar
      textField.tag = 0
      textField.translatesAutoresizingMaskIntoConstraints = false
      return textField
    }()

    phoneNumberBottomView = {
      let view = UIView()
      view.backgroundColor = #colorLiteral(red: 0.0862745098, green: 0.06666666667, blue: 0.05098039216, alpha: 1)
      view.translatesAutoresizingMaskIntoConstraints = false
      return view
    }()

    passwordLabel = {
      let label = UILabel()
      label.text = "Password"
      label.font = UIFont.systemFont(ofSize: 12)
      label.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
      label.translatesAutoresizingMaskIntoConstraints = false
      return label
    }()

    passwordTextField = {
      let textField = UITextField()
      textField.placeholder = "Enter Password"
      textField.font = UIFont.systemFont(ofSize: 16)
      textField.borderStyle = .none
      textField.autocapitalizationType = .none
      textField.delegate = self
      textField.autocorrectionType = .no
      textField.inputAccessoryView = inputToolbar
      textField.isSecureTextEntry = true
      textField.tag = 1

      let button = UIButton(type: .custom)
      button.setImage(UIImage(named: "icon_eye-off"), for: .normal)
      button.setImage(UIImage(named: "icon_eye"), for: .selected)
      button.imageEdgeInsets = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
      button.tag = 1
      button.frame = CGRect(
        x: CGFloat(textField.frame.size.width - 25),
        y: CGFloat(5),
        width: CGFloat(10),
        height: CGFloat(10)
      )
      button.addTarget(self, action: #selector(toggleButtonTapped), for: .touchUpInside)

      textField.rightView = button
      textField.rightViewMode = .always
      textField.translatesAutoresizingMaskIntoConstraints = false
      return textField
    }()

    passwordBottomView = {
      let view = UIView()
      view.backgroundColor = #colorLiteral(red: 0.0862745098, green: 0.06666666667, blue: 0.05098039216, alpha: 1)
      view.translatesAutoresizingMaskIntoConstraints = false
      return view
    }()

    confirmPasswordLabel = {
      let label = UILabel()
      label.text = "Confirm Password"
      label.font = UIFont.systemFont(ofSize: 12)
      label.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
      label.translatesAutoresizingMaskIntoConstraints = false
      return label
    }()

    confirmPasswordTextField = {
      let textField = UITextField()
      textField.placeholder = "Enter Confirm Password"
      textField.font = UIFont.systemFont(ofSize: 16)
      textField.borderStyle = .none
      textField.autocapitalizationType = .none
      textField.delegate = self
      textField.autocorrectionType = .no
      textField.inputAccessoryView = inputToolbar
      textField.isSecureTextEntry = true
      textField.tag = 2

      let button = UIButton(type: .custom)
      button.setImage(UIImage(named: "icon_eye-off"), for: .normal)
      button.setImage(UIImage(named: "icon_eye"), for: .selected)
      button.imageEdgeInsets = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
      button.tag = 2
      button.frame = CGRect(
        x: CGFloat(textField.frame.size.width - 25),
        y: CGFloat(5),
        width: CGFloat(10),
        height: CGFloat(10)
      )
      button.addTarget(self, action: #selector(toggleButtonTapped), for: .touchUpInside)

      textField.rightView = button
      textField.rightViewMode = .always
      textField.translatesAutoresizingMaskIntoConstraints = false
      return textField
    }()

    confirmPasswordBottomView = {
      let view = UIView()
      view.backgroundColor = #colorLiteral(red: 0.0862745098, green: 0.06666666667, blue: 0.05098039216, alpha: 1)
      view.translatesAutoresizingMaskIntoConstraints = false
      return view
    }()

    signupButton = {
      let button = UIButton()
      button.setTitle("Sign up", for: .normal)
      button.titleLabel?.font = UIFont.systemFont(ofSize: 20, weight: .medium)
      button.setTitleColor(.white, for: .normal)
      button.backgroundColor = #colorLiteral(red: 0, green: 0.7384684682, blue: 0.2652260065, alpha: 1)
      button.layer.cornerRadius = 25
      button.isEnabled = true
      button.addTarget(self, action: #selector(signUpButtonTapped), for: .touchUpInside)
      button.translatesAutoresizingMaskIntoConstraints = false
      return button
    }()

    loginButton = {
      let button = UIButton()
      let titleString = "Have an account? Login"
      let attributedString = NSMutableAttributedString(string: titleString)
      attributedString.setColor(color: #colorLiteral(red: 0.3294117647, green: 0.7215686275, blue: 0.3294117647, alpha: 1), forText: "Login")
      button.setAttributedTitle(attributedString, for: .normal)
      button.titleLabel?.font = UIFont.systemFont(ofSize: 15)
      button.setTitleColor(.lightGray, for: .normal)
      button.isEnabled = true
      button.addTarget(self, action: #selector(loginButtonTapped), for: .touchUpInside)
      button.translatesAutoresizingMaskIntoConstraints = false
      return button
    }()
  }

  func configureConstraints() {
    view.addSubview(createAccountLabel)
    view.addSubview(phoneNumberLabel)
    view.addSubview(phoneNumberPlaceHolderImage)
    view.addSubview(phoneNumberTextField)
    view.addSubview(phoneNumberBottomView)
    view.addSubview(passwordLabel)
    view.addSubview(passwordTextField)
    view.addSubview(passwordBottomView)
    view.addSubview(confirmPasswordLabel)
    view.addSubview(confirmPasswordTextField)
    view.addSubview(confirmPasswordBottomView)
    view.addSubview(signupButton)
    view.addSubview(loginButton)

    NSLayoutConstraint.activate([
      createAccountLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 60),
      createAccountLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),

      phoneNumberLabel.topAnchor.constraint(equalTo: createAccountLabel.bottomAnchor, constant: 65),
      phoneNumberLabel.leadingAnchor.constraint(equalTo: phoneNumberBottomView.leadingAnchor),
      phoneNumberLabel.heightAnchor.constraint(equalToConstant: 15),

      phoneNumberPlaceHolderImage.topAnchor.constraint(equalTo: phoneNumberLabel.bottomAnchor, constant: 5),
      phoneNumberPlaceHolderImage.leadingAnchor.constraint(equalTo: phoneNumberBottomView.leadingAnchor),
      phoneNumberPlaceHolderImage.heightAnchor.constraint(equalToConstant: 24),
      phoneNumberPlaceHolderImage.widthAnchor.constraint(equalToConstant: 19),

      phoneNumberTextField.topAnchor.constraint(equalTo: phoneNumberPlaceHolderImage.topAnchor),
      phoneNumberTextField.leadingAnchor.constraint(equalTo: phoneNumberPlaceHolderImage.trailingAnchor, constant: 15),
      phoneNumberTextField.trailingAnchor.constraint(equalTo: phoneNumberBottomView.trailingAnchor),
      phoneNumberTextField.heightAnchor.constraint(equalToConstant: 25),

      phoneNumberBottomView.topAnchor.constraint(equalTo: phoneNumberPlaceHolderImage.bottomAnchor, constant: 5),
      phoneNumberBottomView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
      phoneNumberBottomView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40),
      phoneNumberBottomView.heightAnchor.constraint(equalToConstant: 1),

      passwordLabel.topAnchor.constraint(equalTo: phoneNumberBottomView.bottomAnchor, constant: 30),
      passwordLabel.leadingAnchor.constraint(equalTo: passwordBottomView.leadingAnchor),
      passwordLabel.heightAnchor.constraint(equalToConstant: 15),

      passwordTextField.topAnchor.constraint(equalTo: passwordLabel.bottomAnchor, constant: 5),
      passwordTextField.leadingAnchor.constraint(equalTo: phoneNumberBottomView.leadingAnchor),
      passwordTextField.trailingAnchor.constraint(equalTo: passwordBottomView.trailingAnchor),
      passwordTextField.heightAnchor.constraint(equalToConstant: 25),

      passwordBottomView.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor, constant: 5),
      passwordBottomView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
      passwordBottomView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40),
      passwordBottomView.heightAnchor.constraint(equalToConstant: 1),

      confirmPasswordLabel.topAnchor.constraint(equalTo: passwordBottomView.bottomAnchor, constant: 30),
      confirmPasswordLabel.leadingAnchor.constraint(equalTo: passwordBottomView.leadingAnchor),
      confirmPasswordLabel.heightAnchor.constraint(equalToConstant: 15),

      confirmPasswordTextField.topAnchor.constraint(equalTo: confirmPasswordLabel.bottomAnchor, constant: 5),
      confirmPasswordTextField.leadingAnchor.constraint(equalTo: passwordBottomView.leadingAnchor),
      confirmPasswordTextField.trailingAnchor.constraint(equalTo: passwordBottomView.trailingAnchor),
      confirmPasswordTextField.heightAnchor.constraint(equalToConstant: 25),

      confirmPasswordBottomView.topAnchor.constraint(equalTo: confirmPasswordTextField.bottomAnchor, constant: 5),
      confirmPasswordBottomView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
      confirmPasswordBottomView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40),
      confirmPasswordBottomView.heightAnchor.constraint(equalToConstant: 1),

      signupButton.topAnchor.constraint(equalTo: confirmPasswordBottomView.bottomAnchor, constant: 30),
      signupButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 50),
      signupButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -50),
      signupButton.heightAnchor.constraint(equalToConstant: 50),

      loginButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
      loginButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
      loginButton.heightAnchor.constraint(equalToConstant: 25),
    ])
  }
}
