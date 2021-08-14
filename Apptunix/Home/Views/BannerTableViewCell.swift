//
//  BannerTableViewCell.swift
//  Apptunix
//
//  Created by Sandeep Ahuja on 14/08/21.
//

import UIKit

class BannerTableViewCell: UITableViewCell {
  lazy var collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: UICollectionViewLayout())
  lazy var pageControl = UIPageControl()

  private  var viewModel: HomeViewModel?

  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    configureViews()
    configureConstraints()
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  func setupData(viewModel: HomeViewModel) {
    self.viewModel = viewModel
    pageControl.numberOfPages = viewModel.numberOfItemsInBannerCollection
    collectionView.reloadData()
  }
}

extension BannerTableViewCell {
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
      collectionView.register(ImageCollectionCell.self, forCellWithReuseIdentifier: "ImageCollectionCell")
      collectionView.translatesAutoresizingMaskIntoConstraints = false
      return collectionView
    }()

    pageControl = {
      let pageControl = UIPageControl()
      pageControl.pageIndicatorTintColor = .lightGray
      pageControl.currentPageIndicatorTintColor = .green
      pageControl.numberOfPages = 3
      pageControl.translatesAutoresizingMaskIntoConstraints = false
      return pageControl
    }()
  }

  func configureConstraints() {
    contentView.addSubview(collectionView)
    contentView.addSubview(pageControl)

    NSLayoutConstraint.activate([
      collectionView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 5),
      collectionView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
      collectionView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
      collectionView.heightAnchor.constraint(equalToConstant: 150),
      collectionView.bottomAnchor.constraint(equalTo: pageControl.topAnchor, constant: -5),

      pageControl.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
      pageControl.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -5)
    ])
  }
}

extension BannerTableViewCell: UICollectionViewDelegate, UICollectionViewDataSource {
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    guard let viewModel = viewModel else { return 0 }
    return viewModel.numberOfItemsInBannerCollection
  }

  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(
      withReuseIdentifier: "ImageCollectionCell",
      for: indexPath
    ) as! ImageCollectionCell
    guard let bannerImage = viewModel?.getSetHome?.data?.topBanners?[indexPath.row].image else { return cell }
    cell.setData(image: bannerImage)
    return cell
  }

  func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
    pageControl.currentPage = indexPath.row
  }

}

extension BannerTableViewCell: UICollectionViewDelegateFlowLayout {
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    let height = collectionView.frame.height
    let width = collectionView.frame.width
    return CGSize(width: width, height: height)
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
