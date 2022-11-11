//
//  VolumeModel.swift
//  BookSearcherApp
//
//  Created by 김민성 on 2022/11/11.
//

import Foundation

struct ListVolumeModel {
  var id: String?
  var title: String?
  var authors: [String]?
  var publishedDate: String?
  var imageLinks: ImageLink?
}

struct DetailVolumeModel {
  var title: String?
  var publisher: String?
  var publishedDate: String?
  var language: String?
}
