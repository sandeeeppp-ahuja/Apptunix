//
//  CategoryCollectionCell.swift
//  Apptunix
//
//  Created by Sandeep on 15/08/21.
//

import UIKit

class CategoryCollectionCell: UICollectionViewCell {
  lazy var cellView = UIView()
  lazy var imageView = UIImageView()
  lazy var nameLabel = UILabel()
  lazy var discountLabel = UILabel()
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    configureViews()
    configureConstraints()
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  func setData(data: SubCategory) {
//    imageView.setImage(image: data.image)
    nameLabel.text = data.name
    discountLabel.text = "Min \(data.discount ?? 0)% off"
  }

}

extension CategoryCollectionCell {
  func configureViews() {
    contentView.backgroundColor = .white

    cellView = {
      let view = UIView()
      view.backgroundColor = #colorLiteral(red: 0.921431005, green: 0.9214526415, blue: 0.9214410186, alpha: 0.5)
      view.layer.cornerRadius = 10
      view.translatesAutoresizingMaskIntoConstraints = false
      return view
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
      label.font = UIFont.systemFont(ofSize: 15, weight: .regular)
      label.translatesAutoresizingMaskIntoConstraints = false
      return label
    }()
    
    discountLabel = {
      let label = UILabel()
      label.font = UIFont.systemFont(ofSize: 12, weight: .regular)
      label.textColor = #colorLiteral(red: 0.3294117647, green: 0.7215686275, blue: 0.3294117647, alpha: 1)
      label.translatesAutoresizingMaskIntoConstraints = false
      return label
    }()
  }

  func configureConstraints() {
    contentView.addSubview(cellView)
    cellView.addSubview(imageView)
    cellView.addSubview(nameLabel)
    cellView.addSubview(discountLabel)

    NSLayoutConstraint.activate([
      cellView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 5),
      cellView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 5),
      cellView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -5),
      cellView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -5),
      
      imageView.topAnchor.constraint(equalTo: cellView.topAnchor, constant: 2),
      imageView.centerXAnchor.constraint(equalTo: cellView.centerXAnchor),
      imageView.heightAnchor.constraint(equalToConstant: 50),
      imageView.widthAnchor.constraint(equalToConstant: 70),
      
      nameLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 5),
      nameLabel.centerXAnchor.constraint(equalTo: cellView.centerXAnchor),
      
      discountLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 5),
      discountLabel.centerXAnchor.constraint(equalTo: cellView.centerXAnchor)
    ])
  }
}
