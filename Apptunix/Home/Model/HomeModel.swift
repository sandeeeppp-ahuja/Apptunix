//
//  HomeModel.swift
//  Apptunix
//
//  Created by Sandeep Ahuja on 14/08/21.
//

import Foundation

struct Home: Codable {
  let success: Bool?
  let data: HomeDataTypes?
}

// MARK: - DataClass
struct HomeDataTypes: Codable {
  let topBanners: [TopBanner]?
  let feturedProducts: [Product]?
  let recentlyViewed: [Product]?
  let categories: [CategoryElement]?
  let currencySymbol: String?
}

// MARK: - TopBanner
struct TopBanner: Codable {
  let isActive: Bool?
  let image: String?
}

// MARK: - CategoryElement
struct CategoryElement: Codable {
  let discount: Int?
  let type: String?
  let isUpto: Bool?
  let deliveryBy: String?
  let name: String?
  let image: String?
  let subCategoryData: [SubCategory]?
}

// MARK: - SubCategory
struct SubCategory: Codable {
  let discount: Int?
  let type: String?
  let name: String?
  let image: String?
  let isUpto: Bool?
}

// MARK: - FeturedProduct
struct Product: Codable {
  let name: String?
  let price: Int?
  let pack: [Pack]?
}

struct Pack: Codable {
  let unit: String?
  let quantity: String?
  let currency: String?
  let image: String?
}
