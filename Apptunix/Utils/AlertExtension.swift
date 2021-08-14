//
//  AlertExtension.swift
//  ApptunixDemo
//
//  Created by Sandeep Ahuja on 13/08/21.
//

import UIKit

extension UIViewController {
  func showAlertOK(title: String, message: String, completionHandler: ((UIAlertAction) -> ())?) {
    let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
    alert.addAction( UIAlertAction(title: "Ok", style: .default, handler: completionHandler))
    self.present(alert, animated: true, completion: nil)
  }
}
