//
//  BookListViewCell.swift
//  BookSearcherApp
//
//  Created by 김민성 on 2022/11/09.
//

import UIKit

import RxSwift

class BookListViewCell: UITableViewCell {

  // MARK: Views

  let bookImageView = UIImageView()
  let bookInfoStackView = UIStackView()
  private var contentsViews = [ContentsLabel]()

  // MARK: Properties

  static let identifier = "BookListViewCell"
  private let viewModel: BookListViewCellViewModelLogic
  private var disposeBag = DisposeBag()

  // MARK: LifeCycles

  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    self.viewModel = BookListViewCellViewModel()
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
    self.bookImageView.image = UIImage(systemName: "book")
    self.disposeBag = DisposeBag()
  }

  private func configure() {
    self.accessoryType = .disclosureIndicator
    self.backgroundColor = .white
    self.selectionStyle = .none
  }

  private func attribute() {
    self.bookImageView.do {
      $0.layer.masksToBounds = true
      $0.contentMode = .scaleAspectFit
      $0.tintColor = .black
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

    CellContentType.allCases.forEach {
      let contentsView = $0.contentsView
      self.bookInfoStackView.addArrangedSubview(contentsView)
      self.contentsViews.append(contentsView)
    }
  }

  func bind(item: BookListCellData) {
    Observable<String?>.create { observer in
      observer.onNext(item.thumbnailURL)
      observer.onCompleted()
      return Disposables.create()
    }
    .subscribe(on: ConcurrentDispatchQueueScheduler.init(qos: .background))
      .bind(to: viewModel.cellImageURL)
      .disposed(by: self.disposeBag)

    viewModel.cellImageData
      .observe(on: MainScheduler.asyncInstance)
      .asDriver(onErrorJustReturn: UIImage())
      .drive(self.bookImageView.rx.image)
      .disposed(by: self.disposeBag)

    self.setData(item: item)
  }

  func setData(item: BookListCellData) {

    CellContentType.allCases.forEach { type in
      let contentsView = self.contentsViews[type.rawValue]

      var applyValue: String

      switch type {
      case .title:
        applyValue = item.title ?? "No Information"
        contentsView.text = applyValue
      case .authors:
        applyValue = item.authors?.joined(separator: ", ") ?? "No Information"
        contentsView.text = applyValue
      case .publishedDate:
        applyValue = item.publishedDate ?? "No Information"
        contentsView.text = applyValue
      }
    }
  }
}
