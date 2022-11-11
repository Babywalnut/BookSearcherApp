//
//  BookSearchUseCase.swift
//  BookSearcherApp
//
//  Created by 김민성 on 2022/11/09.
//

import RxSwift

class BookSearchUseCase {

  // MARK: Properties

  private let network: BookListRepository

  // MARK: Initializer

  init() {
    self.network = NetworkManager()
  }

  func fetchBookData(keyword: String, page: Int) -> Single<Result<BookListResponse, APINetworkError>> {
    return self.network.fetchAllBookData(keyword: keyword, page: page)
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

  func volumeModel(with volumes: [Volume]) -> [ListVolumeModel] {
    return volumes
      .map { volume -> ListVolumeModel in
        guard let volumeInfo = volume.volumeInfo else { return ListVolumeModel() }
        return ListVolumeModel(
          id: volume.id,
          title: volumeInfo.title,
          authors: volumeInfo.authors,
          publishedDate: volumeInfo.publishedDate,
          imageLinks: volumeInfo.imageLinks
        )
      }
  }

  func bookListCellData(with volumeModel: [ListVolumeModel]) -> [BookListCellData] {
    return volumeModel
      .map {
        guard let imageLinks = $0.imageLinks, let thumbnail = imageLinks.thumbnail else {
          return BookListCellData(
            id: $0.id,
            title: $0.title,
            authors: $0.authors,
            publishedDate: $0.publishedDate,
            thumbnailURL: nil
          )
        }
        let convertedThumbnailURL = self.convertedATSURL(link: thumbnail)
        return BookListCellData(
          id: $0.id,
          title: $0.title,
          authors: $0.authors,
          publishedDate: $0.publishedDate,
          thumbnailURL: convertedThumbnailURL
        )
      }
  }

  private func convertedATSURL(link: String) -> String {
    var imageLink = link
    imageLink.insert("s", at: imageLink.index(imageLink.startIndex, offsetBy: 4))
    return imageLink
  }
}
