//
//  BookDetailViewController.swift
//  BookSearcherApp
//
//  Created by 김민성 on 2022/11/10.
//

import UIKit

import RxSwift
import SnapKit


class BookDetailViewController: UIViewController {

  // MARK: Properties

  private let viewModel: BookDetailViewModelLogic
  private let disposeBag = DisposeBag()

  // MARK: Views

  private let bookImageView = UIImageView()
  private let basicInformationContentView = BasicInformationContentView()

  init(viewModel: BookDetailViewModelLogic) {
    self.viewModel = viewModel
    super.init(nibName: nil, bundle: nil)

    self.bind()
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  override func viewDidLoad() {
    super.viewDidLoad()

    self.configure()
    self.attribute()
    self.layout()
  }

  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)

    self.showLoadingView()
  }

  private func configure() {
    self.view.backgroundColor = .white
  }

  private func attribute() {
    self.bookImageView.image = UIImage(systemName: "book")!
  }

  private func layout() {
    [
      self.bookImageView,
      self.basicInformationContentView
    ].forEach {
      self.view.addSubview($0)
    }

    self.bookImageView.snp.makeConstraints {
      $0.top.leading.trailing.equalTo(self.view.safeAreaLayoutGuide)
      $0.height.equalTo(self.bookImageView.snp.width)
    }

    self.basicInformationContentView.snp.makeConstraints {
      $0.top.equalTo(self.bookImageView.snp.bottom)
      $0.leading.trailing.bottom.equalToSuperview()
    }
  }

  private func bind() {
    self.viewModel.imageData
      .asDriver(onErrorDriveWith: .never())
      .drive(self.bookImageView.rx.image)
      .disposed(by: self.disposeBag)

    self.viewModel.dismissLoadingView
      .asDriver(onErrorJustReturn: false)
      .filter { $0 }
      .drive { [weak self] _ in
        guard let self = self else { return }
        self.dismissLoadingView()
      }
      .disposed(by: self.disposeBag)

    self.viewModel.detailViewData
      .bind { [weak self] in
        guard let self = self else { return }
        self.basicInformationContentView.setData(data: $0)
      }
      .disposed(by: self.disposeBag)
  }
}
