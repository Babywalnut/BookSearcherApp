//
//  NetworkManager.swift
//  BookSearcherApp
//
//  Created by 김민성 on 2022/11/09.
//

import Alamofire
import RxSwift

struct NetworkManager {

  func fetchAllBookData(keyWord: String, page: Int) -> Single<Result<BookListResponse,APINetworkError>> {
    return Single.create { observer -> Disposable in
      AF.request(NetworkRequestRouter.fetchSearchedBookList(keyWord: keyWord, page: page))
        .validate()
        .response { response in
          switch response.result {
          case .success(let data):
            guard let data = data else { return }
            if let response = convertedResponse(data: data) {
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

  func convertedResponse(data: Data) -> BookListResponse? {
    return try? JSONDecoder().decode(BookListResponse.self, from: data)
  }
}

