//
//  Utilities.swift
//  ApptunixDemo
//
//  Created by Sandeep Ahuja on 13/08/21.
//

import UIKit

class Utilities {
  static let shared = Utilities()

  func setLoginScreen() {
    // iOS13 or later
    let sceneDelegate = SceneDelegate.shared
    if let window = sceneDelegate?.window {
      let viewModel = LoginViewModel(apiService: APILoginAndSignupService())
      let navigationController = UINavigationController(rootViewController: LoginViewController(viewModel: viewModel))
      window.rootViewController = navigationController
      window.makeKeyAndVisible()
    }
  }

  func setupHomeScreen() {
    let sceneDelegate = SceneDelegate.shared
    if let window = sceneDelegate?.window {
      let viewModel = HomeViewModel(apiService: APIHomeService())
      let navigationController = UINavigationController(rootViewController: HomeViewController(viewModel: viewModel))
      window.rootViewController = navigationController
      window.makeKeyAndVisible()
    }
  }
}
