//
//  APINetworkError.swift
//  BookSearcherApp
//
//  Created by 김민성 on 2022/11/09.
//

import Foundation

enum APINetworkError: Error {

  case networkError
  case decodingError

  var message: String {
    switch self {
    case .networkError:
      return "네트워크 상태를 확인해주세요."
    case .decodingError:
      return "원하는 값으로 변환할 수 없습니다."
    }
  }
}
