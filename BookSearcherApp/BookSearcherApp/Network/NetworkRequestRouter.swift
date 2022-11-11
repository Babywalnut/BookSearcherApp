//
//  NetworkRequestRouter.swift
//  BookSearcherApp
//
//  Created by 김민성 on 2022/11/09.
//

import Alamofire

enum NetworkRequestRouter: URLRequestConvertible {

  case fetchSearchedBookList(keyWord: String, page: Int)
  case fetchBookDetailInformation(id: String)

  private var baseURLString: String {
    return "https://www.googleapis.com/books/v1"
  }

  private var path: String {
    switch self {
    case .fetchSearchedBookList(let keyWord, let page):
      return "/volumes?q=\(keyWord)&startIndex=\(String(page))&maxResults=10"
    case .fetchBookDetailInformation(let id):
      return "/volumes/\(id)"
    }
  }

  private var HTTPMethod: Alamofire.HTTPMethod {
    return .get
  }

  func asURLRequest() throws -> URLRequest {
    let url = try (self.baseURLString + self.path).asURL()
    var request = URLRequest(url: url)
    request.httpMethod = self.HTTPMethod.rawValue
    request.cachePolicy = .reloadIgnoringCacheData

    switch self {
    case .fetchSearchedBookList:
      return request
    case .fetchBookDetailInformation:
      return request
    }
  }
}

