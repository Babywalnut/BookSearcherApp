//
//  BookListResponse.swift
//  BookSearcherApp
//
//  Created by 김민성 on 2022/11/09.
//

import Foundation

struct BookListResponse: Decodable {
  var kind: String?
  var totalItems: Int?
  var items: [Volume]?
}

struct Volume: Decodable {
  var kind: String?
  var id: String?
  var selfLink: String?
  var volumeInfo: VolumeInfo?
}

struct VolumeInfo: Decodable {
  var title: String?
  var authors: [String]?
  var publisher: String?
  var publishedDate: String?
  var printType: String?
  var imageLinks: ImageLink?
  var language: String?
}

struct ImageLink: Decodable {
  var thumbnail: String?
}

struct ListPrice: Decodable {
  var amount: String?
  var currencyCode: String?
}

