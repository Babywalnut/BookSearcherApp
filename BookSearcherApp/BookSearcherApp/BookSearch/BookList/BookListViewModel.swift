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
}

class BookListViewModel: BookListViewModelLogic {

  // MARK: Properties

  var inputText: PublishRelay<String>
  var pageNumber: BehaviorRelay<Int>
  var scrollToRequest: PublishRelay<Bool>
  var disposeBag = DisposeBag()

  var bookListCellSection = BehaviorRelay<[BookListCellSection]>(value: [])

  // MARK: Initializer

  init(useCase: BookSearchUseCase) {
    self.inputText = PublishRelay<String>()
    self.pageNumber = BehaviorRelay<Int>(value: 1)
    self.scrollToRequest = PublishRelay<Bool>()

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
        print(lastPageNumber)
        self.pageNumber.accept(lastPageNumber + 10)
        self.inputText.accept(text)
      }
      .disposed(by: self.disposeBag)

    let fetchedBookData = Observable.zip(self.inputText, self.pageNumber.skip(1)) { text, page -> Single<Result<BookListResponse,APINetworkError>> in
      return useCase.fetchBookData(keyword: text, page: page)
    }
      .flatMap { $0 }
      .map(useCase.bookListResponse)
      .filter { $0 != nil }
      .map { $0! }

    let volumes = fetchedBookData
      .map(useCase.volumes)

    let volumeInfo = volumes
      .map(useCase.volumeInfo)

    let bookListCellData = volumeInfo
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
