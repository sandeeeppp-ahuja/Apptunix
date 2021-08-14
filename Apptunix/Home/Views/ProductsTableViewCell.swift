//
//  ProductsTableViewCell.swift
//  Apptunix
//
//  Created by Sandeep on 15/08/21.
//

import UIKit

class ProductsTableViewCell: UITableViewCell {
  lazy var cellLabel = UILabel()
  lazy var collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: UICollectionViewLayout())
  
  var productsData: [Product]?
  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    configureViews()
    configureConstraints()
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  func setData(label: String, data: [Product]) {
    cellLabel.text = label
    productsData = data
    collectionView.reloadData()
  }
}

extension ProductsTableViewCell {
  func configureViews() {
    contentView.backgroundColor = #colorLiteral(red: 0.921431005, green: 0.9214526415, blue: 0.9214410186, alpha: 1)

    cellLabel = {
      let label = UILabel()
      label.text = "Featured"
      label.font = UIFont.systemFont(ofSize: 18, weight: .medium)
      label.translatesAutoresizingMaskIntoConstraints = false
      return label
    }()
    
    collectionView = {
      let flowLayout = UICollectionViewFlowLayout()
      flowLayout.scrollDirection = .horizontal
      let collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: flowLayout)
      collectionView.backgroundColor = #colorLiteral(red: 0.921431005, green: 0.9214526415, blue: 0.9214410186, alpha: 1)
      collectionView.delegate = self
      collectionView.dataSource = self
      collectionView.showsHorizontalScrollIndicator = false
      collectionView.isPagingEnabled = true
      collectionView.isScrollEnabled = true
      collectionView.register(ProductCollectionCell.self, forCellWithReuseIdentifier: "ProductCollectionCell")
      collectionView.translatesAutoresizingMaskIntoConstraints = false
      return collectionView
    }()
  }

  func configureConstraints() {
    contentView.addSubview(cellLabel)
    contentView.addSubview(collectionView)

    NSLayoutConstraint.activate([
      cellLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 15),
      cellLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
      cellLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
      cellLabel.heightAnchor.constraint(equalToConstant: 20),
      
      collectionView.topAnchor.constraint(equalTo: cellLabel.bottomAnchor, constant: 10),
      collectionView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
      collectionView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
      collectionView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -5),
    ])
  }
}

extension ProductsTableViewCell: UICollectionViewDelegate, UICollectionViewDataSource {
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    guard let product = productsData?.count else { return 0 }
    return product
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(
      withReuseIdentifier: "ProductCollectionCell",
      for: indexPath
    ) as! ProductCollectionCell
    guard let product = productsData?[indexPath.row] else { return cell }
    cell.setData(data: product)
    return cell
  }
}

extension ProductsTableViewCell: UICollectionViewDelegateFlowLayout {
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//    let height = collectionView.frame.height/2.0
//    let width = collectionView.bounds.width/3.0
    return CGSize(width: 165, height: 230)
  }

  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
    return 0
  }

  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
    return 0
  }

  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
    return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
  }
}
