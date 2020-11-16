//
//  SourceDetailViewController.swift
//  DailyNews
//
//  Created by Mathias Korsbäck on 2020-11-15.
//

import UIKit

class SourceDetailViewController: UIViewController {

  let nameLabel: UILabel = {
    let label = UILabel()
    label.translatesAutoresizingMaskIntoConstraints = false
    label.font = UIFont.preferredFont(forTextStyle: .largeTitle)
    return label
  }()

  let descriptionLabel: UILabel = {
    let label = UILabel()
    label.translatesAutoresizingMaskIntoConstraints = false
    label.font = UIFont.preferredFont(forTextStyle: .body)
    label.numberOfLines = 0
    label.lineBreakMode = .byWordWrapping
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

  let urlLabel: UILabel = {
    let label = UILabel()
    label.translatesAutoresizingMaskIntoConstraints = false
    label.font = UIFont.preferredFont(forTextStyle: .callout)
    return label
  }()

  let separatorView: UIView = {
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

  override func viewDidLoad() {
    super.viewDidLoad()

    view.backgroundColor = .systemBackground
    view.addSubview(nameLabel)
    view.addSubview(descriptionLabel)
    view.addSubview(flagLabel)
    view.addSubview(languageLabel)
//    view.addSubview(urlLabel)
    view.addSubview(separatorView)
    view.addSubview(headLinesLabel)

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

//      urlLabel.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 16),
//      urlLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),

      separatorView.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 12),
      separatorView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 60),
      separatorView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -60),
      separatorView.heightAnchor.constraint(equalToConstant: 1),

      headLinesLabel.topAnchor.constraint(equalTo: separatorView.bottomAnchor, constant: 16),
      headLinesLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
    ])
  }

  func configure(with source: Source) {
    nameLabel.text = source.name
    flagLabel.text = flag(country: source.country)
    print(source.country, flag(country: source.country), source.language)
    languageLabel.text = source.language
    descriptionLabel.text = source.description
//    descriptionLabel.hyphenate()
    urlLabel.text = source.url
  }

  private func flag(country: String) -> String {
    let base: UInt32 = 127397
    var s = ""
    for v in (country == "zh" ? "cn" : country).uppercased().unicodeScalars {
      s.unicodeScalars.append(UnicodeScalar(base + v.value)!)
    }
    return s
  }

}

extension UILabel {
  func hyphenate() {
    let paragraphStyle = NSMutableParagraphStyle()
    let text = NSMutableAttributedString(attributedString: self.attributedText!)
    paragraphStyle.hyphenationFactor = 1.0
    text.addAttribute(.paragraphStyle, value: paragraphStyle, range: NSRange(0..<text.length))
    self.attributedText = text
  }
}
