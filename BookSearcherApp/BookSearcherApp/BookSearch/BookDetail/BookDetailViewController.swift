//
//  BookDetailViewController.swift
//  BookSearcherApp
//
//  Created by 김민성 on 2022/11/10.
//

import UIKit

class BookDetailViewController: UIViewController {

  private let viewModel: BookDetailViewModel

  init(viewModel: BookDetailViewModel) {
    self.viewModel = viewModel
    super.init(nibName: nil, bundle: nil)
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  override func viewDidLoad() {
    super.viewDidLoad()

    self.configure()
  }

  private func configure() {
    self.view.backgroundColor = .white
  }
}
