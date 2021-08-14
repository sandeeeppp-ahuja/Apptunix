//
//  LoginModel.swift
//  ApptunixDemo
//
//  Created by Sandeep Ahuja on 13/08/21.
//

import Foundation

struct Login: Codable {
  let success: Bool?
  let message: String?
  let data: LoginData?
}

// MARK: - DataClass
struct LoginData: Codable {
  let token: String?
}
