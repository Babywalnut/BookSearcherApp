//
//  BookListSearchBar.swift
//  BookSearcherApp
//
//  Created by 김민성 on 2022/11/09.
//

import UIKit

import SnapKit
import Then

final class BookListSearchBar: UISearchBar {

  // MARK: LifeCycles

  override init(frame: CGRect) {
    super.init(frame: frame)

    self.configure()
    self.layout()
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  private func configure() {
    self.searchTextField.do {
      $0.layer.borderWidth = 2
      $0.layer.borderColor = UIColor.black.cgColor
      $0.layer.cornerRadius = 10
      $0.backgroundColor = .systemBackground
      $0.placeholder = "책 정보 입력"
    }
  }

  private func layout() {
    self.searchTextField.snp.makeConstraints {
      $0.leading.trailing.equalToSuperview().inset(12)
      $0.centerY.equalToSuperview()
    }
  }
}
