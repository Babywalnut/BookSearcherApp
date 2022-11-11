//
//  BookInformationUseCase.swift
//  BookSearcherApp
//
//  Created by 김민성 on 2022/11/11.
//

import RxSwift

class BookInformationUseCase {

  private let network: BookDetailRepository

  init(network: BookDetailRepository = NetworkManager()) {
    self.network = network
  }

  func fetchBookDetailInformation(id: String) -> Single<Result<Volume, APINetworkError>> {
    return network.fetchBookDetailData(id: id)
  }

  func volumeResponse(result: Result<Volume, APINetworkError>) -> Volume? {
    guard case .success(let value) = result else {
      return nil
    }
    return value
  }

  func volumeModel(with volume: Volume) -> DetailVolumeModel {
    return DetailVolumeModel(
      title: volume.volumeInfo?.title,
      publisher: volume.volumeInfo?.publisher,
      publishedDate: volume.volumeInfo?.publishedDate,
      language: volume.volumeInfo?.language
    )
  }

  func volumeImageURL(with volume: Volume) -> String? {
    if let imageURL = volume.volumeInfo?.imageLinks?.thumbnail {
      return convertedATSURL(link: imageURL)
    }
    return nil
  }

  func fetchURLImage(link: String) -> UIImage {
    guard let dummyImage = UIImage(systemName: "book") else { return UIImage() }
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

  private func convertedATSURL(link: String) -> String {
    var imageLink = link
    imageLink.insert("s", at: imageLink.index(imageLink.startIndex, offsetBy: 4))
    return imageLink
  }
}
