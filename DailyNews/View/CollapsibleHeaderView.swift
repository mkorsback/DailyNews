//
//  CollapsableHeaderView.swift
//  DailyNews
//
//  Created by Mathias Korsbäck on 2020-11-15.
//

import UIKit

protocol CollapsibleHeaderDelegate: class {
  func toggleSection(_ section: Int)
}

class CollapsibleHeaderView: UITableViewHeaderFooterView {

  static var reuseId: String {
    String(describing: self)
  }

  weak var delegate: CollapsibleHeaderDelegate?
  var sectionId = 0

  let chevronImageView: UIImageView = {
    let imageView = UIImageView()
    let image = UIImage(systemName: "chevron.right")!
    imageView.image = image
    imageView.translatesAutoresizingMaskIntoConstraints = false
    return imageView
  }()

  let nameLabel: UILabel = {
    let label = UILabel()
    label.translatesAutoresizingMaskIntoConstraints = false
    label.font = UIFont.systemFont(ofSize: 22)
    return label
  }()

  override init(reuseIdentifier: String?) {
    super.init(reuseIdentifier: reuseIdentifier)

    setupUI()

    let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tapped))
    addGestureRecognizer(tapGesture)
  }

  private func setupUI() {
    contentView.addSubview(nameLabel)
    contentView.addSubview(chevronImageView)

    NSLayoutConstraint.activate([
      chevronImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
      chevronImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),

      nameLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
      nameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 30),
    ])
  }

  func configure(with section: Section, forSection sectionId: Int) {
    self.sectionId = sectionId
    nameLabel.text = section.name.capitalized
    chevronImageView.image = UIImage(systemName: (section.collapsed ? "chevron.right" : "chevron.down"))!
  }

  @objc private func tapped(_ sender: UITapGestureRecognizer) {
    guard let header = sender.view as? CollapsibleHeaderView else { return }
    delegate?.toggleSection(header.sectionId)
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

}
