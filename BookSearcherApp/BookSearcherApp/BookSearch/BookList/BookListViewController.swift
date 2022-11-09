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

  // MARK: LifeCycles

  override func viewDidLoad() {
    super.viewDidLoad()

    self.configure()
  }

  private func configure() {
    self.view.backgroundColor = .white
    self.navigationItem.titleView = bookListSearchBar
  }
}
