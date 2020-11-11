//
//  ArticleCell.swift
//  DailyNews
//
//  Created by Mathias Korsbäck on 2020-11-10.
//

import UIKit

class ArticleCell: UITableViewCell {

  static var reuseId: String {
    String(describing: self)
  }

  private let headerImage: CachedImageView = {
    let imageView = CachedImageView()
    imageView.translatesAutoresizingMaskIntoConstraints = false
    imageView.contentMode = .scaleAspectFill
    imageView.clipsToBounds = true
    return imageView
  }()

  private let titleLabel: UILabel = {
    let label = UILabel()
    label.translatesAutoresizingMaskIntoConstraints = false
    label.font = UIFont.preferredFont(forTextStyle: .headline)
    label.numberOfLines = 0
    label.lineBreakMode = .byWordWrapping
    return label
  }()

  private let descriptionLabel: UILabel = {
    let label = UILabel()
    label.translatesAutoresizingMaskIntoConstraints = false
    label.font = UIFont.preferredFont(forTextStyle: .caption1)
    label.numberOfLines = 0
    label.lineBreakMode = .byWordWrapping
    return label
  }()

  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)

    contentView.addSubview(headerImage)
    contentView.addSubview(titleLabel)
    contentView.addSubview(descriptionLabel)

    NSLayoutConstraint.activate([
      headerImage.topAnchor.constraint(equalTo: contentView.topAnchor),
      headerImage.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
      headerImage.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
      headerImage.heightAnchor.constraint(equalToConstant: 200),

      titleLabel.topAnchor.constraint(equalTo: headerImage.bottomAnchor, constant: 8),
      titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
      titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),

      descriptionLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 4),
      descriptionLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
      descriptionLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
      descriptionLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
    ])
  }

  func configure(with article: Article) {
    titleLabel.text = article.title
    descriptionLabel.text = article.description
    if let urlToImage = article.urlToImage {
      headerImage.load(from: URL(string: urlToImage)!)
    }
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

}
