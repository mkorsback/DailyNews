//
//  HeadlinesViewController.swift
//  DailyNews
//
//  Created by Mathias Korsbäck on 2020-11-08.
//

import UIKit

class HeadlinesViewController: UIViewController {

  typealias DataSource = UITableViewDiffableDataSource<Int, Article>
  typealias Snapshot = NSDiffableDataSourceSnapshot<Int, Article>

  var dataSource: DataSource!
  var articles: [Article] = []

  private let refreshControl = UIRefreshControl()

  // MARK: - Lifecycle methods

  override func viewDidLoad() {
    super.viewDidLoad()

    title = "Headlines"
    view.backgroundColor = .systemBackground

    let searchController = UISearchController()
    searchController.searchBar.delegate = self
    searchController.obscuresBackgroundDuringPresentation = false
    navigationItem.searchController = searchController
    navigationItem.hidesSearchBarWhenScrolling = true

    setupTableView()
    fetchHeadlines()
  }

  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    navigationController?.navigationBar.prefersLargeTitles = true
  }

  // MARK: - Private helper methods

  private func setupTableView() {
    let tableView = UITableView(frame: view.frame)
    view.addSubview(tableView)

    tableView.estimatedRowHeight = 150
    tableView.rowHeight = UITableView.automaticDimension
    tableView.separatorStyle = .none
    tableView.register(ArticleCell.self, forCellReuseIdentifier: ArticleCell.reuseId)

    dataSource = DataSource(tableView: tableView, cellProvider: { tableView, indexPath, article -> UITableViewCell? in
      guard let cell = tableView.dequeueReusableCell(withIdentifier: ArticleCell.reuseId, for: indexPath) as? ArticleCell else {
        return UITableViewCell()
      }

//      cell.configure(with: self.articles[indexPath.row])
      cell.configure(with: article)
      return cell
    })

    dataSource.defaultRowAnimation = .fade

    tableView.dataSource = dataSource
    tableView.delegate = self

    refreshControl.addTarget(self, action: #selector(refresh), for: .valueChanged)
    tableView.refreshControl = refreshControl
  }

  @objc private func refresh() {
    fetchHeadlines()
    refreshControl.endRefreshing()
  }

  private func applySnapshot() {
    var snapshot = Snapshot()
    snapshot.appendSections([0])
    snapshot.appendItems(articles)
    DispatchQueue.main.async {
      self.dataSource.apply(snapshot, animatingDifferences: true)
    }
  }

  private func fetchHeadlines() {
    NewsService.shared.fetchTopHeadlines { result in
      switch result {
      case .success(let articles):
        self.articles = articles
        self.applySnapshot()
      case .failure(let error):
        print(error)
      }
    }
  }

}

// MARK: - UITableViewDelegate extension

extension HeadlinesViewController: UITableViewDelegate {
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    let articleWebView = ArticleWebViewController()
    articleWebView.urlString = articles[indexPath.row].url
    navigationController?.pushViewController(articleWebView, animated: true)
  }
}

// MARK: - UISearchBarDelegate extension

extension HeadlinesViewController: UISearchBarDelegate {
  func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
    guard let searchText = searchBar.text else { return }
    NewsService.shared.search(for: searchText) { result in
      switch result {
      case .success(let articles):
        self.articles = articles
        DispatchQueue.main.async {
          self.applySnapshot()
        }
      case .failure(let error):
        print(error)
      }
    }
  }
}
