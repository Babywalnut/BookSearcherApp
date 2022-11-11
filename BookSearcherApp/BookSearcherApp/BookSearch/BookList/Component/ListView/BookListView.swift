//
//  BookListView.swift
//  BookSearcherApp
//
//  Created by 김민성 on 2022/11/09.
//

import UIKit

class BookListView: UITableView {

  // MARK: Views

  let bookListHeaderView = BookListHeaderView()

  // MARK: LifeCycles

  override init(frame: CGRect, style: UITableView.Style) {
    super.init(frame: frame, style: style)

    self.configure()
    self.layout()
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  private func configure() {
    self.register(BookListViewCell.self, forCellReuseIdentifier: BookListViewCell.identifier)
    self.separatorStyle = .singleLine
  }

  private func layout() {
    self.tableHeaderView = self.bookListHeaderView
    
    self.bookListHeaderView.snp.makeConstraints {
      $0.leading.top.trailing.equalToSuperview()
      $0.height.equalToSuperview().dividedBy(17)
    }
  }
}
