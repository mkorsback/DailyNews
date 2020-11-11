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

  override func viewDidLoad() {
    super.viewDidLoad()

    title = "Headlines"
    view.backgroundColor = .systemBackground

    let tableView = UITableView(frame: view.frame)
    tableView.estimatedRowHeight = 150
    tableView.rowHeight = UITableView.automaticDimension
    tableView.separatorStyle = .none
    view.addSubview(tableView)

    tableView.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      tableView.topAnchor.constraint(equalTo: view.topAnchor),
      tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
      tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
      tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
    ])
    tableView.register(HeadlineCell.self, forCellReuseIdentifier: HeadlineCell.reuseId)

    dataSource = DataSource(tableView: tableView, cellProvider: { tableView, indexPath, article -> UITableViewCell? in
      guard let cell = tableView.dequeueReusableCell(withIdentifier: HeadlineCell.reuseId, for: indexPath) as? HeadlineCell else {
        return UITableViewCell()
      }

//      cell.backgroundColor = indexPath.row % 2 == 0 ? UIColor.systemGray5 : UIColor.systemGray3
      cell.configure(with: self.articles[indexPath.row])
      return cell
    })

    tableView.dataSource = dataSource
    tableView.delegate = self

    NewsService.shared.fetchTopHeadlinesLocal { result in
      switch result {
      case .success(let articles):
        self.articles = articles
        var snapshot = Snapshot()
        snapshot.appendSections([0])
        snapshot.appendItems(articles)
        DispatchQueue.main.async {
          self.dataSource.apply(snapshot, animatingDifferences: true)
        }
      case .failure(let error):
        print(error)
      }
    }
//    NewsService.shared.fetchTopHeadlines { result in
//      print(result)
//    }

  }

  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    navigationController?.navigationBar.prefersLargeTitles = true
  }

}

extension HeadlinesViewController: UITableViewDelegate {
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    let articleView = ArticleWebView()
    articleView.urlString = articles[indexPath.row].url
    navigationController?.pushViewController(articleView, animated: true)
  }
}

import WebKit

class ArticleWebView: UIViewController {

  var urlString: String!

  override func viewDidLoad() {
    super.viewDidLoad()

    let webView = WKWebView(frame: view.frame)
    view.addSubview(webView)
    webView.load(URLRequest(url: URL(string: urlString)!))
  }

  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    navigationController?.navigationBar.prefersLargeTitles = false
  }
}
