//
//  CellContentType.swift
//  BookSearcherApp
//
//  Created by 김민성 on 2022/11/11.
//

import Foundation

enum CellContentType: Int, CaseIterable {

  case title
  case authors
  case publishedDate

  var contentsView: ContentsLabel {
    switch self {
    case .title:
      return ContentsLabel(
        textColor: .black,
        fontSize: 20,
        weight: .bold
      )
    case .authors:
      return ContentsLabel(
        textColor: .gray,
        fontSize: 15,
        weight: .regular
      )
    case .publishedDate:
      return ContentsLabel(
        textColor: .gray,
        fontSize: 12,
        weight: .regular
      )
    }
  }
}
