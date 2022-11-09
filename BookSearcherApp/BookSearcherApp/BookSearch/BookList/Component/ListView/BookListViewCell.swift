//
//  BookListViewCell.swift
//  BookSearcherApp
//
//  Created by 김민성 on 2022/11/09.
//

import UIKit

class BookListViewCell: UITableViewCell {

  // MARK: Views

  let bookImageView = UIImageView()
  let bookInfoStackView = UIStackView()

  // MARK: Properties

  static let identifier = "BookListViewCell"

  // MARK: LifeCycles

  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)

    self.configure()
    self.attribute()
    self.layout()
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  override func prepareForReuse() {
    super.prepareForReuse()
    self.bookImageView.image = nil
  }

  private func configure() {
    self.accessoryType = .disclosureIndicator
    self.backgroundColor = .white
  }

  private func attribute() {
    self.bookImageView.do {
      $0.layer.masksToBounds = true
      $0.contentMode = .scaleAspectFit
    }

    self.bookInfoStackView.do {
      $0.axis = .vertical
      $0.alignment = .leading
      $0.distribution = .fillProportionally
      $0.spacing = 10
    }
  }

  private func layout() {
    [
      self.bookImageView,
      self.bookInfoStackView
    ].forEach {
      self.contentView.addSubview($0)
    }

    self.bookImageView.snp.makeConstraints {
      $0.leading.top.bottom.equalToSuperview().inset(10)
      $0.trailing.equalTo(self.bookInfoStackView.snp.leading).offset(-10)
      $0.width.equalToSuperview().dividedBy(4)
    }

    self.bookInfoStackView.snp.makeConstraints {
      $0.leading.equalTo(self.bookImageView.snp.trailing).offset(10)
      $0.trailing.equalToSuperview().inset(10)
      $0.top.bottom.equalTo(self.bookImageView)
    }

    ContentType.allCases.forEach {
      self.bookInfoStackView.addArrangedSubview($0.contentsView)
    }
  }
}

enum ContentType: Int, CaseIterable {

  case title
  case description
  case publishedDate

  var contentsView: ContentsLabel {
    switch self {
    case .title:
      return ContentsLabel(textColor: .black, fontSize: 20, weight: .bold)
    case .description:
      return ContentsLabel(textColor: .gray, fontSize: 15, weight: .regular)
    case .publishedDate:
      return ContentsLabel(textColor: .gray, fontSize: 12, weight: .regular)
    }

  }
}
