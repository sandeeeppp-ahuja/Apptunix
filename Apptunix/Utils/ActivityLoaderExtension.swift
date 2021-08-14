//
//  ActivityLoaderExtension.swift
//  ApptunixDemo
//
//  Created by Sandeep Ahuja on 13/08/21.
//

import Foundation
import UIKit

extension UIView {

  var loadingViewTag: Int { return 999 }

  func startActivityIndicator() {

    // Remove any duplictes
    if let loadingView = subviews.filter({ (view) -> Bool in
      view.tag == self.loadingViewTag
    }).first {
      loadingView.removeFromSuperview()
    }

    // Activity Indicator
    let loadingView = UIView(frame: .zero)
    let activityIndicator = UIActivityIndicatorView(frame: .zero)
    addSubview(loadingView)
    loadingView.addSubview(activityIndicator)
    loadingView.translatesAutoresizingMaskIntoConstraints = false
    activityIndicator.translatesAutoresizingMaskIntoConstraints = false

    loadingView.centerYAnchor.constraint(equalTo: centerYAnchor, constant: 0).isActive = true
    loadingView.centerXAnchor.constraint(equalTo: centerXAnchor, constant: 0).isActive = true
    loadingView.widthAnchor.constraint(equalToConstant: 80).isActive = true
    loadingView.heightAnchor.constraint(equalToConstant: 80).isActive = true
    loadingView.backgroundColor = UIColor(red: 68/255, green: 68/255, blue: 68/255, alpha: 0.7)
    loadingView.clipsToBounds = true
    loadingView.layer.cornerRadius = 10

    activityIndicator.style = .large
    activityIndicator.centerYAnchor.constraint(equalTo: loadingView.centerYAnchor, constant: 0).isActive = true
    activityIndicator.centerXAnchor.constraint(equalTo: loadingView.centerXAnchor, constant: 0).isActive = true
    activityIndicator.hidesWhenStopped = true
    activityIndicator.startAnimating()

    // Add tag to find the loader view
    loadingView.tag = self.loadingViewTag
  }

  func stopActivityIndicator() {
    if let loadingView = subviews.filter({ (view) -> Bool in
      view.tag == self.loadingViewTag
    }).first {
      loadingView.removeFromSuperview()
    }
  }
}
