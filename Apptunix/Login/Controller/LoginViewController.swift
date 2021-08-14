//
//  LoginViewController.swift
//  ApptunixDemo
//
//  Created by Sandeep Ahuja on 12/08/21.
//

import UIKit

class LoginViewController: UIViewController {
  // MARK: - Properties
  lazy var welcomeLabel = UILabel()
  lazy var phoneNumberLabel = UILabel()
  lazy var phoneNumberPlaceHolderImage = UIImageView()
  lazy var phoneNumberTextField = UITextField()
  lazy var phoneNumberBottomView = UIView()
  lazy var passwordLabel = UILabel()
  lazy var passwordTextField = UITextField()
  lazy var passwordBottomView = UIView()
  lazy var forgotPasswordButton = UIButton()
  lazy var loginButton = UIButton()
  lazy var socialLoginsLabel = UILabel()
  lazy var socialLoginsLabelLeftView = UIView()
  lazy var socialLoginsLabelRightView = UIView()
  lazy var facebookImage = UIImageView()
  lazy var googleImage = UIImageView()
  lazy var appleImage = UIImageView()
  lazy var signupButton = UIButton()

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

  private let viewModel: LoginViewModel

  // MARK: - LifeCycle
  init(viewModel: LoginViewModel) {
    self.viewModel = viewModel
    super.init(nibName: nil, bundle: nil)
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    navigationController?.navigationBar.isHidden = true
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
  @objc func forgotButtonTapped() {}

  @objc func loginButtonTapped() {
    view.endEditing(true)
    let phoneNumber = viewModel.getSetPhoneNumber
    let password = viewModel.getSetPassword
    viewModel.loginUser(phoneNumber: phoneNumber, password: password) { [weak self] status in
      if status {
        let viewModel = HomeViewModel(apiService: APIHomeService())
        let viewController = HomeViewController(viewModel: viewModel)
        self?.navigationController?.pushViewController(viewController, animated: true)
      }
    }
  }

  @objc func signUpButtonTapped() {
    view.endEditing(true)
    let viewModel = SignupViewModel(apiService: APILoginAndSignupService())
    let viewController = SignupViewController(viewModel: viewModel)
    navigationController?.pushViewController(viewController, animated: true)
  }

  @objc func doneButtonTapped() {
    view.endEditing(true)
  }

  @objc func toggleButtonTapped(_ sender: UIButton) {
    if sender.isSelected {
      passwordTextField.isSecureTextEntry = true
      sender.isSelected = false
    } else {
      passwordTextField.isSecureTextEntry = false
      sender.isSelected = true
    }
  }
}

extension LoginViewController: UITextFieldDelegate {
  func textFieldDidEndEditing(_ textField: UITextField) {
    guard let textFieldText = textField.text else { return }
    if textField.tag == 0 {
      viewModel.validatePhoneNumber(phone: textFieldText)
    } else {
      viewModel.validatePassword(password: textFieldText)
    }
  }
}

extension LoginViewController {
  func configureViews() {
    view.backgroundColor = .white

    welcomeLabel = {
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

    forgotPasswordButton = {
      let button = UIButton()
      button.setTitle("Forgot Password?", for: .normal)
      button.titleLabel?.font = UIFont.systemFont(ofSize: 18)
      button.setTitleColor(#colorLiteral(red: 0.3294117647, green: 0.7215686275, blue: 0.3294117647, alpha: 1), for: .normal)
      button.addTarget(self, action: #selector(forgotButtonTapped), for: .touchUpInside)
      button.translatesAutoresizingMaskIntoConstraints = false
      return button
    }()

    loginButton = {
      let button = UIButton()
      button.setTitle("Login", for: .normal)
      button.titleLabel?.font = UIFont.systemFont(ofSize: 20, weight: .medium)
      button.setTitleColor(.white, for: .normal)
      button.backgroundColor = #colorLiteral(red: 0, green: 0.7384684682, blue: 0.2652260065, alpha: 1)
      button.layer.cornerRadius = 25
      button.isEnabled = true
      button.addTarget(self, action: #selector(loginButtonTapped), for: .touchUpInside)
      button.translatesAutoresizingMaskIntoConstraints = false
      return button
    }()

    socialLoginsLabel = {
      let label = UILabel()
      label.text = "Social Logins"
      label.textColor = .darkGray
      label.font = UIFont.systemFont(ofSize: 16, weight: .medium)
      label.translatesAutoresizingMaskIntoConstraints = false
      return label
    }()

    socialLoginsLabelLeftView = {
      let view = UIView()
      view.backgroundColor = #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)
      view.translatesAutoresizingMaskIntoConstraints = false
      return view
    }()

    socialLoginsLabelRightView = {
      let view = UIView()
      view.backgroundColor = #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)
      view.translatesAutoresizingMaskIntoConstraints = false
      return view
    }()

    facebookImage = {
      let image = UIImage(named: "facebook")
      let imageView = UIImageView(image: image)
      imageView.contentMode = .scaleAspectFit
      imageView.translatesAutoresizingMaskIntoConstraints = false
      return imageView
    }()

    googleImage = {
      let image = UIImage(named: "google")
      let imageView = UIImageView(image: image)
      imageView.contentMode = .scaleAspectFit
      imageView.translatesAutoresizingMaskIntoConstraints = false
      return imageView
    }()

    appleImage = {
      let image = UIImage(named: "apple")
      let imageView = UIImageView(image: image)
      imageView.contentMode = .scaleAspectFit
      imageView.translatesAutoresizingMaskIntoConstraints = false
      return imageView
    }()

    signupButton = {
      let button = UIButton()
      let titleString = "Don't have an account? Sign up"
      let attributedString = NSMutableAttributedString(string: titleString)
      attributedString.setColor(color: #colorLiteral(red: 0.3294117647, green: 0.7215686275, blue: 0.3294117647, alpha: 1), forText: "Sign up")
      button.setAttributedTitle(attributedString, for: .normal)
      button.titleLabel?.font = UIFont.systemFont(ofSize: 15)
      button.setTitleColor(.lightGray, for: .normal)
      button.isEnabled = true
      button.addTarget(self, action: #selector(signUpButtonTapped), for: .touchUpInside)
      button.translatesAutoresizingMaskIntoConstraints = false
      return button
    }()
  }

  func configureConstraints() {
    view.addSubview(welcomeLabel)
    view.addSubview(phoneNumberLabel)
    view.addSubview(phoneNumberPlaceHolderImage)
    view.addSubview(phoneNumberTextField)
    view.addSubview(phoneNumberBottomView)
    view.addSubview(passwordLabel)
    view.addSubview(passwordTextField)
    view.addSubview(passwordBottomView)
    view.addSubview(forgotPasswordButton)
    view.addSubview(loginButton)
    view.addSubview(socialLoginsLabel)
    view.addSubview(socialLoginsLabelLeftView)
    view.addSubview(socialLoginsLabelRightView)
    view.addSubview(facebookImage)
    view.addSubview(googleImage)
    view.addSubview(appleImage)
    view.addSubview(signupButton)

    NSLayoutConstraint.activate([
      welcomeLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 60),
      welcomeLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),

      phoneNumberLabel.topAnchor.constraint(equalTo: welcomeLabel.bottomAnchor, constant: 65),
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

      forgotPasswordButton.topAnchor.constraint(equalTo: passwordBottomView.bottomAnchor, constant: 30),
      forgotPasswordButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
      forgotPasswordButton.heightAnchor.constraint(equalToConstant: 20),

      loginButton.topAnchor.constraint(equalTo: forgotPasswordButton.bottomAnchor, constant: 30),
      loginButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 50),
      loginButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -50),
      loginButton.heightAnchor.constraint(equalToConstant: 50),

      socialLoginsLabel.topAnchor.constraint(equalTo: loginButton.bottomAnchor, constant: 30),
      socialLoginsLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),

      socialLoginsLabelLeftView.centerYAnchor.constraint(equalTo: socialLoginsLabel.centerYAnchor),
      socialLoginsLabelLeftView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 50),
      socialLoginsLabelLeftView.trailingAnchor.constraint(equalTo: socialLoginsLabel.leadingAnchor, constant: -20),
      socialLoginsLabelLeftView.heightAnchor.constraint(equalToConstant: 1),

      socialLoginsLabelRightView.centerYAnchor.constraint(equalTo: socialLoginsLabel.centerYAnchor),
      socialLoginsLabelRightView.leadingAnchor.constraint(equalTo: socialLoginsLabel.trailingAnchor, constant: 20),
      socialLoginsLabelRightView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -50),
      socialLoginsLabelRightView.heightAnchor.constraint(equalToConstant: 1),

      facebookImage.topAnchor.constraint(equalTo: socialLoginsLabel.bottomAnchor, constant: 20),
      facebookImage.trailingAnchor.constraint(equalTo: googleImage.leadingAnchor, constant: -20),
      facebookImage.heightAnchor.constraint(equalToConstant: 40),
      facebookImage.widthAnchor.constraint(equalToConstant: 40),

      googleImage.topAnchor.constraint(equalTo: socialLoginsLabel.bottomAnchor, constant: 20),
      googleImage.centerXAnchor.constraint(equalTo: view.centerXAnchor),
      googleImage.heightAnchor.constraint(equalToConstant: 40),
      googleImage.widthAnchor.constraint(equalToConstant: 40),

      appleImage.topAnchor.constraint(equalTo: socialLoginsLabel.bottomAnchor, constant: 20),
      appleImage.leadingAnchor.constraint(equalTo: googleImage.trailingAnchor, constant: 20),
      appleImage.heightAnchor.constraint(equalToConstant: 40),
      appleImage.widthAnchor.constraint(equalToConstant: 40),

      signupButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
      signupButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
      signupButton.heightAnchor.constraint(equalToConstant: 25)
    ])
  }
}
