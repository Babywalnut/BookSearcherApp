//
//  BookListCellSection.swift
//  BookSearcherApp
//
//  Created by 김민성 on 2022/11/09.
//

import RxDataSources

struct BookListCellSection {
  var items: [Item]
}

extension BookListCellSection: SectionModelType {

  typealias Item = BookListCellData

  init(original: BookListCellSection, items: [BookListCellData]) {
    self = original
    self.items = items
  }
}
