//
//  APILoginAndSignupService.swift
//  ApptunixDemo
//
//  Created by Sandeep Ahuja on 13/08/21.
//

import Foundation
import Alamofire

class APILoginAndSignupService: APILoginAndSignupProtocol {
  private let baseURL = "http://appgrowthcompany.com:3094"
  private enum EndPoints {
    static let login = "/login"
    static let signup = "/signup"
  }

  static var sharedService: APILoginAndSignupService = APILoginAndSignupService()
  init() {}

  func loginUser(email: String, password: String, completion: @escaping (Login?, Error?, Int?) -> ()) {
    let path = baseURL + EndPoints.login
    let params: Parameters = ["email": email, "password": password]

    AF.request(path, method: .post, parameters: params, encoding: JSONEncoding.default, headers: nil).validate().responseData { dataResponse in
      let statusCode = dataResponse.response?.statusCode
      let result = dataResponse.result

      switch result {
      case .success(let value):
        do {
          let decoder = JSONDecoder()
          decoder.dateDecodingStrategy = .iso8601
          let loginData = try decoder.decode(Login.self, from: value)
          completion(loginData, nil, statusCode)
        } catch {
          print("Decode Failure \(String(describing: #function)): \(String(describing: error))")
          completion(nil, error, statusCode)
        }

      case .failure(let error):
        if let data = dataResponse.data {
          let json = String(data: data, encoding: String.Encoding.utf8)
          print("Response Failure \(String(describing: #function)): \(String(describing: json)), \(error.localizedDescription), \(String(describing: statusCode))")
        }
        completion(nil, error, statusCode)

      }
    }
  }

  func SignupUser(email: String, password: String, completion: @escaping (Signup?, Error?, Int?) -> ()) {
    let path = baseURL + EndPoints.signup
    let params: Parameters = ["email": email, "password": password]

    AF.request(path, method: .post, parameters: params, encoding: JSONEncoding.default, headers: nil).validate().responseData { dataResponse in
      let statusCode = dataResponse.response?.statusCode
      let result = dataResponse.result

      switch result {
      case .success(let value):
        do {
          let decoder = JSONDecoder()
          decoder.dateDecodingStrategy = .iso8601
          let signupData = try decoder.decode(Signup.self, from: value)
          completion(signupData, nil, statusCode)
        } catch {
          print("Decode Failure \(String(describing: #function)): \(String(describing: error))")
          completion(nil, error, statusCode)
        }

      case .failure(let error):
        if let data = dataResponse.data {
          let json = String(data: data, encoding: String.Encoding.utf8)
          print("Response Failure \(String(describing: #function)): \(String(describing: json)), \(error.localizedDescription), \(String(describing: statusCode))")
        }
        completion(nil, error, statusCode)

      }
    }
  }
}
