//
//  BookListViewController.swift
//  BookSearcherApp
//
//  Created by 김민성 on 2022/11/09.
//

import RxSwift
import SnapKit
import Then

class BookListViewController: UIViewController {

  // MARK: Views

  private let bookListSearchBar = BookListSearchBar()
  private let bookListView = BookListView()

  // MARK: LifeCycles

  override func viewDidLoad() {
    super.viewDidLoad()

    self.configure()
    self.layout()
  }

  private func configure() {
    self.view.backgroundColor = .white
  }

  private func layout() {
    self.navigationItem.titleView = bookListSearchBar
    self.view.addSubview(self.bookListView)

    self.bookListView.snp.makeConstraints {
      $0.leading.trailing.bottom.equalToSuperview()
      $0.top.equalTo(self.view.safeAreaLayoutGuide)
    }
  }
}
