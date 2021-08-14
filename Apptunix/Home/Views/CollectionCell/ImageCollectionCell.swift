//
//  ImageCollectionCell.swift
//  Apptunix
//
//  Created by Sandeep Ahuja on 14/08/21.
//

import UIKit
import Kingfisher

class ImageCollectionCell: UICollectionViewCell {
  lazy var imageView = UIImageView()

  override init(frame: CGRect) {
    super.init(frame: frame)
    configureViews()
    configureConstraints()
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  func setData(image: String) {
//    imageView.setImage(image: image)
  }
}

extension ImageCollectionCell {
  func configureViews() {
    contentView.backgroundColor = .white

    imageView = {
      let imageView = UIImageView()
      imageView.image = UIImage(named: "bg")
      imageView.layer.cornerRadius = 5
      imageView.contentMode = .scaleToFill
      imageView.translatesAutoresizingMaskIntoConstraints = false
      return imageView
    }()
  }

  func configureConstraints() {
    contentView.addSubview(imageView)

    NSLayoutConstraint.activate([
      imageView.topAnchor.constraint(equalTo: contentView.topAnchor),
      imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
      imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
      imageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
      imageView.heightAnchor.constraint(equalToConstant: 150)
    ])
  }
}
