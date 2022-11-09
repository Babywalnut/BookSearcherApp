//
//  BookListHeaderView.swift
//  BookSearcherApp
//
//  Created by 김민성 on 2022/11/09.
//

import UIKit

import SnapKit
import Then

final class BookListHeaderView: UITableViewHeaderFooterView {

  // MARK: Properties

  let resultLabel = UILabel()

  // MARK: LifeCycles

  override init(reuseIdentifier: String?) {
    super.init(reuseIdentifier: reuseIdentifier)

    self.configure()
    self.attribute()
    self.layout()
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  private func configure() {
    self.backgroundColor = .systemGray3
  }

  private func attribute() {
    self.resultLabel.do {
      $0.textColor = .black
      $0.font = .systemFont(ofSize: 16, weight: .regular)
      $0.text = "전체항목 (0)"
    }
  }

  private func layout() {
    self.addSubview(self.resultLabel)

    self.resultLabel.snp.makeConstraints {
      $0.leading.equalToSuperview().inset(15)
      $0.top.bottom.equalToSuperview().inset(2)
    }
  }
}
