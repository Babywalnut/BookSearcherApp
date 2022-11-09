//
//  BookSearchUseCase.swift
//  BookSearcherApp
//
//  Created by 김민성 on 2022/11/09.
//

import RxSwift

class BookSearchUseCase {

  // MARK: Properties

  private let network: NetworkManager

  // MARK: Initializer

  init(network: NetworkManager) {
    self.network = network
  }

  func fetchBookData(keyword: String, page: Int) -> Single<Result<BookListResponse, APINetworkError>> {
    return self.network.fetchAllBookData(keyWord: keyword, page: page)
  }

  func bookListResponse(result: Result<BookListResponse, APINetworkError>) -> BookListResponse? {
    guard case .success(let value) = result else {
      return nil
    }
    return value
  }

  func volumes(result: BookListResponse) -> [Volume] {
    guard let data = result.items else { return [] }
    return data
  }

  func volumeInfo(with volumes: [Volume]) -> [VolumeInfo] {
    return volumes
      .map { volume -> VolumeInfo in
        guard let volumeInfo = volume.volumeInfo else { return VolumeInfo() }
        return volumeInfo
      }
  }

  func bookListCellData(with volumeInfo: [VolumeInfo]) -> [BookListCellData] {
    return volumeInfo
      .map {
        return BookListCellData(
          title: $0.title,
          authors: $0.authors,
          publishedDate: $0.publishedDate,
          thumbnailURL: $0.imageLinks?.thumbnail
        )
      }
  }
}
