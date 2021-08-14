//
//  StringExtension.swift
//  Apptunix
//
//  Created by Sandeep Ahuja on 13/08/21.
//

import UIKit

extension NSMutableAttributedString {
  func setColor(color: UIColor, forText stringValue: String) {
    let range: NSRange = self.mutableString.range(of: stringValue, options: .caseInsensitive)
    self.addAttribute(NSAttributedString.Key.foregroundColor, value: color, range: range)
  }
}

extension String {
  //To check text field or String is blank or not
  var isBlank: Bool {
    get {
      let trimmed = trimmingCharacters(in: CharacterSet.whitespaces)
      return trimmed.isEmpty
    }
  }

  var isPhoneValid: Bool {
    let phoneRegex = "^[0-9+]{0,1}+[0-9]{5,16}$"
    let phoneTest = NSPredicate(format: "SELF MATCHES %@", phoneRegex)
    return phoneTest.evaluate(with: self)
  }
}
