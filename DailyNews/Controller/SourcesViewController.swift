//
//  SourcesViewController.swift
//  DailyNews
//
//  Created by Mathias Korsbäck on 2020-11-14.
//

import UIKit

struct Section: Hashable {
  let name: String
  var collapsed: Bool
}

class SourcesViewController: UIViewController {

  typealias DataSource = UITableViewDiffableDataSource<Section, Source>
  typealias Snapshot = NSDiffableDataSourceSnapshot<Section, Source>

  // MARK: - Properties

  var dataSource: DataSource!
  var sources: [Source] = []
  var sections: [Section] = []

  // MARK: - Lifecycle

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

  // MARK: - Private helper methods

  private func setupTableView() {
    let tableView = UITableView(frame: view.frame)
    view.addSubview(tableView)

    tableView.estimatedRowHeight = 48.0
    tableView.rowHeight = UITableView.automaticDimension
    tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cellId")

    dataSource = DataSource(tableView: tableView, cellProvider: { tableView, indexPath, source -> UITableViewCell? in
      let cell = tableView.dequeueReusableCell(withIdentifier: "cellId", for: indexPath)
      cell.accessoryType = .disclosureIndicator
      cell.textLabel?.text = source.name
      cell.selectionStyle = .none
      return cell
    })

    dataSource.defaultRowAnimation = .fade
    tableView.dataSource = dataSource
    tableView.delegate = self
    tableView.tableFooterView = UIView()
  }

  private func applySnapshot() {
    var snapshot = Snapshot()

    snapshot.appendSections(sections)

    for category in sections where !category.collapsed {
//      if !category.collapsed {
      let sourcesForCategory = sources.filter { $0.category == category.name }
      snapshot.appendItems(sourcesForCategory, toSection: category)
//      }
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
        for source in sources {
          if self.sections.filter({ $0.name == source.category }).isEmpty {
            self.sections.append(Section(name: source.category, collapsed: true))
          }
        }
        self.applySnapshot()
      case .failure(let error):
        print(error)
      }
    }
  }

}

// MARK: - UITableViewDelegate extension

extension SourcesViewController: UITableViewDelegate {

  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    let sourceDetailVC = SourceDetailViewController()
    let source = sources.filter { $0.category == sections[indexPath.section].name }[indexPath.row]
    sourceDetailVC.configure(with: source)
    navigationController?.pushViewController(sourceDetailVC, animated: true)
  }

  func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
    let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: CollapsibleHeaderView.reuseId)
      as? CollapsibleHeaderView ?? CollapsibleHeaderView(reuseIdentifier: CollapsibleHeaderView.reuseId)
    headerView.configure(with: sections[section], forSection: section)
    headerView.delegate = self
    return headerView
  }

  func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
    return 48
  }

}

// MARK: - CollapsibleHeaderDelegate extension

extension SourcesViewController: CollapsibleHeaderDelegate {

  func toggleSection(_ section: Int) {
    sections[section].collapsed.toggle()
    applySnapshot()
  }

}
