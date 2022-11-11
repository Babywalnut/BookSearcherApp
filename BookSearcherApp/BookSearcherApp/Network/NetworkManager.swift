//
//  NetworkManager.swift
//  BookSearcherApp
//
//  Created by 김민성 on 2022/11/09.
//

import Alamofire
import RxSwift

protocol BookListRepository {
  func fetchAllBookData(keyword: String, page: Int) -> Single<Result<BookListResponse,APINetworkError>>
}

protocol BookDetailRepository {
  func fetchBookDetailData(id: String) -> Single<Result<Volume,APINetworkError>>
}

struct NetworkManager: BookListRepository, BookDetailRepository {

  func fetchAllBookData(keyword: String, page: Int) -> Single<Result<BookListResponse,APINetworkError>> {
    return Single.create { observer -> Disposable in
      AF.request(NetworkRequestRouter.fetchSearchedBookList(keyWord: keyword, page: page))
        .validate()
        .response { response in
          switch response.result {
          case .success(let data):
            guard let data = data else { return }
            if let response = convertedListResponse(data: data) {
              observer(.success(.success(response)))
            } else {
              observer(.success(.failure(APINetworkError.decodingError)))
            }
          case .failure(_):
            observer(.success(.failure(APINetworkError.networkError)))
          }
        }
      return Disposables.create()
    }
  }

  func convertedListResponse(data: Data) -> BookListResponse? {
    return try? JSONDecoder().decode(BookListResponse.self, from: data)
  }

  func fetchBookDetailData(id: String) -> Single<Result<Volume,APINetworkError>> {
    return Single.create { observer -> Disposable in
      AF.request(NetworkRequestRouter.fetchBookDetailInformation(id: id))
        .validate()
        .response { response in
          switch response.result {
          case .success(let data):
            guard let data = data else { return }
            if let response = convertedBookDetailResponse(data: data) {
              observer(.success(.success(response)))
            } else {
              observer(.success(.failure(APINetworkError.decodingError)))
            }
          case .failure(_):
            observer(.success(.failure(APINetworkError.networkError)))
          }
        }
      return Disposables.create()
    }
  }

  func convertedBookDetailResponse(data: Data) -> Volume? {
    return try? JSONDecoder().decode(Volume.self, from: data)
  }
}

