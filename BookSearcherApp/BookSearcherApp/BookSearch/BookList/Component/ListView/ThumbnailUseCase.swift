//
//  ThumbnailUseCase.swift
//  BookSearcherApp
//
//  Created by 김민성 on 2022/11/10.
//

import UIKit

class ThumbnailUseCase {

  init() { }

  func fetchURLImage(link: String) -> UIImage {
    guard let dummyImage = UIImage(systemName: "star") else { return UIImage() }
    let url = URL(string: link)
    if let data = try? Data(contentsOf: url!) {
      guard let image = UIImage(data: data) else {
        return dummyImage
      }
      let cacheKey = NSString(string: link)
      CacheManager.shared.cache.setObject(image, forKey: cacheKey)
      return image
    } else {
      return dummyImage
    }
  }
}
