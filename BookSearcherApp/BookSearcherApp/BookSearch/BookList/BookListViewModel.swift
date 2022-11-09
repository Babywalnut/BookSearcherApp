//
//  BookListViewModel.swift
//  BookSearcherApp
//
//  Created by 김민성 on 2022/11/09.
//

import RxSwift
import RxCocoa

protocol BookListViewModelLogic {

  var inputText: BehaviorRelay<String> { get }
  var pageNumber: BehaviorRelay<Int> { get }
}

class BookListViewModel: BookListViewModelLogic {

  // MARK: Properties

  var inputText: BehaviorRelay<String>
  var pageNumber: BehaviorRelay<Int>
  var disposeBag = DisposeBag()

  init(useCase: BookSearchUseCase) {
    self.inputText = BehaviorRelay<String>(value: "")
    self.pageNumber = BehaviorRelay<Int>(value: 1)

    self.inputText
      .bind { _ in
        self.pageNumber.accept(1)
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
  }
}
