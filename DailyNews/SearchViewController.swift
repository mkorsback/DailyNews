//
//  SearchViewController.swift
//  DailyNews
//
//  Created by Mathias Korsbäck on 2020-11-11.
//

import UIKit

class SearchViewController: UIViewController {

  var tableView: UITableView!
  var articles: [Article] = []

  override func viewDidLoad() {
    super.viewDidLoad()

    view.backgroundColor = .systemBackground
    navigationItem.title = "Search"

    let searchController = UISearchController(searchResultsController: nil)
    searchController.searchBar.delegate = self
    searchController.obscuresBackgroundDuringPresentation = false
    navigationItem.searchController = searchController

    tableView = UITableView(frame: view.frame)
    view.addSubview(tableView)

    tableView.separatorStyle = .none
    tableView.register(ArticleCell.self, forCellReuseIdentifier: ArticleCell.reuseId)

    tableView.dataSource = self
    tableView.delegate = self
  }

}

// MARK: - UISearchBarDelegate extension

extension SearchViewController: UISearchBarDelegate {
  func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
    guard let searchText = searchBar.text else { return }
    NewsService.shared.search(for: searchText) { result in
      switch result {
      case .success(let articles):
        self.articles = articles
        DispatchQueue.main.async {
          self.tableView?.reloadData()
        }
      case .failure(let error):
        print(error)
      }
    }
  }
}

// MARK: - UITableViewDataSource extension

extension SearchViewController: UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    articles.count
  }

  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    guard let cell = tableView.dequeueReusableCell(withIdentifier: ArticleCell.reuseId, for: indexPath) as? ArticleCell else {
      print("cell is bad")
      return UITableViewCell()
    }
    cell.configure(with: articles[indexPath.row])
    return cell
  }
}

// MARK: - UITableViewDelegate extension

extension SearchViewController: UITableViewDelegate {
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    let articleWebView = ArticleWebView()
    articleWebView.urlString = articles[indexPath.row].url
    navigationController?.pushViewController(articleWebView, animated: true)
  }

}
