//
//  BookListViewModel.swift
//  BookSearcherApp
//
//  Created by 김민성 on 2022/11/09.
//

import RxSwift
import RxCocoa

protocol BookListViewModelLogic {
  var inputText: PublishRelay<String> { get }
  var pageNumber: BehaviorRelay<Int> { get }
  var scrollToRequest: PublishRelay<Bool> { get }

  var bookListCellSection: BehaviorRelay<[BookListCellSection]> { get set }
  var bookListHeaderText: PublishRelay<String> { get set }
  var showLoadingView: PublishRelay<Bool> { get set }
  var dismissLoadingView: PublishRelay<Bool> { get set }
}

class BookListViewModel: BookListViewModelLogic {

  // MARK: - Properties

  var disposeBag = DisposeBag()

  // MARK: Properties(Input)

  var inputText: PublishRelay<String>
  var pageNumber: BehaviorRelay<Int>
  var scrollToRequest: PublishRelay<Bool>

  // MARK: Propertie(Output)

  var bookListCellSection = BehaviorRelay<[BookListCellSection]>(value: [])
  var bookListHeaderText: PublishRelay<String>
  var showLoadingView: PublishRelay<Bool>
  var dismissLoadingView: PublishRelay<Bool>

  // MARK: - Initializer

  init(useCase: BookSearchUseCase) {
    self.inputText = PublishRelay<String>()
    self.pageNumber = BehaviorRelay<Int>(value: 1)
    self.scrollToRequest = PublishRelay<Bool>()
    self.bookListHeaderText = PublishRelay<String>()
    self.showLoadingView = PublishRelay<Bool>()
    self.dismissLoadingView = PublishRelay<Bool>()

    self.inputText
      .distinctUntilChanged()
      .bind { _ in
        self.pageNumber.accept(1)
      }
      .disposed(by: self.disposeBag)

    self.scrollToRequest
      .filter { $0 }
      .withLatestFrom(self.inputText)
      .bind { [weak self] text in
        guard let self = self else { return }
        let lastPageNumber = self.pageNumber.value
        self.pageNumber.accept(lastPageNumber + 10)
        self.inputText.accept(text)
      }
      .disposed(by: self.disposeBag)

    let fetchedBookData = Observable.zip(self.inputText, self.pageNumber.skip(1)) { text, page -> Single<Result<BookListResponse,APINetworkError>> in
      self.showLoadingView.accept(true)
      return useCase.fetchBookData(keyword: text, page: page)
    }
      .flatMap { $0 }
      .map(useCase.bookListResponse)
      .filter {
        self.dismissLoadingView.accept(true)
        return $0 != nil }
      .map { $0! }

    let volumes = fetchedBookData
      .map(useCase.volumes)

    let volumeModel = volumes
      .map(useCase.volumeModel)

    let bookListCellData = volumeModel
      .map(useCase.bookListCellData)

    bookListCellData
      .map {
        if self.pageNumber.value == 1 {
          return [BookListCellSection(items: $0)]
        } else {
          return self.bookListCellSection.value + [BookListCellSection(items: $0)]
        }
      }
      .bind(to: self.bookListCellSection)
      .disposed(by: self.disposeBag)
  }
}
