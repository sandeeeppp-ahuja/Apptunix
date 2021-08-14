//
//  SignupModel.swift
//  Apptunix
//
//  Created by Sandeep Ahuja on 14/08/21.
//

import Foundation

// MARK: - Welcome
struct Signup: Codable {
  let success: Bool?
  let message: String?
  let data: SignupData?
}

// MARK: - DataClass
struct SignupData: Codable {
  let email, password, id: String?
  let v: Int?
  let token: String?

  enum CodingKeys: String, CodingKey {
    case email, password
    case id = "_id"
    case v = "__v"
    case token
  }
}
