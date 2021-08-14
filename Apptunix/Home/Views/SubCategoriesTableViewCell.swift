//
//  SubCategoriesTableViewCell.swift
//  Apptunix
//
//  Created by Sandeep on 15/08/21.
//

import UIKit

class SubCategoriesTableViewCell: UITableViewCell {
  lazy var collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: UICollectionViewLayout())
    
  var subCategoryData: [SubCategory]?
  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    configureViews()
    configureConstraints()
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  func setData(data: [SubCategory]) {
    subCategoryData = data
    collectionView.reloadData()
  }
}

extension SubCategoriesTableViewCell {
  func configureViews() {
    contentView.backgroundColor = .white

    collectionView = {
      let flowLayout = UICollectionViewFlowLayout()
      flowLayout.scrollDirection = .horizontal
      let collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: flowLayout)
      collectionView.backgroundColor = .clear
      collectionView.delegate = self
      collectionView.dataSource = self
      collectionView.showsHorizontalScrollIndicator = false
      collectionView.isPagingEnabled = true
      collectionView.isScrollEnabled = true
      collectionView.register(CategoryCollectionCell.self, forCellWithReuseIdentifier: "CategoryCollectionCell")
      collectionView.translatesAutoresizingMaskIntoConstraints = false
      return collectionView
    }()
  }

  func configureConstraints() {
    contentView.addSubview(collectionView)

    NSLayoutConstraint.activate([
      collectionView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 5),
      collectionView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 5),
      collectionView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -5),
      collectionView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -5),
    ])
  }
}

extension SubCategoriesTableViewCell: UICollectionViewDelegate, UICollectionViewDataSource {
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    guard let count = subCategoryData?.count else { return 0 }
    return count
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(
      withReuseIdentifier: "CategoryCollectionCell",
      for: indexPath
    ) as! CategoryCollectionCell
    guard let data = subCategoryData?[indexPath.row] else { return cell }
    cell.setData(data: data)
    return cell
  }
}

extension SubCategoriesTableViewCell: UICollectionViewDelegateFlowLayout {
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//    let height = collectionView.frame.height/2.0
    let width = collectionView.bounds.width/3.0
    return CGSize(width: width, height: 110)
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
