//
//  SourceDetailViewController.swift
//  DailyNews
//
//  Created by Mathias Korsbäck on 2020-11-15.
//

import UIKit

class SourceDetailViewController: UIViewController {

  // MARK: - Properties

  let nameLabel: UILabel = {
    let label = UILabel()
    label.translatesAutoresizingMaskIntoConstraints = false
    label.font = UIFont.preferredFont(forTextStyle: .largeTitle)
    return label
  }()

  let flagLabel: UILabel = {
    let label = UILabel()
    label.translatesAutoresizingMaskIntoConstraints = false
    label.backgroundColor = .systemGray5
    label.layer.cornerRadius = 15
    label.layer.masksToBounds = true
    label.font = UIFont.systemFont(ofSize: 32)
    label.textAlignment = .center
    return label
  }()

  let languageLabel: UILabel = {
    let label = UILabel()
    label.translatesAutoresizingMaskIntoConstraints = false
    label.backgroundColor = .systemGray6
    label.layer.cornerRadius = 15
    label.layer.masksToBounds = true
    label.font = UIFont.systemFont(ofSize: 18)
    label.textAlignment = .center
    return label
  }()

  let descriptionLabel: UILabel = {
    let label = UILabel()
    label.translatesAutoresizingMaskIntoConstraints = false
    label.font = UIFont.preferredFont(forTextStyle: .body)
    label.numberOfLines = 0
    label.lineBreakMode = .byWordWrapping
    label.textAlignment = .justified
    return label
  }()

  let topSeparatorView: UIView = {
    let view = UIView()
    view.translatesAutoresizingMaskIntoConstraints = false
    view.backgroundColor = .darkGray
    return view
  }()

  let bottomSeparatorView: UIView = {
    let view = UIView()
    view.translatesAutoresizingMaskIntoConstraints = false
    view.backgroundColor = .darkGray
    return view
  }()

  let headLinesLabel: UILabel = {
    let label = UILabel()
    label.translatesAutoresizingMaskIntoConstraints = false
    label.font = UIFont.preferredFont(forTextStyle: .title1)
    label.text = "Headlines"
    return label
  }()

  let headlinesTableView: UITableView = {
    let tableView = UITableView()
    tableView.translatesAutoresizingMaskIntoConstraints = false
    return tableView
  }()

  var sourceId: String?
  var articles: [Article] = []

  private let refreshControl = UIRefreshControl()

  // MARK: - Lifecycle

  override func viewDidLoad() {
    super.viewDidLoad()

    refreshControl.addTarget(self, action: #selector(refresh), for: .valueChanged)
    headlinesTableView.refreshControl = refreshControl
    headlinesTableView.estimatedRowHeight = 150
    headlinesTableView.rowHeight = UITableView.automaticDimension
    headlinesTableView.separatorStyle = .none
    headlinesTableView.register(ArticleCell.self, forCellReuseIdentifier: ArticleCell.reuseId)
    headlinesTableView.dataSource = self
    headlinesTableView.delegate = self

    setupUI()
    fetchHeadlines()
  }

  // MARK: - Helper methods

  func configure(with source: Source) {
    sourceId = source.id
    nameLabel.text = source.name
    flagLabel.text = flag(country: source.country)
    languageLabel.text = source.language
    descriptionLabel.text = source.description
//    descriptionLabel.hyphenate()
  }

  // MARK: - Private helper methods

  @objc private func refresh() {
    fetchHeadlines()
    refreshControl.endRefreshing()
  }

  private func setupUI() {
    view.backgroundColor = .systemBackground
    view.addSubview(nameLabel)
    view.addSubview(descriptionLabel)
    view.addSubview(flagLabel)
    view.addSubview(languageLabel)
    view.addSubview(topSeparatorView)
    view.addSubview(headLinesLabel)
    view.addSubview(bottomSeparatorView)
    view.addSubview(headlinesTableView)

    NSLayoutConstraint.activate([
      nameLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: -45),
      nameLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),

      flagLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 8),
      flagLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: -40),
      flagLabel.widthAnchor.constraint(equalToConstant: 48),
      flagLabel.heightAnchor.constraint(equalToConstant: 48),

      languageLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 8),
      languageLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 40),
      languageLabel.widthAnchor.constraint(equalToConstant: 48),
      languageLabel.heightAnchor.constraint(equalToConstant: 48),

      descriptionLabel.topAnchor.constraint(equalTo: flagLabel.bottomAnchor, constant: 16),
      descriptionLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
      descriptionLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),

      topSeparatorView.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 16),
      topSeparatorView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 70),
      topSeparatorView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -70),
      topSeparatorView.heightAnchor.constraint(equalToConstant: 1),

      headLinesLabel.topAnchor.constraint(equalTo: topSeparatorView.bottomAnchor, constant: 8),
      headLinesLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),

      bottomSeparatorView.topAnchor.constraint(equalTo: headLinesLabel.bottomAnchor, constant: 8),
      bottomSeparatorView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 70),
      bottomSeparatorView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -70),
      bottomSeparatorView.heightAnchor.constraint(equalToConstant: 1),

      headlinesTableView.topAnchor.constraint(equalTo: bottomSeparatorView.bottomAnchor, constant: 16),
      headlinesTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
      headlinesTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
      headlinesTableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
    ])
  }

  private func fetchHeadlines() {
    NewsService.shared.fetchTopHeadlines(for: sourceId!) { result in
      switch result {
      case .success(let articles):
        self.articles = articles
        DispatchQueue.main.async {
          self.headlinesTableView.reloadData()
        }
      case .failure(let error):
        print(error)
      }
    }
  }

  private func flag(country: String) -> String {
    let base: UInt32 = 127397
    var flagString = ""
    // handle zh/cn due to newsapi.org delivering incorrect country code for China
    for scalarView in (country == "zh" ? "cn" : country).uppercased().unicodeScalars {
      flagString.unicodeScalars.append(UnicodeScalar(base + scalarView.value)!)
    }
    return flagString
  }

}

// MARK: - UITableViewDatasource, UITableViewDelegate extension

extension SourceDetailViewController: UITableViewDataSource, UITableViewDelegate {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return articles.count
  }

  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    guard let cell = tableView.dequeueReusableCell(withIdentifier: ArticleCell.reuseId, for: indexPath) as? ArticleCell else {
      return UITableViewCell()
    }

    cell.configure(with: articles[indexPath.row])
    return cell
  }

  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    let articleWebView = ArticleWebViewController()
    articleWebView.urlString = articles[indexPath.row].url
    navigationController?.pushViewController(articleWebView, animated: true)
  }

}

// MARK: - UILabel extension

extension UILabel {
  func hyphenate() {
    let paragraphStyle = NSMutableParagraphStyle()
    let text = NSMutableAttributedString(attributedString: self.attributedText!)
    paragraphStyle.hyphenationFactor = 1.0
    text.addAttribute(.paragraphStyle, value: paragraphStyle, range: NSRange(0..<text.length))
    self.attributedText = text
  }
}
