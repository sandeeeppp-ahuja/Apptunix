//
//  LoginViewModel.swift
//  ApptunixDemo
//
//  Created by Sandeep Ahuja on 12/08/21.
//

import UIKit

class LoginViewModel {
  // MARK: - Properties
  private var loginData: Login?
  private var phoneNumber: String?
  private var password: String?
  var isPhoneNumberFormatValid = false
  var isPasswordValid = false

  // MARK: - Closures
  var activityIndicatorClosure: (() -> Void)?
  var showAlertClosure: ((String, String, ((UIAlertAction) -> Void)?) -> Void)?

  private let api: APILoginAndSignupProtocol

  // MARK: - Initalizer
  init(apiService: APILoginAndSignupProtocol) {
    self.api = apiService
    #if !RELEASE
    print("[ARC DEBUG] Init LogInViewModel")
    #endif
  }

  deinit {
    #if !RELEASE
    print("[ARC DEBUG] Deinit LogInViewModel")
    #endif
  }

  // MARK: - Property Setters
  var getSetPhoneNumber: String {
    get {
      return phoneNumber ?? ""
    }
    set(newValue) {
      phoneNumber = newValue
    }
  }

  var getSetPassword: String {
    get {
      return password ?? ""
    }
    set(newValue) {
      password = newValue
    }
  }

  var getSetLogin: Login? {
    get {
      return loginData
    }
    set(newValue) {
      loginData = newValue
    }
  }

  var isLoading = true {
    didSet {
      self.activityIndicatorClosure?()
    }
  }

  // MARK: - Methods
  private func showOKAlert(title: String, message: String, completionHandler: ((UIAlertAction) -> Void)?) {
    self.showAlertClosure?(title, message, completionHandler)
  }

  func validatePhoneNumber(phone: String) {
    if phone.isPhoneValid {
      isPhoneNumberFormatValid = true
      getSetPhoneNumber = phone
    } else {
      isPhoneNumberFormatValid = false
    }
  }

  func validatePassword(password: String) {
    // Minimun password length = 5
    if password.count > 5 {
      isPasswordValid = true
      getSetPassword = password
    } else {
      isPasswordValid = false
    }
  }

  func loginUser(phoneNumber: String, password: String, completion: @escaping((Bool) -> Void)) {
    if isPhoneNumberFormatValid && isPasswordValid {
      isLoading = true
      api.loginUser(email: phoneNumber, password: password) { [weak self] loginData, error, statusCode in
        self?.isLoading = false
        guard error == nil else {
          self?.showOKAlert(title: "OhNo", message: "Something went wrong!", completionHandler: nil)
          completion(false)
          return
        }
        guard let loginData = loginData else {
          completion(false)
          return
        }
        if let success = loginData.success, success {
          self?.getSetLogin = loginData
          guard let token = loginData.data?.token else { return }
          UserDefaults.standard.set(token, forKey: "UserToken")
          completion(true)
        } else {
          self?.showOKAlert(title: "OhNo", message: loginData.message ?? "", completionHandler: nil)
        }
      }
    } else if !isPhoneNumberFormatValid{
      self.showOKAlert(title: "OhNo", message: "Invalid Phone number.", completionHandler: nil)
    } else {
      self.showOKAlert(title: "OhNo", message: "Password must be atleast 5 digits.", completionHandler: nil)
    }

  }
}
