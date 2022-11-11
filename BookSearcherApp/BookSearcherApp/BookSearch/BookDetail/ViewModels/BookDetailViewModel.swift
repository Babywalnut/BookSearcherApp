//
//  BookDetailViewModel.swift
//  BookSearcherApp
//
//  Created by 김민성 on 2022/11/10.
//

import RxSwift
import RxRelay

protocol BookDetailViewModelLogic {
  var detailViewData: PublishRelay<DetailVolumeModel> { get set }
  var imageData: PublishRelay<UIImage> { get set }
}

class BookDetailViewModel: BookDetailViewModelLogic {

  // MARK: Properties

  private let disposeBag = DisposeBag()

  // MARK: Properties(Output)

  var detailViewData: PublishRelay<DetailVolumeModel>
  var imageData: PublishRelay<UIImage>

  // MARK: Initializer

  init(useCase: BookInformationUseCase = BookInformationUseCase(), id: String?) {
    self.detailViewData = PublishRelay<DetailVolumeModel>()
    self.imageData = PublishRelay<UIImage>()

    let volume = Observable<String?>.just(id)
      .filter {
        return $0 != nil }
      .map { $0! }
      .map(useCase.fetchBookDetailInformation)
      .flatMap { $0 }
      .map(useCase.volumeResponse)
      .filter { $0 != nil }
      .map { $0! }

    volume
      .map(useCase.volumeModel)
      .bind(to: self.detailViewData)
      .disposed(by: self.disposeBag)

    let volumeImageURL = volume
      .map(useCase.volumeImageURL)

    volumeImageURL
      .map { link -> UIImage in
        guard let imageLink = link else {
          return UIImage(systemName: "book")!
        }
        let cacheKey = NSString(string: imageLink)
        guard let image = CacheManager.shared.cache.object(forKey: cacheKey) else {
          return useCase.fetchURLImage(link: imageLink)
        }
        return image
      }
      .bind(to: self.imageData)
      .disposed(by: self.disposeBag)
  }
}
