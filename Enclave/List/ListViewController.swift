//
//  ListViewController.swift
//  Enclave
//
//  Created by Zachary Rhodes on 6/17/20.
//  Copyright © 2020 zhrhodes. All rights reserved.
//

import UIKit

final class ListViewController: UIViewController {
  private lazy var coordinator = ListCoordinator(viewController: self)
  
  private let tableView = UITableView()
  private var interactor = ListViewInteractor()

  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = .primaryBackground
    title = "Notes"

    configureNavigationController()
    configureTableView()
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
  }
  
  private func configureNavigationController() {
    guard let navigationBar = navigationController?.navigationBar else { return }

    navigationBar.prefersLargeTitles = true
    
    let attributes: [NSAttributedString.Key: Any] = [NSAttributedString.Key.foregroundColor: UIColor.titleText,
                                                   NSAttributedString.Key.font: UIFont.customRegularFont(ofSize: 30) as Any]
    navigationBar.largeTitleTextAttributes = attributes
      
    let addButton = UIButton()
    addButton.layer.cornerRadius = 4
    addButton.backgroundColor = UIColor.randomAccent()
    addButton.translatesAutoresizingMaskIntoConstraints = false
    addButton.addTarget(self, action: #selector(addTapped), for: .touchUpInside)
    
    navigationBar.addSubview(addButton)
    
    let constraints = [
      addButton.rightAnchor.constraint(equalTo: navigationBar.rightAnchor, constant: -16),
      addButton.bottomAnchor.constraint(equalTo: navigationBar.bottomAnchor, constant: -12),
      addButton.heightAnchor.constraint(equalToConstant: 30),
      addButton.widthAnchor.constraint(equalToConstant: 30)
    ]
    
    NSLayoutConstraint.activate(constraints)
  }
  
  private func configureTableView() {
    tableView.register(ListItemTableCell.self, forCellReuseIdentifier: ListItemTableCell.id)
    view.addSubview(tableView)
    
    tableView.delegate = self
    tableView.dataSource = self
    tableView.backgroundColor = .primaryBackground
    tableView.translatesAutoresizingMaskIntoConstraints = false
    tableView.separatorStyle = .none
    tableView.tableFooterView = UIView()
    
    let constraints = [
      tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
      tableView.leftAnchor.constraint(equalTo: view.leftAnchor),
      tableView.rightAnchor.constraint(equalTo: view.rightAnchor),
      tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
    ]

    NSLayoutConstraint.activate(constraints)
  }
  
  @objc
  private func addTapped() {
    let newNote = interactor.addNote()
    coordinator.presentEditItem(with: newNote)
  }
  
  func updatedNote(_ note: Note) {
    guard let index = interactor.notes.firstIndex(where: { $0.id == note.id }) else { return }
    interactor.notes[index] = note
    if index == tableView.visibleCells.count {
      tableView.reloadData()
    } else {
      tableView.reloadRows(at: [IndexPath(row: index, section: 0)], with: .automatic)
    }
  }
}

extension ListViewController: UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return interactor.notes.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    guard let cell = tableView.dequeueReusableCell(withIdentifier: ListItemTableCell.id) as? ListItemTableCell else { return UITableViewCell() }
    let item = interactor.notes[indexPath.row]
    cell.configure(with: item)
    return cell
  }
  
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return ListItemTableCell.height
  }
}

extension ListViewController: UITableViewDelegate {
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    let item = interactor.notes[indexPath.row]
    coordinator.presentEditItem(with: item)
  }
}
