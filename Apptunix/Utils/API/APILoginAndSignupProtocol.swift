//
//  APILoginAndSignupProtocol.swift
//  ApptunixDemo
//
//  Created by Sandeep Ahuja on 13/08/21.
//

import Foundation

protocol APILoginAndSignupProtocol {
  func loginUser (email: String, password: String, completion: @escaping (Login?, Error?, Int?) -> ())
  func SignupUser (email: String, password: String, completion: @escaping (Signup?, Error?, Int?) -> ())
}
