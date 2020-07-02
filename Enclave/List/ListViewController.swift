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
  
  private func configureNavigationController() {
    guard let navigationBar = navigationController?.navigationBar else { return }

    navigationBar.prefersLargeTitles = true
    
    let attributes: [NSAttributedString.Key: Any] = [NSAttributedString.Key.foregroundColor: UIColor.titleText,
                                                   NSAttributedString.Key.font: UIFont.customRegularFont(ofSize: 30) as Any]
    navigationBar.largeTitleTextAttributes = attributes
      
    let addButton = UIButton()
    addButton.layer.cornerRadius = 4
    let image = UIImage(named: "Compose")?.withRenderingMode(.alwaysTemplate)
    addButton.setImage(image, for: .normal)
    addButton.tintColor = .titleText
    addButton.translatesAutoresizingMaskIntoConstraints = false
    addButton.addTarget(self, action: #selector(addTapped), for: .touchUpInside)
    
    navigationBar.addSubview(addButton)
    
    let constraints = [
      addButton.rightAnchor.constraint(equalTo: navigationBar.rightAnchor, constant: -16),
      addButton.bottomAnchor.constraint(equalTo: navigationBar.bottomAnchor, constant: -12),
      addButton.heightAnchor.constraint(equalToConstant: 25),
      addButton.widthAnchor.constraint(equalToConstant: 25)
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
    coordinator.presentEditItem(with: Note())
  }
  
  func updatedNote(_ note: Note) {
    var existingIndex = interactor.notes.firstIndex(where: { $0.id == note.id })
    let updatingExising = existingIndex != nil
    if updatingExising {
      interactor.notes[existingIndex!] = note
    } else {
      interactor.notes.append(note)
      existingIndex = interactor.notes.endIndex.advanced(by: -1)
    }

    if updatingExising {
      tableView.moveRow(at: IndexPath(row: existingIndex!, section: 0), to: IndexPath(row: 0, section: 0))
      tableView.reloadRows(at: [IndexPath(row: 0, section: 0)], with: .automatic)
    } else {
      tableView.reloadData()
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
  
  func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
    let deleteAction = UIContextualAction(style: .destructive, title: "Delete") { [weak self] (_, _, _) in
      self?.interactor.deleteNote(at: indexPath.row)
      tableView.deleteRows(at: [indexPath], with: .automatic)
    }

    let image = UIImage(named: "Delete")?.withTintColor(.titleText)
    deleteAction.image = image
    deleteAction.backgroundColor = .primaryBackground
    return UISwipeActionsConfiguration(actions: [deleteAction])
  }
}
