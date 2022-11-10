//
//  CacheManager.swift
//  BookSearcherApp
//
//  Created by 김민성 on 2022/11/10.
//

import UIKit

class CacheManager {

  // MARK: Properties

  static let shared = CacheManager()
  let cache = NSCache<NSString, UIImage>()

  // MARK: Initializer

  private init() {}
}
