//
//  SourcesViewController.swift
//  DailyNews
//
//  Created by Mathias Korsbäck on 2020-11-14.
//

import UIKit

struct Source: Decodable, Hashable {
  let name: String
  let category: String
}

class SourcesViewController: UIViewController {

  typealias DataSource = UITableViewDiffableDataSource<String, Source>
  typealias Snapshot = NSDiffableDataSourceSnapshot<String, Source>

  var dataSource: DataSource!
  var sources: [Source] = []
  var categories: [String] = []

  override func viewDidLoad() {
    super.viewDidLoad()

    title = "Sources"
    view.backgroundColor = .systemBackground

    setupTableView()
    fetchSources()
  }

  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    navigationController?.navigationBar.prefersLargeTitles = true
  }

  private func setupTableView() {
    let tableView = UITableView(frame: view.frame)
    view.addSubview(tableView)

    tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cellId")

    dataSource = DataSource(tableView: tableView, cellProvider: { tableView, indexPath, source -> UITableViewCell? in
      let cell = tableView.dequeueReusableCell(withIdentifier: "cellId", for: indexPath)
      cell.textLabel?.text = source.name
      return cell
    })

    tableView.dataSource = dataSource
    tableView.delegate = self
  }

  private func applySnapshot() {
    for source in sources {
      if !categories.contains(source.category) {
        categories.append(source.category)
      }
    }
    print(categories)

    var snapshot = Snapshot()

    snapshot.appendSections(categories)

    for category in categories {
      let categorySources = sources.filter { $0.category == category }
      snapshot.appendItems(categorySources, toSection: category)
    }

    DispatchQueue.main.async {
      self.dataSource.apply(snapshot, animatingDifferences: true)
    }
  }

  private func fetchSources() {
    NewsService.shared.fetchSources { result in
      switch result {
      case .success(let sources):
        self.sources = sources
        self.applySnapshot()
      case .failure(let error):
        print(error)
      }
    }
  }
}

extension SourcesViewController: UITableViewDelegate {
  func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
    let titleView = UITableViewHeaderFooterView()
    titleView.textLabel?.text = categories[section].capitalized
    return titleView
  }
}
