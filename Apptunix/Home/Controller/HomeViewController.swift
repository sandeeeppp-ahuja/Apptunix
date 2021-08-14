//
//  HomeViewController.swift
//  Apptunix
//
//  Created by Sandeep Ahuja on 14/08/21.
//

import UIKit
import DropDown

class HomeViewController: UIViewController {
  // MARK: - Properties
  lazy var cartButton = UIButton()
  lazy var menuButton = UIButton()
  lazy var dropDownLabel = UILabel()
  lazy var dropDownImage = UIImageView()
  lazy var dropDownView = UIView()
  lazy var searchBar = UITextField()
  lazy var tableView = UITableView()
  
  var dropDown: DropDown?

  private let viewModel: HomeViewModel

  // MARK: - LifeCycle
  init(viewModel: HomeViewModel) {
    self.viewModel = viewModel
    super.init(nibName: nil, bundle: nil)
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    configureBindings()
    configureViews()
    configureConstraints()
    setupView()
  }

  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    viewModel.getHomeData()
  }

  // MARK: - Helpers
  func setupView() {
    navigationController?.interactivePopGestureRecognizer?.isEnabled = false
    
    let dropDownGesture = UITapGestureRecognizer(target: self, action: #selector(openDropDown))
    dropDownView.addGestureRecognizer(dropDownGesture)
    
    setupDropDown()
  }

  func configureBindings() {
    viewModel.reloadTableViewClosure = { [weak self]() in
      self?.tableView.reloadData()
    }

    viewModel.activityIndicatorClosure = { [weak self] () in
      DispatchQueue.main.async {
        let isLoading = self?.viewModel.isLoading ?? false
        if isLoading == false {
          self?.view.stopActivityIndicator()
        } else {
          self?.view.startActivityIndicator()
        }
      }
    }

    viewModel.showAlertClosure = { [weak self] title, message, completionHandler in
      DispatchQueue.main.async {
        self?.showAlertOK(title: title, message: message, completionHandler: completionHandler)
      }
    }
  }
  
  func setupDropDown() {
    dropDown = DropDown()
    dropDown?.anchorView = dropDownView
    dropDown?.dataSource = viewModel.countriesData
    
    dropDown?.selectionAction = { (index: Int, item: String) in
      self.dropDownLabel.text = item
    }
    
  }
  
  // MARK: - Actions
  
  @objc func openDropDown() {
    print("Drop down")
    dropDown?.show()
  }
}

extension HomeViewController {
  func configureViews() {
    view.backgroundColor = .white

    cartButton = {
      let button = UIButton()
      button.setImage(UIImage(named: "cart"), for: .normal)
      button.translatesAutoresizingMaskIntoConstraints = false
      return button
    }()
    
    menuButton = {
      let button = UIButton()
      button.setImage(UIImage(named: "menu"), for: .normal)
      button.translatesAutoresizingMaskIntoConstraints = false
      return button
    }()
    
    dropDownLabel = {
      let label = UILabel()
      label.text = "India"
      label.textAlignment = .center
      label.font = UIFont.systemFont(ofSize: 15)
      label.translatesAutoresizingMaskIntoConstraints = false
      return label
    }()
    
    dropDownImage = {
      let imageView = UIImageView(image: UIImage(named: "down"))
      imageView.contentMode = .scaleAspectFit
      imageView.translatesAutoresizingMaskIntoConstraints = false
      return imageView
    }()
    
    dropDownView = {
      let view = UIView()
      view.translatesAutoresizingMaskIntoConstraints = false
      return view
    }()

    searchBar = {
      let textField = UITextField()
      textField.backgroundColor = .white
      textField.layer.cornerRadius = 22
      textField.layer.borderWidth = 1
      textField.layer.borderColor = UIColor.lightGray.cgColor
      textField.translatesAutoresizingMaskIntoConstraints = false
      return textField
    }()

    tableView = {
      let tableView = UITableView()
//      tableView.backgroundColor = #colorLiteral(red: 0.9148653254, green: 0.9148653254, blue: 0.9148653254, alpha: 1)
      tableView.delegate = self
      tableView.dataSource = self
      tableView.showsVerticalScrollIndicator = false
      tableView.separatorStyle = .none
      tableView.rowHeight = UITableView.automaticDimension
      tableView.register(BannerTableViewCell.self, forCellReuseIdentifier: "BannerTableViewCell")
      tableView.register(CategoryTableViewCell.self, forCellReuseIdentifier: "CategoryTableViewCell")
      tableView.register(SubCategoriesTableViewCell.self, forCellReuseIdentifier: "SubCategoriesTableViewCell")
      tableView.register(ProductsTableViewCell.self, forCellReuseIdentifier: "ProductsTableViewCell")
      tableView.isHidden = false
      tableView.keyboardDismissMode = .onDrag
      tableView.translatesAutoresizingMaskIntoConstraints = false
      return tableView
    }()
  }

  func configureConstraints() {
    view.addSubview(cartButton)
    view.addSubview(menuButton)
    view.addSubview(dropDownView)
    dropDownView.addSubview(dropDownLabel)
    dropDownView.addSubview(dropDownImage)
    view.addSubview(searchBar)
    view.addSubview(tableView)

    NSLayoutConstraint.activate([
      cartButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
      cartButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
      cartButton.heightAnchor.constraint(equalToConstant: 25),
      cartButton.widthAnchor.constraint(equalToConstant: 25),
      
      menuButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
      menuButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
      menuButton.heightAnchor.constraint(equalToConstant: 25),
      menuButton.widthAnchor.constraint(equalToConstant: 25),
      
      dropDownView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
      dropDownView.leadingAnchor.constraint(equalTo: menuButton.trailingAnchor, constant: 5),
      dropDownView.heightAnchor.constraint(equalToConstant: 25),
      dropDownView.widthAnchor.constraint(equalToConstant: 120),
      
      dropDownLabel.centerYAnchor.constraint(equalTo: dropDownView.centerYAnchor),
      dropDownLabel.leadingAnchor.constraint(equalTo: dropDownView.leadingAnchor, constant: 2),
      dropDownLabel.trailingAnchor.constraint(equalTo: dropDownImage.leadingAnchor, constant: 2),
      
      dropDownImage.centerYAnchor.constraint(equalTo: dropDownView.centerYAnchor),
      dropDownImage.trailingAnchor.constraint(equalTo: dropDownView.trailingAnchor, constant: -5),
      dropDownImage.heightAnchor.constraint(equalToConstant: 15),
      dropDownImage.widthAnchor.constraint(equalToConstant: 20),

      searchBar.topAnchor.constraint(equalTo: cartButton.bottomAnchor, constant: 10),
      searchBar.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
      searchBar.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
      searchBar.heightAnchor.constraint(equalToConstant: 44),

      tableView.topAnchor.constraint(equalTo: searchBar.bottomAnchor, constant: 5),
      tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
      tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
      tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
    ])
  }
}

extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
  func numberOfSections(in tableView: UITableView) -> Int {
    return viewModel.numberOfSectionsInTable
  }

  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    if viewModel.tableViewCellExpanded == section {
      return viewModel.numberOfRowsInSection(for: section, isExpanded: true)
    } else {
      return viewModel.numberOfRowsInSection(for: section, isExpanded: false)
    }
  }

  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let section = indexPath.section
    let row = indexPath.row
    switch section {
    case 0:
      let cell = tableView.dequeueReusableCell(
        withIdentifier: "BannerTableViewCell"
      ) as! BannerTableViewCell
      cell.setupData(viewModel: viewModel)
      return cell
    case viewModel.numberOfSectionsInTable - 2: // Featured
      let cell = tableView.dequeueReusableCell(
      withIdentifier: "ProductsTableViewCell"
    ) as! ProductsTableViewCell
      guard let data = viewModel.getSetHome?.data?.feturedProducts else { return cell }
      cell.setData(label: "Featured Product", data: data)
    return cell
    case viewModel.numberOfSectionsInTable - 1: // Recently
      let cell = tableView.dequeueReusableCell(
        withIdentifier: "ProductsTableViewCell"
      ) as! ProductsTableViewCell
      guard let data = viewModel.getSetHome?.data?.recentlyViewed else { return cell }
      cell.setData(label: "Recently Viewed", data: data)
      return cell
    default:
      if row == 0 {
        let cell = tableView.dequeueReusableCell(
          withIdentifier: "CategoryTableViewCell"
        ) as! CategoryTableViewCell
        guard let data = viewModel.getSetHome?.data?.categories?[section - 1] else { return UITableViewCell() }
        if viewModel.tableViewCellExpanded == section {
          cell.setData(data: data, isOpen: true)
        } else {
          cell.setData(data: data, isOpen: false)
        }
        return cell
      } else {
        let cell = tableView.dequeueReusableCell(
          withIdentifier: "SubCategoriesTableViewCell"
        ) as! SubCategoriesTableViewCell
        guard let data = viewModel.getSetHome?.data?.categories?[section - 1].subCategoryData else { return UITableViewCell() }
        cell.setData(data: data)
        return cell
      }
    }
  }

  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return viewModel.heightForTableViewSection(section: indexPath.section, row: indexPath.row)
  }
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    if viewModel.tableViewCellExpanded != indexPath.section {
      viewModel.tableViewCellExpanded = indexPath.section
    } else {
      viewModel.tableViewCellExpanded = 0
    }
    tableView.reloadData()
    tableView.scrollToRow(at: indexPath, at: .top, animated: true)
  }

}
