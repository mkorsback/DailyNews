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
    view.addSubview(tableView)

    tableView.estimatedRowHeight = 150
    tableView.rowHeight = UITableView.automaticDimension
    tableView.separatorStyle = .none
    tableView.register(ArticleCell.self, forCellReuseIdentifier: ArticleCell.reuseId)

    dataSource = DataSource(tableView: tableView, cellProvider: { tableView, indexPath, article -> UITableViewCell? in
      guard let cell = tableView.dequeueReusableCell(withIdentifier: ArticleCell.reuseId, for: indexPath) as? ArticleCell else {
        return UITableViewCell()
      }

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
          self.dataSource.apply(snapshot, animatingDifferences: false)
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
    let articleWebView = ArticleWebView()
    articleWebView.urlString = articles[indexPath.row].url
    navigationController?.pushViewController(articleWebView, animated: true)
  }

}
