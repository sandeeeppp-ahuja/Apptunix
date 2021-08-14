//
//  APIHomeService.swift
//  Apptunix
//
//  Created by Sandeep Ahuja on 14/08/21.
//

import Foundation
import Alamofire

class APIHomeService: APIHomeProtocol {
  private let baseURL = "http://appgrowthcompany.com:3094"

  private enum EndPoints {
//    static let home = "/?isActive=true"
  }

  static var sharedService: APIHomeService = APIHomeService()
  init() {}

  func getHomeData(token: String, completion: @escaping (Home?, Error?, Int?) -> ()) {
    let path = baseURL
    let header: HTTPHeaders = ["authorization": token]

    AF.request(path, method: .get, parameters: nil, encoding: URLEncoding.default, headers: header).validate().responseData { dataResponse in
      let statusCode = dataResponse.response?.statusCode
      let result = dataResponse.result

      switch result {
      case .success(let value):
        do {
          let decoder = JSONDecoder()
          decoder.dateDecodingStrategy = .iso8601
          let homeData = try decoder.decode(Home.self, from: value)
          completion(homeData, nil, statusCode)
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
