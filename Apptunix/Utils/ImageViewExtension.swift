//
//  ImageViewExtension.swift
//  Apptunix
//
//  Created by Sandeep Ahuja on 14/08/21.
//

import UIKit
import Kingfisher

extension UIImageView {
  func setImage(image: String?) {
    guard let imageUrl = image else { return }
    let url = URL(string: "http://appgrowthcompany.com:3094" + imageUrl)
    self.kf.setImage(with: url)
  }
}
