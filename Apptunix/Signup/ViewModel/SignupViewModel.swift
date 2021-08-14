//
//  signupViewModel.swift
//  Apptunix
//
//  Created by Sandeep Ahuja on 13/08/21.
//

import UIKit

class SignupViewModel {
  // MARK: - Properties
  private var signupData: Signup?
  private var phoneNumber: String?
  private var password: String?
  private var confirmPassword: String?
  var isPhoneNumberFormatValid = false
  var isPasswordValid = false
  var isConfirmPasswordValid = false

  // MARK: - Closures
  var activityIndicatorClosure: (() -> Void)?
  var showAlertClosure: ((String, String, ((UIAlertAction) -> Void)?) -> Void)?

  private let api: APILoginAndSignupProtocol

  // MARK: - Initalizer
  init(apiService: APILoginAndSignupProtocol) {
    self.api = apiService
    #if !RELEASE
    print("[ARC DEBUG] Init SignupViewModel")
    #endif
  }

  deinit {
    #if !RELEASE
    print("[ARC DEBUG] Deinit SignupViewModel")
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

  var getSetConfirmPassword: String {
    get {
      return confirmPassword ?? ""
    }
    set(newValue) {
      confirmPassword = newValue
    }
  }


  var getSetSignup: Signup? {
    get {
      return signupData
    }
    set(newValue) {
      signupData = newValue
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

  func validateTextFields(textData: String, tag: Int) {
    switch tag {
    case 0:
      if textData.isPhoneValid {
        isPhoneNumberFormatValid = true
        getSetPhoneNumber = textData
      } else {
        isPhoneNumberFormatValid = false
      }
    case 1:
      // Minimun password length = 5
      isConfirmPasswordValid = false
      if textData.count > 5 {
        isPasswordValid = true
        getSetPassword = textData
      } else {
        isPasswordValid = false
      }
    case 2:
      // Minimun password length = 5
      if textData.count > 5 && textData == getSetPassword {
        isConfirmPasswordValid = true
        getSetConfirmPassword = textData
      } else {
        isConfirmPasswordValid = false
      }
    default:
      break
    }
  }

  func signupUser(phoneNumber: String, password: String, completion: @escaping((Bool) -> Void)) {
    if isPhoneNumberFormatValid && isPasswordValid && isConfirmPasswordValid {
      isLoading = true
      api.SignupUser(email: phoneNumber, password: password) { [weak self] signupData, error, statusCode in
        self?.isLoading = false
        guard error == nil else {
          self?.showOKAlert(title: "OhNo", message: "Something went wrong!", completionHandler: nil)
          completion(false)
          return
        }
        guard let signupData = signupData else {
          completion(false)
          return
        }
        if let success = signupData.success, success {
          self?.getSetSignup = signupData
          guard let token = signupData.data?.token else { return }
          UserDefaults.standard.set(token, forKey: "UserToken")
          completion(true)
        } else {
          self?.showOKAlert(title: "OhNo", message: signupData.message ?? "", completionHandler: nil)
        }
      }
    } else if !isPhoneNumberFormatValid{
      self.showOKAlert(title: "OhNo", message: "Invalid Phone number.", completionHandler: nil)
    } else if !isPasswordValid {
      self.showOKAlert(title: "OhNo", message: "Password must be atleast 5 digits.", completionHandler: nil)
    } else if !isConfirmPasswordValid {
      self.showOKAlert(title: "OhNo", message: "Password mismatch", completionHandler: nil)
    }
  }
}
