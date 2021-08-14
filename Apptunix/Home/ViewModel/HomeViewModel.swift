//
//  HomeViewModel.swift
//  Apptunix
//
//  Created by Sandeep Ahuja on 14/08/21.
//

import UIKit

class HomeViewModel {
  // MARK: - Properties
  private var homeData: Home?
  
  var countriesData = ["India", "Damman", "Canada", "Australia"]

  // MARK: - Closures
  var activityIndicatorClosure: (() -> Void)?
  var showAlertClosure: ((String, String, ((UIAlertAction) -> Void)?) -> Void)?
  var reloadTableViewClosure: (() -> Void)?

  private let api: APIHomeProtocol

  // MARK: - Initalizer
  init(apiService: APIHomeProtocol) {
    self.api = apiService
    #if !RELEASE
    print("[ARC DEBUG] Init HomeViewModel")
    #endif
  }

  deinit {
    #if !RELEASE
    print("[ARC DEBUG] Deinit HomeViewModel")
    #endif
  }

  // MARK: - Property Setters
  var getSetHome: Home? {
    get {
      return homeData
    }
    set(newValue) {
      homeData = newValue
    }
  }

  var isLoading = true {
    didSet {
      self.activityIndicatorClosure?()
    }
  }

  // MARK: - Table View
  var tableViewCellExpanded = 0
  
  var numberOfSectionsInTable: Int {
    // +3 for banners, Featured, Recently
    guard let categories = getSetHome?.data?.categories?.count else { return 0 }
    return categories + 3
  }

  func numberOfRowsInSection(for section: Int, isExpanded: Bool) -> Int {
    switch section {
    case 0, numberOfSectionsInTable - 1, numberOfSectionsInTable - 2:
      return 1
    default:
      if isExpanded {
        return 2
      } else {
        return 1
      }
    }
  }

  func heightForTableViewSection(section: Int, row: Int) -> CGFloat {
    switch section {
    case 0:
      return 188
    case numberOfSectionsInTable - 1, numberOfSectionsInTable - 2:
      return 300
    default:
      if row == 0 {
        return 85
      } else {
        return 230
      }
    }
  }

  // Banner Cell:
  var numberOfItemsInBannerCollection: Int {
    guard let banners = getSetHome?.data?.topBanners else { return 0 }
    return banners.count
  }

  // MARK: - Methods
  private func showOKAlert(title: String, message: String, completionHandler: ((UIAlertAction) -> Void)?) {
    self.showAlertClosure?(title, message, completionHandler)
  }

  func getHomeData() {
    isLoading = true
    guard let token = UserDefaults.standard.value(forKey: "UserToken") as? String else { return }
    api.getHomeData(token: token) { [weak self] homeData, error, statusCode in
      self?.isLoading = false
      guard error == nil else {
        self?.showOKAlert(title: "OhNo", message: "Something went wrong!", completionHandler: nil)
        return
      }
      guard let homeData = homeData else {
        return
      }
      if let success = homeData.success, success {
        self?.getSetHome = homeData
        self?.reloadTableViewClosure?()
      } else {
        self?.showOKAlert(title: "OhNo", message: "Something went wrong!", completionHandler: nil)
      }
    }
  }
}
