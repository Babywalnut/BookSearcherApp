//
//  ThumbnailUseCase.swift
//  BookSearcherApp
//
//  Created by 김민성 on 2022/11/10.
//

import Foundation

class ThumbnailUseCase {

  init() { }

  func fetchURLImage(link: String?) -> Data? {
    guard let link = link else {
      return nil
    }
    let url = URL(string: self.convertedATSURL(link: link))
    if let data = try? Data(contentsOf: url!) {
      return data
    } else {
      return nil
    }
  }

  private func convertedATSURL(link: String) -> String {
    var imageLink = link
    imageLink.insert("s", at: imageLink.index(imageLink.startIndex, offsetBy: 4))
    return imageLink
  }
}
