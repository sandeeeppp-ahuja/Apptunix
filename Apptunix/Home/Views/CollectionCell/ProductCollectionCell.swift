//
//  ProductCollectionCell.swift
//  Apptunix
//
//  Created by Sandeep on 15/08/21.
//

import UIKit

class ProductCollectionCell: UICollectionViewCell {
  lazy var cellView = UIView()
  lazy var priceLabel = UILabel()
  lazy var imageView = UIImageView()
  lazy var nameLabel = UILabel()
  lazy var addToCartButton = UIButton()
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    configureViews()
    configureConstraints()
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  func setData(data: Product) {
    let titleString = "\(data.pack?.first?.currency ?? "SAR")" + " \(data.price ?? 0)"
    let attributedString = NSMutableAttributedString(string: titleString)
    attributedString.setColor(color: #colorLiteral(red: 0.3294117647, green: 0.7215686275, blue: 0.3294117647, alpha: 1), forText: "SAR")
    priceLabel.attributedText = attributedString
//    imageView.setImage(image: data.pack?.first?.image)
    nameLabel.text = data.name
  }
}

extension ProductCollectionCell {
  func configureViews() {
    contentView.backgroundColor = #colorLiteral(red: 0.921431005, green: 0.9214526415, blue: 0.9214410186, alpha: 1)

    cellView = {
      let view = UIView()
      view.backgroundColor = .white
      view.layer.cornerRadius = 20
      view.translatesAutoresizingMaskIntoConstraints = false
      return view
    }()
    
    priceLabel = {
      let label = UILabel()
      label.font = UIFont.systemFont(ofSize: 15, weight: .medium)
      label.translatesAutoresizingMaskIntoConstraints = false
      return label
    }()
    
    imageView = {
      let imageView = UIImageView()
      imageView.image = UIImage(named: "bg")
      imageView.contentMode = .scaleAspectFit
      imageView.translatesAutoresizingMaskIntoConstraints = false
      return imageView
    }()
    
    nameLabel = {
      let label = UILabel()
      label.font = UIFont.systemFont(ofSize: 18, weight: .medium)
      label.translatesAutoresizingMaskIntoConstraints = false
      return label
    }()
    
    addToCartButton = {
      let button = UIButton()
      button.backgroundColor = #colorLiteral(red: 0.2745098174, green: 0.4862745106, blue: 0.1411764771, alpha: 1)
      button.setTitle("Add to Cart", for: .normal)
      button.translatesAutoresizingMaskIntoConstraints = false
      return button
    }()
  }
  
  func configureConstraints() {
    contentView.addSubview(cellView)
    cellView.addSubview(priceLabel)
    cellView.addSubview(imageView)
    cellView.addSubview(nameLabel)
    cellView.addSubview(addToCartButton)
    
    NSLayoutConstraint.activate([
      cellView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 5),
      cellView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 5),
      cellView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -5),
      cellView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -5),
      
      priceLabel.topAnchor.constraint(equalTo: cellView.topAnchor, constant: 10),
      priceLabel.leadingAnchor.constraint(equalTo: cellView.leadingAnchor, constant: 8),
      priceLabel.heightAnchor.constraint(equalToConstant: 18),
      
      imageView.topAnchor.constraint(equalTo: priceLabel.bottomAnchor, constant: 5),
      imageView.leadingAnchor.constraint(equalTo: cellView.leadingAnchor, constant: 5),
      imageView.trailingAnchor.constraint(equalTo: cellView.trailingAnchor, constant: -5),
      imageView.heightAnchor.constraint(equalToConstant: 105),
      
      nameLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 5),
      nameLabel.leadingAnchor.constraint(equalTo: cellView.leadingAnchor, constant: 5),
      nameLabel.heightAnchor.constraint(equalToConstant: 20),
      
      addToCartButton.leadingAnchor.constraint(equalTo: cellView.leadingAnchor),
      addToCartButton.trailingAnchor.constraint(equalTo: cellView.trailingAnchor),
      addToCartButton.bottomAnchor.constraint(equalTo: cellView.bottomAnchor),
      addToCartButton.heightAnchor.constraint(equalToConstant: 35)
    ])
  }
}
