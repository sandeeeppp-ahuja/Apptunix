//
//  APIDashBoardProtocol.swift
//  Apptunix
//
//  Created by Sandeep Ahuja on 14/08/21.
//

import Foundation

protocol APIHomeProtocol {
  func getHomeData(token: String, completion: @escaping (Home?, Error?, Int?) -> ())
}
