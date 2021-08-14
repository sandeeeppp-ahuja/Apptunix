//
//  CategoryTableViewCell.swift
//  Apptunix
//
//  Created by Sandeep on 14/08/21.
//

import UIKit

class CategoryTableViewCell: UITableViewCell {
  lazy var categoryImage = UIImageView()
  lazy var categoryLabel = UILabel()
  lazy var discountLabel = UILabel()
  lazy var deliveryLabel = UILabel()
  lazy var arrowImage = UIImageView()

  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    configureViews()
    configureConstraints()
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  func setData(data: CategoryElement, isOpen: Bool) {
//    categoryImage.setImage(image: data.image)
    categoryLabel.text = data.name ?? ""
    discountLabel.text = "Up to \(data.discount ?? 0)% off"
    if isOpen {
      arrowImage.image = UIImage(named: "up")
    } else {
      arrowImage.image = UIImage(named: "down")
    }
  }

}

extension CategoryTableViewCell {
  func configureViews() {
    contentView.backgroundColor = .white
    
    categoryImage = {
      let imageView = UIImageView()
      imageView.image = UIImage(named: "bg")
      imageView.contentMode = .scaleAspectFit
      imageView.translatesAutoresizingMaskIntoConstraints = false
      return imageView
    }()
    
    categoryLabel = {
      let label = UILabel()
      label.font = UIFont.systemFont(ofSize: 18, weight: .medium)
      label.translatesAutoresizingMaskIntoConstraints = false
      return label
    }()
    
    discountLabel = {
      let label = UILabel()
      label.font = UIFont.systemFont(ofSize: 12, weight: .medium)
      label.textColor = #colorLiteral(red: 0.3294117647, green: 0.7215686275, blue: 0.3294117647, alpha: 1)
      label.translatesAutoresizingMaskIntoConstraints = false
      return label
    }()
    
    deliveryLabel = {
      let label = UILabel()
      label.text = "Will be delivered by 3pm to 9pm"
      label.font = UIFont.systemFont(ofSize: 10)
      label.translatesAutoresizingMaskIntoConstraints = false
      return label
    }()
    
    arrowImage = {
      let imageView = UIImageView()
      imageView.image = UIImage(named: "down")
      imageView.contentMode = .scaleAspectFit
      imageView.translatesAutoresizingMaskIntoConstraints = false
      return imageView
    }()
  }
  
  func configureConstraints() {
    contentView.addSubview(categoryImage)
    contentView.addSubview(categoryLabel)
    contentView.addSubview(discountLabel)
    contentView.addSubview(deliveryLabel)
    contentView.addSubview(arrowImage)
    
    NSLayoutConstraint.activate([
      categoryImage.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 2),
      categoryImage.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 2),
      categoryImage.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: 2),
      categoryImage.heightAnchor.constraint(equalToConstant: 60),
      categoryImage.widthAnchor.constraint(equalToConstant: 100),
      
      categoryLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
      categoryLabel.leadingAnchor.constraint(equalTo: categoryImage.trailingAnchor, constant: 5),
      categoryLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -5),
      categoryLabel.heightAnchor.constraint(equalToConstant: 20),
      
      discountLabel.topAnchor.constraint(equalTo: categoryLabel.bottomAnchor, constant: 5),
      discountLabel.leadingAnchor.constraint(equalTo: categoryImage.trailingAnchor, constant: 5),
      discountLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -5),
      discountLabel.heightAnchor.constraint(equalToConstant: 15),
      
      deliveryLabel.topAnchor.constraint(equalTo: discountLabel.bottomAnchor, constant: 5),
      deliveryLabel.leadingAnchor.constraint(equalTo: categoryImage.trailingAnchor, constant: 5),
      deliveryLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -5),
      deliveryLabel.heightAnchor.constraint(equalToConstant: 12),
      
      arrowImage.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
      arrowImage.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -15),
      arrowImage.heightAnchor.constraint(equalToConstant: 24),
      arrowImage.widthAnchor.constraint(equalToConstant: 24)
    ])
  }
}
